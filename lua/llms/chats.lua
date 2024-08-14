local deepseek = require 'llms.deepseek.provider'

local function input_if_selection(input, context)
  return context.selection and input or ''
end

local deepseek_coder = {
  provider = deepseek,
  system = 'You should replace the code that you are sent, only following the comments. Do not talk at all. Only output valid code. Do not provide any backticks that surround the code. Never ever output backticks like this ```. Any comment that is asking you for something should be removed after you satisfy them. Other comments should left alone. Do not output backticks',
  params = {
    model = 'deepseek-coder',
  },
  create = input_if_selection,
  run = function(messages, config)
    if config.system then
      table.insert(messages, 1, {
        role = 'system',
        content = config.system,
      })
    end
    return { messages = messages }
  end,
}

local chats = {
  ['deepseek:coder'] = deepseek_coder,
}

return chats
