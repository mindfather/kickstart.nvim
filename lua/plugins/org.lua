return {
  'chipsenkbeil/org-roam.nvim',
  tag = '0.1.0',
  dependencies = {
    {
      'nvim-orgmode/orgmode',
      tag = '0.3.4',
    },
  },
  config = function()
    require('org-roam').setup {
      directory = '~/repo/roam',
      ui = {
        node_buffer = {
          unique = true,
        },
      },
      templates = {
        n = {
          description = 'node',
          template = '%?',
          target = 'nodes/%[slug].org',
        },
        p = {
          description = 'page',
          template = '%?',
          target = 'pages/%[slug].org',
        },
      },
    }
  end,
}
