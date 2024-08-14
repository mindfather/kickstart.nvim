return {
  'gsuuon/model.nvim',

  cmd = { 'M', 'Model', 'Mchat' },

  init = function()
    vim.filetype.add {
      extension = {
        mchat = 'mchat',
      },
    }
  end,

  ft = 'mchat',

  keys = {
    { '<leader>mmd', ':vertical Mchat deepseek-coder<cr>', mode = 'n', { desc = ' Deepseek Coder' } },
    { '<leader>md', ':Mdelete<cr>', mode = 'n' },
    { '<leader>ms', ':Mselect<cr>', mode = 'n' },
    { '<leader>mc', ':Mchat<cr>', mode = 'n' },
  },

  config = function()
    local deepseek = require 'model.providers.openai'
    deepseek.initialize {
      model = 'deepseek-coder',
      temperature = 0.3,
      max_tokens = 8000,
    }

    local util = require 'model.util'
    local qflist = require 'model.util.qflist'

    require('model').setup {
      hl_group = 'Substitute',
      prompts = util.module.autoload 'prompt_library',
      chats = {
        ['deepseek-coder'] = {
          provider = deepseek,
          system = 'You should replace the code that you are sent, only following the comments. Do not talk at all. Only output valid code. Do not provide any backticks that surround the code. Never ever output backticks like this ```. Any comment that is asking you for something should be removed after you satisfy them. Other comments should left alone. Do not output backticks',
          params = {
            model = 'deepseek-coder',
          },
          options = {
            url = 'https://api.deepseek.com/beta/v1/',
            authorization = 'Bearer ' .. vim.env.DEEPSEEK_API_KEY,
          },
          create = function()
            return qflist.get_text()
          end,
          run = function(messages, config)
            if config.system then
              table.insert(messages, 1, {
                role = 'system',
                content = config.system,
              })
            end
            return { messages = messages }
          end,
        },
      },
      default_prompt = {
        provider = deepseek,
        builder = function(input)
          return {
            messages = {
              {
                role = 'system',
                content = 'You should replace the code that you are sent, only following the comments. Do not talk at all. Only output valid code. Do not provide any backticks that surround the code. Never ever output backticks like this ```. Any comment that is asking you for something should be removed after you satisfy them. Other comments should left alone. Do not output backticks',
              },
              { role = 'user', content = input },
            },
          }
        end,
      },
    }
    -- local deepseek = require 'modelproviders.deepseek'
    -- require('model').setup {
    --   hl_group = 'Substitute',
    --   prompts = {
    --     ['deepseek:coder'] = deepseek.default_prompt,
    --   },
    --   default_prompt = deepseek.default_prompt,
    -- }
  end,
}

-- return {
--   'melbaldove/llm.nvim',
--   dependencies = { 'nvim-neotest/nvim-nio' },
--   config = function()
--     require('llm').setup {
--       -- How long to wait for the request to start returning data.
--       timeout_ms = 3000,
--       services = {
--         -- Extra OpenAI-compatible services to add (optional)
--         deepseek = {
--           url = 'https://api.deepseek.com/chat/completions',
--           model = 'deepseek-coder',
--           api_key_name = 'DEEPSEEK_API_KEY',
--         },
--       },
--     }
--     vim.keymap.set('n', '<leader>m', function()
--       require('llm').create_llm_md()
--     end, { desc = 'Create llm.md' })
--
--     -- keybinds for prompting with deepseek
--     vim.keymap.set('n', '<leader>,', function()
--       require('llm').prompt { replace = false, service = 'deepseek' }
--     end, { desc = 'Prompt with deepseek' })
--     vim.keymap.set('v', '<leader>,', function()
--       require('llm').prompt { replace = false, service = 'deepseek' }
--     end, { desc = 'Prompt with deepseek' })
--     vim.keymap.set('v', '<leader>.', function()
--       require('llm').prompt { replace = true, service = 'deepseek' }
--     end, { desc = 'Prompt while replacing with deepseek' })
--     vim.keymap.set('n', 'g,', function()
--       require('llm').prompt_operatorfunc { replace = false, service = 'deepseek' }
--     end, { desc = 'Prompt with deepsee' })
--     vim.keymap.set('n', 'g.', function()
--       require('llm').prompt_operatorfunc { replace = true, service = 'deepseek' }
--     end, { desc = 'Prompt while replacing with deepsee' })
--   end,
-- }
