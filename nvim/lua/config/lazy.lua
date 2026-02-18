local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "nvim-lua/plenary.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({})
    end,
  },
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter",
    opts = {
      ensure_installed = { "bash", "lua", "python", "javascript", "json", "yaml", "markdown" },
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local servers = { "lua_ls", "bashls", "pyright", "ts_ls" }
      if vim.lsp and vim.lsp.enable then
        vim.lsp.enable(servers)
      else
        local lspconfig = require("lspconfig")
        for _, server in ipairs(servers) do
          if lspconfig[server] then
            lspconfig[server].setup({})
          end
        end
      end
    end,
  },
})
