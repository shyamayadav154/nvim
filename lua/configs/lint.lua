local lint = require "lint"

local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd


lint.linters_by_ft = {
    javascript = { "eslint_d" },
    typescript = { "eslint_d" },
    javascriptreact = { "eslint_d" },
    typescriptreact = { "eslint_d" },
    markdown = { "markdownlint" },
    graphql = { "graphql-lsp" },
    zsh = { "zsh" },
}

local cspell = lint.linters.cspell
cspell.args = { "--no-progress", "--no-summary", "--config", vim.fn.expand "~/.config/nvim/lua/configs/cspell/cspell.json" }

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = lint_augroup,
    callback = function()
        require("lint").try_lint()
        require("lint").try_lint "codespell"
        -- require("lint").try_lint "cspell"
    end,
})


local ns = require("lint").get_namespace "cspell"

vim.keymap.set("n", "<leader>lc", function()
    require("lint").try_lint "cspell"
end, { desc = "Check spelling using cspell" })
-- clear diagnostic from cspell using keymap
vim.keymap.set("n", "<leader>cc", function()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.diagnostic.reset(ns, bufnr)
end, { desc = "Clear diagnostic" })

--
-- vim.keymap.set("n", "<leader>cd", function()
--     lint.linters.cspell = require("lint.util").wrap(lint.linters.cspell, function(diagnostic)
--         diagnostic.severity = vim.diagnostic.severity.INFO
--         return nil
--     end)
--     require("lint").try_lint "cspell"
-- end, { desc = "Check spelling using cspell" })
--
vim.keymap.set("n", "<leader>lt", function()
    lint.try_lint()
end, { desc = "Trigger linting for current file" })
