-- lua/plugins/python.lua
return {
  {
    'linux-cultist/venv-selector.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'mfussenegger/nvim-dap',
      'mfussenegger/nvim-dap-python', --optional
      { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },
    },
    event = 'VeryLazy',
    cmd = { 'VenvSelect' },
    keys = {
      { '<leader>vi', '<cmd>VenvSelect<cr>', desc = 'Select Python interpreter' },
    },
    opts = {
      auto_activate = true, -- remembers & reactivates last venv for each project
      require_lsp_activation = true, -- require activation of an lsp before setting env variables
      search = {
        uv_venvs = {
          -- --hidden and --no-ignore  = include hidden dirs (needed for .venv)
          -- --full-path so the pattern can match folders, not just the filename
          command = [[fd --hidden --no-ignore --full-path Scripts\\python.exe C:/Users/giamm/my_projects]],
        },
        mamba_venv = {
          -- --hidden and --no-ignore  = include hidden dirs (needed for .venv)
          -- --full-path so the pattern can match folders, not just the filename
          command = [[fd --full-path python.exe C:/Users/giamm/miniforge3/envs]],
        },
      },
    },
  },
}
