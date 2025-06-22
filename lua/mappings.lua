require "nvchad.mappings"

local map = vim.keymap.set
local nomap = vim.keymap.del


nomap("n", "<leader>n") -- relative line number toggle disabled
nomap("n", "<leader>b") -- git sign blame disabled
-- if has keymap at leader gb then remap

-- terminal keymaps remove
nomap("n", "<leader>h")
nomap("n", "<M-i>")

-- in terminal mode double esc press should go to normal mode
-- map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Go to normal mode in terminal" })

map("t", "%a", function()
  local all_buffers = vim.api.nvim_list_bufs()
  print(vim.inspect(all_buffers))
  local buffer_list = {}
  for _, buf in ipairs(all_buffers) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local name = vim.api.nvim_buf_get_name(buf)
      local relative_name = vim.fn.fnamemodify(name, ":~:.")
      -- local full_path = vim.fn.fnamemodify(name, ":p")
      -- ignore if term
      if name:find "term://" then
        goto continue
      end
      if name ~= "" then
        -- echo
        vim.cmd("ClaudeCodeAdd " .. relative_name)
        -- vim.cmd("echo 'Buffer: " .. relative_name .. "'")
        table.insert(buffer_list, relative_name)
      end
    end
    ::continue::
  end
  print("Added buffers to Claude Code: " .. table.concat(buffer_list, ", "))

end, { desc = "Add opened buffer files to claude code" })

-- Add this to your init.lua or a separate config file
map("t", "%%", function()
  local buffers = vim.api.nvim_list_bufs()
  local current_buf = vim.api.nvim_get_current_buf()
  local last_buffer = nil

  -- Find the most recently used buffer that isn't the current one and isn't a terminal
  for _, buf in ipairs(buffers) do
    if vim.api.nvim_buf_is_loaded(buf) and buf ~= current_buf then
      local buf_name = vim.api.nvim_buf_get_name(buf)
      local buf_type = vim.api.nvim_buf_get_option(buf, "buftype")

      -- Skip terminal buffers and other special buffer types
      if buf_type ~= "terminal" and buf_type ~= "nofile" and buf_name ~= "" then
        local last_used = vim.fn.getbufinfo(buf)[1].lastused
        if not last_buffer or last_used > vim.fn.getbufinfo(last_buffer)[1].lastused then
          last_buffer = buf
        end
      end
    end
  end

  if last_buffer then
    local buf_name = vim.api.nvim_buf_get_name(last_buffer)
    local relative_name = vim.fn.fnamemodify(buf_name, ":~:.") -- Get relative path
    vim.cmd("ClaudeCodeAdd " .. relative_name)
    -- local short_name = vim.fn.fnamemodify(buf_name, ":t") -- Get just the filename
    -- print("Last viewed buffer: " .. short_name .. " (Buffer #" .. last_buffer .. ")")
  else
    print "No previous buffer found"
  end
end, { desc = "Add last viewed viewed buffer to claude code" })


map("n", "<leader>lq", function()
  vim.cmd [[set makeprg=eslint\ -f\ unix\ --quiet\ . ]]
  vim.cmd [[silent! make]]
  vim.cmd [[copen]]
end, { desc = "Lint and populate quickfix" })

vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")

-- show diagnostic under the cursor
map("n", "<leader>lf", function()
  vim.diagnostic.open_float()
end, { desc = "Show diagnostic under the cursor" })

-- local builtin = require "telescope.builtin"
-- local actions = require "telescope.actions"

-- Custom function to grep through git status files
-- function LiveGrepGitStatus()
--   local git_files = vim.fn.systemlist "git status --porcelain | awk '{print $2}'"
--   -- print
--   print(git_files)
--   builtin.live_grep {
--     search_dirs = git_files,
--     prompt_title = "Live Grep on Git Status",
--   }
-- end
--
-- map("n", "<leader>gw", LiveGrepGitStatus, { desc = "Live Grep on Git Status" })

require("hlslens").setup()

local kopts = { noremap = true, silent = true }

-- avante chat keymap
map("n", "<leader>an", "<cmd>AvanteChat<CR>", { desc = "Open Avante Chat" })

