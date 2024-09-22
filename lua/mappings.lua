require "nvchad.mappings"

local map = vim.keymap.set
local nomap = vim.keymap.del

vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")

local builtin = require "telescope.builtin"
local actions = require "telescope.actions"

-- Custom function to grep through git status files
function LiveGrepGitStatus()
  local git_files = vim.fn.systemlist "git status --porcelain | awk '{print $2}'"
  -- print
  print(git_files)
  builtin.live_grep {
    search_dirs = git_files,
    prompt_title = "Live Grep on Git Status",
  }
end

map("n", "<leader>gw", LiveGrepGitStatus, { desc = "Live Grep on Git Status" })

require("hlslens").setup()

local kopts = { noremap = true, silent = true }

vim.keymap.set("n", "<Leader>l", "<Cmd>noh<CR>", kopts)

nomap("n", "<leader>n") -- relative line number toggle disabled
nomap("n", "<leader>b") -- git sign blame disabled
-- if has keymap at leader gb then remap

-- terminal keymaps remove
nomap("n", "<leader>h")
nomap("n", "<M-i>")

-- delete console from current page
map("n", "<leader>cd", "<cmd>g/console/norm dd<CR>", { desc = "Delete console from current file/buffer" })
-- floating window diagnostics
map("n", "<leader>lf", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "Delete console from current file/buffer" })

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

map("n", "<leader>cco", function()
  local input = vim.fn.input "Quick Chat: "
  if input ~= "" then
    require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
  end
end, { desc = "Quick Chat" })

map("n", "<leader>tch", function()
  local actions = require "CopilotChat.actions"
  require("CopilotChat.integrations.telescope").pick(actions.help_actions())
end, { desc = "Copilot help action" })

map("n", "<leader>tcp", function()
  local actions = require "CopilotChat.actions"
  require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
end, { desc = "Copilot prompt action" })

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
map("n", "<leader>gh", "<CMD>Gitsigns preview_hunk<CR>", { desc = "Preview Hunk" })
map("n", "<leader>rh", "<CMD>Gitsigns reset_hunk<CR>", { desc = "Reset Hunk" })
map("n", "<leader>dl", "<CMD>diffget //2<CR>", { desc = "Diff get right" })
map("n", "<leader>dh", "<CMD>diffget //3<CR>", { desc = "Diff get left" })

map("n", "n", "nzzzv", { desc = "Cursor center search" })
map("n", "N", "Nzzzv", { desc = "Cursor center search" })

map("n", "gj", "<C-w>j", { desc = "Go to window below" })
map("n", "gk", "<C-w>k", { desc = "Go to window above" })
map("n", "gH", "<C-w>h", { desc = "Go to window left" })
map("n", "gL", "<C-w>l", { desc = "Go to window right" })

map("n", "<C-f>", ":silent !tmux neww ts<CR>", { desc = "Open new tmux window" })
map("n", "<leader>gr", "<CMD>Gitsigns reset_buffer<CR>", { desc = "Git reset current file" })
map("n", "<leader>gs", "<CMD>Gitsigns stage_hunk<CR>", { desc = "Git reset current file" })

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
map("n", "<leader>gf", "<CMD>Telescop git_status<CR>", { desc = "git status" })
map("n", "<leader>fr", "<CMD>Telescope lsp_references<CR>", { desc = "lsp references" })
map("n", "<leader>fs", "<CMD>Telescope grep_string<CR>", { desc = "findt string under cursor" })
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
map("n", "<leader>o", "<CMD>OrganizeImports<CR>", { desc = "Organize imports tss lsp" })
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
  "<leader>a",
  "<CMD> lua require('harpoon.mark').add_file()<CR>",
  { desc = "Add file to harpoon menu", silent = true }
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
