require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

local autocmd = vim.api.nvim_create_autocmd

vim.filetype.add {
    extension = {
        mdx = "markdown.mdx",
    },
}
require('hlslens').setup()

local kopts = {noremap = true, silent = true}

vim.api.nvim_set_keymap('n', 'n',
    [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
    kopts)
vim.api.nvim_set_keymap('n', 'N',
    [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
    kopts)
vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

vim.api.nvim_set_keymap('n', '<Leader>l', '<Cmd>noh<CR>', kopts)


local map = vim.keymap.set

autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-goto-last-insert", { clear = true }),
    callback = function(event)

        -- remap gi to move to last insertion and go to website
        vim.api.nvim_buf_set_keymap(event.buf, "n", "gi", "gi<ESC>zza", { noremap = true, silent = true })
        -- remap to open url with #
        map("n", "gx", function()
            local word = vim.fn.expand "<cWORD>"
            -- replace # with \#
            local link = string.gsub(word, "#", "\\#")
            -- run cmd to open the word in browser
            print("opening... " .. link)
            vim.cmd("silent! !open " .."'".. link.. "'")
        end, { noremap = true, silent = true })
        -- map("n", "gx",'gx')
    end,
})

-- doesn't play well with current theme (onedark)
autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-highlight", { clear = true }),
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        if client and client.server_capabilities.documentHighlightProvider then
            -- nvim illuminate highlights
            -- vim.cmd('hi IlluminatedWordText guibg=none gui=underline')
            -- vim.cmd('hi IlluminatedWordRead guibg=none gui=underline')
            -- vim.cmd('hi IlluminatedWordWrite guibg=none gui=underline')

            vim.cmd [[ hi LspReferenceRead guibg=#323641 guifg=nil  ]]
            vim.cmd [[ hi LspReferenceWrite guibg=#323641 guifg=nil   ]]
            vim.cmd [[ hi LspReferenceText guibg=#323641 guifg=nil  ]]

            -- treesitter highlights
            -- vim.cmd([[ hi TreesitterContextBottom guibg=#323641  guisp=Grey ]])
            -- vim.cmd([[ hi TreesitterContextLineNumberBottom guibg=#323641 guisp=Grey ]])

            -- one dark theme replicate vscod
            -- vim.cmd[[ hi @punctuation.bracket guifg=#c678dd ]]
            -- vim.cmd [[ hi @variable guifg=#E5C07B  ]]
            -- vim.cmd [[ hi Identifier guifg=#E5C07B  ]]
            -- to fix the color incorrectness of typescript-tool for nvim stable
            -- vim.cmd [[ hi Identifier guifg=#abb2bf  ]]
            -- vim.cmd [[hi @keyword guifg=#C678DD ]]

            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                group = "lsp-highlight",
                buffer = event.buf,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                group = "lsp-highlight",
                buffer = event.buf,
                callback = vim.lsp.buf.clear_references,
            })
        end
    end,
})

-- lsp detact
autocmd("LspDetach", {
    pattern = "*",
    command = "autocmd! lsp-highlight",
})

-- highlights yankgc
autocmd("TextYankPost", {
    pattern = "*",
    command = "silent! lua vim.highlight.on_yank()",
})

-- autoc command to convert c Tab into const in javascript file
autocmd("FileType", {
    pattern = { "javascript", "typescript", "typescriptreact", "javascriptreact" },
    command = "inoremap <buffer> c<Tab> const ",
})

-- autocmd("BufReadPost", {
--     pattern = "*",
--     command = "TSContextEnable",
-- })

-- autocmd('UIEnter', {
--     group = vim.api.nvim_create_augroup("last-file-open", { clear = true }),
--     command = "norm! `0"
-- })

-- autocmd("TextChanged", {
--   pattern = "*",
--   command = "silent! update",
-- })

-- autocmd("InsertLeave", {
--   pattern = "*",
--   command = "silent! update",
-- })

-- got to last loc
autocmd("BufReadPost", {
    pattern = "*",
    command = [[if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]],
})

autocmd("VimResized", {
    pattern = "*",
    command = "tabdo wincmd =",
})

local vim = vim

-- set netrw browser
-- vim.g.netrw_browser_viewer = "open"
-- vim.g.netrw_browsex_viewer = "open"
-- vim.g.netrw_http_cmd = "open"

vim.opt.cursorline = true

if vim.g.neovide then
    vim.opt.guifont = "FiraCode Nerd Font:h12"
    vim.g.neovide_transparency = 0.9
    vim.g.neovide_scale_factor = 1
end

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.expandtab = true

vim.opt.breakindent = true
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append "@-@"

vim.opt.updatetime = 50
vim.opt.inccommand = "split"

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.colorcolumn = "120"
vim.opt.spelllang = "en_us"
vim.opt.spell = true
-- vscode format i.e json files
vim.g.vscode_snippets_path = "~/.config/nvim/lua/configs/vs_snippets"

-- snipmate format
vim.g.snipmate_snippets_path = "~/.jkonfig/nvim/lua/configs/snippets"

-- lua format
vim.g.lua_snippets_path = "~/.config/nvim/lua/configs/lua_snippets"

-- quickfixl list modifiable
vim.opt.filetype = "on"

vim.o.cursorlineopt = "both"
-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3


-- nvim ufo
-- vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