-- vim.keymap.set("n", "<Leader>l", "<Cmd>noh<CR>", kopts)

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
map("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
map("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
-- peek
map("n", "zK", function()
  local winid = require("ufo").peekFoldedLinesUnderCursor()
  if not winid then
    -- choose one of coc.nvim and nvim lsp
    vim.fn.CocActionAsync "definitionHover" -- coc.nvim
    vim.lsp.buf.hover()
  end
end)

-- delete console from current page
map("n", "<leader>cd", "<cmd>g/console/norm dd<CR>", { desc = "Delete console from current file/buffer" })
-- floating window diagnostics
-- map("n", "<leader>lf", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "Delete console from current file/buffer" })

map("n", "<leader>cl", function()
  local word = vim.fn.expand "<cword>" -- Get the word under the cursor
  local wrapped_word = "\tconsole.log({" .. word .. "})" -- Wrap the word with brackets
  local cursor_pos = vim.fn.getcurpos() -- Get the current cursor position
  -- add the wrapped word to the new next line
  vim.fn.append(cursor_pos[2], wrapped_word)
end, { desc = "Generate console for word under cursor" })

map("n", "<leader>cdi", function()
  local word = vim.fn.expand "<cword>" -- Get the word under the cursor
  local wrapped_word = "\tconsole.dir(" .. word .. ",{ depth: Infinity })" -- Wrap the word with brackets
  local cursor_pos = vim.fn.getcurpos() -- Get the current cursor position
  -- add the wrapped word to the new next line
  vim.fn.append(cursor_pos[2], wrapped_word)
end, { desc = "Generate console for word under cursor" })

-- diffview
map("n", "<leader>do", "<cmd>DiffviewOpen<CR>", { desc = "Open DiffView" })
map("n", "<leader>dc", "<cmd>DiffviewClose<CR>", { desc = "Close DiffView" })
map("n", "<leader>df", "<cmd>DiffviewFileHistory %<CR>", { desc = "Close DiffView" })

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { nowait = true, silent = true, desc = "Clear highlights" })
-- auto save toggle
-- map("n", "<leader>n", ":ASToggle<CR>", {desc = "Toggle autosave"})

map("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', {
  desc = "Toggle Spectre",
})

-- map("n", "<leader>cco", function()
--   local input = vim.fn.input "Quick Chat: "
--   if input ~= "" then
--     require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
--   end
-- end, { desc = "Quick Chat" })

-- map("n", "<leader>tch", function()
--   local actions = require "CopilotChat.actions"
--   require("CopilotChat.integrations.telescope").pick(actions.help_actions())
-- end, { desc = "Copilot help action" })

-- map("n", "<leader>tcp", function()
--   local actions = require "CopilotChat.actions"
--   require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
-- end, { desc = "Copilot prompt action" })

-- another text

-- this is the test

-- map("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
--     desc = "Search current word",
-- })
--
-- map("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
--     desc = "Search current word",
-- })
--
-- map("n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
--     desc = "Search on current file",
-- })

-- diagnostic go to
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go { severity = severity }
  end
end

map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- in select mode paste without losing
map("v", "<leader>p", '"_dP', { desc = "Paste without losing" })
-- map("n", "<leader>p", '"_dP', { desc = "Paste without losing" })
map("i", "<A-n>", "<CMD>lua require('luasnip').jump(1)<CR>", { desc = "Jump onestep", silent = true })
map("i", "<A-p>", "<CMD>lua require('luasnip').jump(-1)<CR>", { desc = "Jump onestep", silent = true })
map("i", "<A-e>", "<CMD>lua require('luasnip').expand_or_jump()<CR>", { desc = "Jump onestep", silent = true })
map("n", ";", ":", { desc = "enter command mode", nowait = true })
map("n", "<leader>qu", ":lua unique_quickfix_list()<CR>", { desc = "Unique quickfix list" })
map("n", "<leader>ph", "<CMD>Gitsigns preview_hunk<CR>", { desc = "Preview Hunk" })
map("n", "<leader>rh", "<CMD>Gitsigns reset_hunk<CR>", { desc = "Reset Hunk" })
map("n", "<leader>dl", "<CMD>diffget //2<CR>", { desc = "Diff get right" })
map("n", "<leader>dh", "<CMD>diffget //3<CR>", { desc = "Diff get left" })

map("n", "n", "nzzzv", { desc = "Cursor center search" })
map("n", "N", "Nzzzv", { desc = "Cursor center search" })

