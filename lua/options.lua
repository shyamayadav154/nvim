require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

local autocmd = vim.api.nvim_create_autocmd

vim.api.nvim_create_user_command("Normy", function ()
  vim.wo.relativenumber = not vim.wo.relativenumber
  vim.cmd("SmearCursorToggle")
end,{})


--- vim-dadbod-completion autocomand
autocmd("FileType", {
  pattern = { "sql", "mysql", "plsql" },
  callback = function()
    require("cmp").setup.buffer({ sources = {{ name = "vim-dadbod-completion" }} })
  end,
})

-- autocmd("FileType", {
--   pattern = { "sql" },
--   command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
-- })
--
-- autocmd("FileType", {
--   pattern = { "sql", "mysql", "plsql" },
--   callback = function()
--     vim.schedule(db_completion)
--     vim.cmd[[ASToggle]]
--   end,
-- })


-- Add autocommands for Prisma files
local prisma_group = vim.api.nvim_create_augroup("PrismaModalContextAtTop", { clear = true })

autocmd("BufEnter", {
  group = prisma_group,
  pattern = "*.prisma",
  command = "ContextEnable"
})
autocmd("BufLeave", {
  group = prisma_group,
  pattern = "*.prisma",
  command = "ContextDisable"
})

local augroup = vim.api.nvim_create_augroup("ClaudeCodeFileRefresh", { clear = true })
local refresh_timer = nil

--- add autocmd on TermOpen to Create a timer to check for file changes periodically
autocmd({ "TermOpen", "TermEnter" }, {
  group = augroup,
  pattern = "*",
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    local buf_name = vim.api.nvim_buf_get_name(buf)
    if buf_name:match "claude" then
      -- Clean up any existing timer
      if refresh_timer then
        refresh_timer:stop()
        refresh_timer:close()
        refresh_timer = nil
      end

      -- Create a timer to check for file changes periodically
      refresh_timer = vim.loop.new_timer()
      if refresh_timer then
        refresh_timer:start(
          0,
          1000,
          vim.schedule_wrap(function()
            vim.cmd "silent! checktime"
          end)
        )
      end
    end
  end,
})

--- add autocmd on TermOpen to Create a timer to check for file changes periodically
autocmd("TermClose", {
  group = augroup,
  pattern = "*",
  callback = function()
    if refresh_timer then
      print "Stopping refresh timer"
      refresh_timer:stop()
      refresh_timer:close()
      refresh_timer = nil
    end
  end,
})

-- Create an autocommand that notifies when a file has been changed externally
-- autocmd("FileChangedShellPost", {
--   group = augroup,
--   pattern = "*",
--   callback = function()
--     vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.INFO)
--     -- clear the notification after 1 seconds
--     vim.defer_fn(function()
--       vim.notify ""
--     end, 1000)
--   end,
--   desc = "Notify when a file is changed externally",
-- })

vim.api.nvim_create_autocmd({
  "CursorHold",
  "CursorHoldI",
  "FocusGained",
  "BufEnter",
  "InsertLeave",
  "TextChanged",
  "TermLeave",
  "TermEnter",
  "BufWinEnter",
  "WinScrolled",
}, {
  group = augroup,
  pattern = "*",
  callback = function()
    if vim.fn.filereadable(vim.fn.expand "%") == 1 then
      vim.cmd "checktime"
    end
  end,
  desc = "Check for file changes on disk",
})

local Snacks = require "snacks"
local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
vim.api.nvim_create_autocmd("User", {
  pattern = "NvimTreeSetup",
  callback = function()
    local events = require("nvim-tree.api").events
    events.subscribe(events.Event.NodeRenamed, function(data)
      if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
        data = data
        Snacks.rename.on_rename_file(data.old_name, data.new_name)
      end
    end)
  end,
})

-- we don't format using the same lsp for js we use prettier, for python we use ruff/black, so it shows flicker
-- autocmd("BufWritePre", {
--   -- pattern = "*",
--   pattern = { "*.py" },
--   callback = function()
--     vim.lsp.buf.format()
--   end,
-- })

-- autocmd('User', {
--     pattern = 'AutoSaveWritePost',
--     group = group,
--     callback = function(opts)
--         if opts.data.saved_buffer ~= nil then
--             local filename = vim.api.nvim_buf_get_name(opts.data.saved_buffer)
--             print('AutoSave: saved ' .. filename .. ' at ' .. vim.fn.strftime('%H:%M:%S'))
--         end
--     end,
-- })

vim.filetype.add {
  extension = {
    mdx = "mdx",
  },
}
require("hlslens").setup()

vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#20303b" })
vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#37222c" })
vim.api.nvim_set_hl(0, "DiffChange", { bg = "#1f2231" })
vim.api.nvim_set_hl(0, "DiffText", { bg = "#394b70" })

local kopts = { noremap = true, silent = true }

vim.api.nvim_set_keymap(
  "n",
  "n",
  [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
  kopts
)
vim.api.nvim_set_keymap(
  "n",
  "N",
  [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
  kopts
)
vim.api.nvim_set_keymap("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

vim.api.nvim_set_keymap("n", "<Leader>l", "<Cmd>noh<CR>", kopts)

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
      vim.cmd("silent! !open " .. "'" .. link .. "'")
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

-- autocmd("VimResized", {
--     pattern = "*",
--     command = "tabdo wincmd =",
-- })

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
vim.g.snipmate_snippets_path = "~/.config/nvim/lua/configs/snippets"

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

-- diffview nvim options
vim.opt.fillchars:append { diff = "╱" }
vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "diff",
  callback = function()
    if vim.opt.diff:get() then
      -- onedark theme colors
      local c = {
        dark_gray = "#282C34",
        red = "#E06C75",
        green = "#98C379",
        yellow = "#E5C07B",
        blue = "#61AFEF",
        purple = "#C678DD",
        cyan = "#56B6C2",
        light_gray = "#ABB2BF",
        black = "#000000",
      }

      vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#34462F" })
      vim.api.nvim_set_hl(0, "DiffChange", { bg = "#2F4146" })
      vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#462F2F" })
      vim.api.nvim_set_hl(0, "DiffText", { bg = "#463C2F" })

      -- vim.api.nvim_set_hl(0, "DiffAdd", { bg = c.green, fg = c.black }) -- Added lines
      -- vim.api.nvim_set_hl(0, "DiffChange", { bg = c.yellow, fg = c.black }) -- Changed lines)
      -- vim.api.nvim_set_hl(0, "DiffDelete", { bg = c.red, fg = c.black }) -- Deleted lines
      -- vim.api.nvim_set_hl(0, "DiffText", { bg = c.black, fg = c.yellow }) -- Changed text within a line
    end
  end,
})
