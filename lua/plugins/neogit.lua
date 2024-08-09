return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-telescope/telescope.nvim', -- optional
    'nvim-lua/plenary.nvim', -- required
    'sindrets/diffview.nvim', -- optional - Diff integration
  },
  config = true,
  keys = {
    { '<leader>gr', ':Neogit<CR>', desc = 'Neogit Reveal' },
  },
}
