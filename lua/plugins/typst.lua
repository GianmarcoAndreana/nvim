-- plugins/typst-preview.lua
return {
  'chomosuke/typst-preview.nvim',
  lazy = false, -- or ft = 'typst'
  version = '1.*',
  opts = {
    debug = false,
    open_cmd = nil,
    port = 0,
    invert_colors = 'never',
    follow_cursor = true,
    dependencies_bin = {
      ['tinymist'] = nil,
      ['websocat'] = nil,
    },
    extra_args = nil,
    get_root = function(path_of_main_file)
      local root = os.getenv 'TYPST_ROOT'
      if root then
        return root
      end
      return vim.fn.fnamemodify(path_of_main_file, ':p:h')
    end,
    get_main_file = function(path_of_buffer)
      return path_of_buffer
    end,
  },
  keys = {
    { "<leader>tp", "<cmd>TypstPreview<cr>", desc = "Start Typst Preview" },
    { "<leader>tq", "<cmd>TypstPreviewStop<cr>", desc = "Stop Typst Preview" },
    { "<leader>tt", "<cmd>TypstPreviewToggle<cr>", desc = "Toggle Typst Preview" },
    { "<leader>tr", "<cmd>TypstPreviewRefresh<cr>", desc = "Refresh Typst Preview" },
  },
  init = function()
    -- Auto-generate PDF on save
    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = "*.typ",
      callback = function(args)
        -- Compile with typst (requires typst CLI installed)
        local input = args.file
        local output = vim.fn.fnamemodify(input, ":r") .. ".pdf"
        vim.fn.jobstart({ "typst", "compile", input, output }, {
          on_exit = function(_, code)
            if code == 0 then
              vim.notify("Typst PDF generated: " .. output, vim.log.levels.INFO)
            else
              vim.notify("Typst PDF generation failed!", vim.log.levels.ERROR)
            end
          end,
        })
      end,
    })
  end,
}
