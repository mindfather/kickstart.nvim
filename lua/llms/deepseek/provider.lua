local util = require 'model.util'
local sse = require 'model.util.sse'

local M = {}

local default_params = {
  model = 'deepseek-coder',
  stream = true,
}

local function extract_data(d)
  local data = util.json.decode(d)

  if data ~= nil and data.choices ~= nil then
    return {
      content = (data.choices[1].message or {}).content,
      finish_reason = data.choices[1].finish_reason,
    }
  end
end

M.default_prompt = {
  provider = M,
  builder = function(input)
    return {
      messages = {
        {
          role = 'system',
          content = 'You should replace the code that you are sent, only following the comments. Do not talk at all. Only output valid code. Do not provide any backticks that surround the code. Never ever output backticks like this ```. Any comment that is asking you for something should be removed after you satisfy them. Other comments should left alone. Do not output backticks',
        },
        {
          role = 'user',
          content = input,
        },
      },
    }
  end,
}

function M.request_completion(handlers, params, options)
  options = options or {}

  local headers = {
    Authorization = 'Bearer ' .. vim.env.DEEPSEEK_API_KEY,
    ['Content-Type'] = 'application/json',
  }

  local endpoint = options.endpoint or 'chat/completions'

  local completion = ''

  return sse.curl_client({
    url = 'https://api.deepseek.com/' .. endpoint,
    headers = headers,
    method = 'POST',
    body = vim.tbl_deep_extend('force', default_params, params),
  }, {
    on_message = function(message)
      local data = extract_data(message.data)
      if data == nil then
        if not message.data == '[DONE]' then
          handlers.on_error(
            vim.inspect {
              data = message.data,
              pending = pending,
            },
            'Unrecognized message data'
          )
        end
      else
        if data.content ~= nil then
          completion = completion .. data.content
          handlers.on_partial(data.content)
        end

        if data.finish_reason ~= nil then
          handlers.on_finish(completion, data.finish_reason)
        end
      end
    end,
    on_other = function(content)
      handlers.on_error(content, 'Unknown DeepSeek API Response')
    end,
    on_error = function(content)
      handlers.on_error(content, 'DeepSeek API Error')
    end,
  })
end

--- Sets default openai provider params. Currently enforces `stream = true`.
function M.initialize(opts)
  default_params = vim.tbl_deep_extend('force', default_params, opts or {}, {
    stream = true, -- force streaming since data parsing will break otherwise
  })
end

-- These are convenience exports for building prompt params specific to this provider
M.prompt = {}

function M.prompt.input_as_message(input)
  return {
    role = 'user',
    content = input,
  }
end

function M.prompt.add_args_as_last_message(messages, context)
  if #context.args > 0 then
    table.insert(messages, {
      role = 'user',
      content = context.args,
    })
  end

  return messages
end

function M.prompt.input_and_args_as_messages(input, context)
  return {
    messages = M.add_args_as_last_message(M.input_as_message(input), context),
  }
end

function M.prompt.with_system_message(text)
  return function(input, context)
    local body = M.input_and_args_as_messages(input, context)

    table.insert(body.messages, 1, {
      role = 'system',
      content = text,
    })

    return body
  end
end

return M