map("n", "gj", "<C-w>j", { desc = "Go to window below" })
map("n", "gk", "<C-w>k", { desc = "Go to window above" })
map("n", "gH", "<C-w>h", { desc = "Go to window left" })
map("n", "gL", "<C-w>l", { desc = "Go to window right" })
-- move to the window on the left
map({ "n", "t" }, "<C-h>", "<C-w>h", { desc = "Go to window left" })

-- Keymap for LSP references
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { desc = "LSP References in quickfix" })

map("n", "<C-f>", ":silent !tmux neww ts<CR>", { desc = "Open new tmux window" })
map("n", "<leader>gr", function()
  require("gitsigns").reset_buffer()
  print "reset file to last commit"
end, { desc = "Git reset current file" })
map("n", "<leader>gs", "<CMD>Gitsigns stage_hunk<CR>", { desc = "Git stage current hunk" })

map("n", "<leader>ih", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints", silent = true })

-- Telescope searches
map(
  "n",
  "<leader>ff",
  "<CMD>Telescope find_files hidden=true find_command=rg,--files,--hidden,--glob,!.git <CR>",
  { desc = "Find Files hidden too" }
)

-- Telescope searches
map("n", "<leader>fw", "<CMD>Telescope live_grep_args<CR>", { desc = "search words with regex" })

-- telescope old files
map("n", "<leader>fo", function()
  require("telescope.builtin").oldfiles {
    cwd_only = true,
  }
end, { desc = "Find old files in current directory" })

map("n", "<leader>gf", "<CMD>Telescop git_status<CR>", { desc = "git status" })
map("n", "<leader>fr", "<CMD>Telescope lsp_references<CR>", { desc = "telescope lsp references" })
map("n", "<leader>fs", "<CMD>Telescope grep_string<CR>", { desc = " telescope find string under cursor" })
map("n", "<leader>ws", "<CMD>Telescope lsp_dynamic_workspace_symbols<CR>", { desc = "lsp dynamic workspace symbol" })
map("n", "<leader>b", "<cmd>Telescope git_branches<CR>", { desc = "Git Branches" })
map("n", "<leader>tb", "<CMD>Telescope builtin<CR>", { desc = "Telescope builtins" })
map("n", "<leader>tr", "<CMD>Telescope resume<CR>", { desc = "Telescope builtins" })

map("n", "gl", "<cmd>b#<CR>", { desc = "Go to last buffer" })
map(
  "n",
  "<leader>rq",
  "^ds[dWarefetch:<Esc>p/use<CR>dwiuseQuery<Esc>",
  { desc = "Replaces useLazyQuery with useQuery", remap = true, silent = true }
)

-- go to mapping
map("n", "[g", "<cmd>lua require'gitsigns'.prev_hunk()<CR>", { desc = "Previous Hunk" })
map("n", "]g", "<cmd>lua require'gitsigns'.next_hunk()<CR>", { desc = "Next Hunk" })
map("n", "]t", ":lua require('todo-comments').jump_next()<CR>", { desc = "Next Todo comment" })
map("n", "[t", ":lua require('todo-comments').jump_prev()<CR>", { desc = "Previous Todo comment" })

-- map("n", "gi", "gi", { desc = "move to last insertion and insert" })

map("n", "gT", ":lua require('nvchad.tabufline').move_buf(-1)<CR>", { silent = true, desc = "Move to previous buffer" })
map("n", "gt", ":lua require('nvchad.tabufline').move_buf(1)<CR>", { silent = true, desc = "Move to next buffer" })

-- lsp related
-- map("n", "<leader>o", "<CMD>OrganizeImports<CR>", { desc = "Organize imports tss lsp" })
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })
map("n", "<leader>lr", ":LspRestart<CR>", { desc = "Restart LSP" })

-- window related
map("n", "<leader>hh", "<cmd>vertical resize +10<CR>", { desc = "Resize window left" })
map("n", "<leader>ll", "<cmd>vertical resize -10<CR>", { desc = "Resize window right" })

-- map("n", "<esc>", ":w<CR>", { desc = "Save on double esc press" })

map("n", "[tc", "<CMD>lua require('treesitter-context').go_to_context()<CR>", { desc = "go to treesitter context" })

map("n", "<leader>gg", ":LazyGit<CR>", { desc = "Open lazy git ui" })
map("n", "<leader>w", "<cmd>w<CR>", { desc = "write to file" })

