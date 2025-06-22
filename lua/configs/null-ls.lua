local present, null_ls = pcall(require, "null-ls")
-- local cspell = require('cspell')

if not present then
  return
end

local b = null_ls.builtins

-- custom code action snippet
-- require'null-ls'.register({
--     name = 'my-actions',
--     method = {null_ls.methods.CODE_ACTION},
--     filetypes = { '_all' },
--     generator = {
--         fn = function()
--             return {{
--                 title = 'add "hi mom"',
--                 action = function()
--                     local current_row = vim.api.nvim_win_get_cursor(0)[1]
--                     vim.api.nvim_buf_set_lines(0, current_row, current_row, true, {'hi mom'})
--                 end
--             }}
--         end
--     }
-- })

local sources = {

  -- webdev stuff
  b.formatting.prettier.with {
    filetypes = {
      "html",
      -- "json",
      "yaml",
      "markdown",
      "css",
      "scss",
      "less",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
      "svelte",
    },
  },
  -- b.formatting.prettierd,

  b.diagnostics.zsh,
  b.formatting.shfmt,
  -- b.diagnostics.markdownlint,
  -- b.formatting.markdownlint,

  -- b.formatting.yamlfmt,

  -- b.diagnostics.dotenv_linter,

  -- b.diagnostics.editorconfig_checker,
  b.code_actions.refactoring,

  --codespell
  -- b.diagnostics.codespell,
  -- b.formatting.codespell,

  -- b.completion.spell,
  -- b.completion.tags,

  -- Lua
  b.formatting.stylua,

  -- b.diagnostics.ruff,
  -- b.formatting.ruff_format,
  -- b.formatting.black.with {
  --     filetypes = { "python" }
  -- },

  -- cspell.diagnostics,
  -- cspell.code_actions,
}

null_ls.setup {
  debug = true,
  sources = sources,
}