-- quick fix list
map("n", "<A-j>", "<cmd>cnext<CR>zz", { desc = "next quickfix" })
map("n", "<A-k>", "<cmd>cprev<CR>zz", { desc = "prev quickfix" })
map("n", "<leader>qo", "<cmd>copen<CR>", { desc = "open quickfix" })
map("n", "<leader>qc", "<cmd>cclose<CR>", { desc = "open quickfix" })

-- replace
map(
  "n",
  "<leader>s",
  ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
  { desc = "replace word under cursor in current file" }
)
-- code action
map(
  "n",
  "<leader>ca",
  "<cmd>lua vim.lsp.buf.code_action()<CR>",
  { desc = "code action", noremap = true, silent = true }
)
-- map("n", "<leader>p", '"+p', { desc = "Paste from system clipboard" })
map("n", "<leader>co", ":%bd|e#<CR>", { desc = "close other buffers" })
-- map("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", { desc = "window left" })
-- map("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", { desc = "window right" })
-- map("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", { desc = "window down" })
-- map("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", { desc = "window up" })
map("n", "<C-d>", "<C-d>zz", { desc = "Jump hanlf page down with cursor in th middle" })
map("n", "<C-u>", "<C-u>zz", { desc = "Jump hanlf page down with cursor in th middle" })
map("n", "J", "mzJ`z", { desc = "dont move cursor on j press" })
map("n", "<leader>u", ":UndotreeToggle<CR>", { desc = "Undo tree toggle" })
-- map("n", "<leader>gs", "<cmd>Git<cr>", { desc = "Git commit status" })
map("n", "<A-t>", ":lua require('nvterm.terminal').toggle 'horizontal'<CR>", { desc = "Terminal toggle horizontal" })

-- Harpoon keymaps
map(
  "n",
  "<leader>ha",
  "<CMD> lua require('harpoon.mark').add_file()<CR>",
  { desc = "harpoon add a file", silent = true }
)
map(
  "n",
  "<leader>ho",
  "<CMD> lua require('harpoon.ui').toggle_quick_menu()<CR>",
  { desc = "harpoon open menu", silent = true }
)
map(
  "n",
  "<leader>1",
  "<CMD> lua require('harpoon.ui').nav_file(1)<CR>",
  { desc = "Navigate to file 1 in harpoon", silent = true }
)
map(
  "n",
  "<leader>2",
  "<CMD> lua require('harpoon.ui').nav_file(2)<CR>",
  { desc = "Navigate to file 2 in harpoon", silent = true }
)
map(
  "n",
  "<leader>3",
  "<CMD> lua require('harpoon.ui').nav_file(3)<CR>",
  { desc = "Navigate to file 3 in harpoon", silent = true }
)
map(
  "n",
  "<leader>4",
  "<CMD> lua require('harpoon.ui').nav_file(4)<CR>",
  { desc = "Navigate to file 4 in harpoon", silent = true }
)
map("n", "<leader>hn", "<CMD> lua require('harpoon.ui').nav_next()<CR>", { desc = "Navigate to next mark in harpoon" })
map("n", "<leader>hp", "<CMD> lua require('harpoon.ui').nav_prev()<CR>", { desc = "Navigate to prev mark in harpoon" })

-- Visual mode keymaps
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })
-- map("v", "<leader>p", '"+p', { desc = "Paste from system clipboard" })
map("v", "<A-k>", "<cmd>VisualDuplicate -1<CR>", { desc = "Duplicate line down" })
map("v", "<A-j>", "<cmd>VisualDuplicate +1<CR>", { desc = "Duplicate line up" })
-- map("v", "<leader>rp", ":s/\\v(\\w+),/\\1={\\1}/g<CR>", { desc = "replace prop input into component props" })

-- Terminal mode keymaps
map("t", ";", ":", { desc = "enter command mode", nowait = true })
map(
  "t",
  "<A-t>",
  "<C-\\><C-n>:lua require('nvterm.terminal').toggle 'horizontal'<CR>",
  { desc = "Terminal toggle horizontal" }
)

vim.keymap.set("n", "n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]])
vim.keymap.set("n", "N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]])
vim.keymap.set("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.keymap.set("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.keymap.set("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.keymap.set("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
