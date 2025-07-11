-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

local stbufnr = function()
  return vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
end

local separators = { left = "", right = "" }

local function get_relative_path()
  local full_path = vim.fn.expand "%:p"
  local cwd = vim.fn.getcwd()
  return vim.fn.fnamemodify(full_path, ":." .. cwd .. ":~:.")
end

local sep_r = separators["right"]

local function get_git_branch(max_length)
  local git_cmd = io.popen "git branch --show-current 2>/dev/null"
  if git_cmd then
    local branch = git_cmd:read "*l"
    git_cmd:close()
    if branch and branch ~= "" then
      if max_length and #branch > max_length then
        branch = branch:sub(1, max_length - 3) .. "..."
      end
      return branch
    end
  end
  return nil
end

M.ui = {
  theme = "onedark",

  tabufline = {
    lazyload = false,
    overriden_modules = nil,
  },

  cmp = {
    icons = true,
    lspkind_text = true,
    style = "default", -- default/flat_light/flat_dark/atom/atom_colored
  },

  statusline = {
    theme = "default",
    separator_style = "round",
    modules = {
      file = function()
        local icon = "󰈚"
        local path = get_relative_path()
        local name = path

        -- local name = (path == "" and "Empty ") or path:match "([^/\\]+)[/\\]*$"

        if name ~= "Empty " then
          local devicons_present, devicons = pcall(require, "nvim-web-devicons")

          if devicons_present then
            local ft_icon = devicons.get_icon(name)
            icon = (ft_icon ~= nil and ft_icon) or icon
          end
        end

        local new_name = name:gsub("([^/]+)$", " " .. icon .. " %1")
        local final_name = " " .. new_name .. " "
        return "%#St_file# " .. final_name .. "%#St_file_sep#" .. sep_r
      end,
      lsp_msg = function()
        -- to enable fidget to work
        -- require("lsp-status").status()
      end,
      -- The default cursor module is override
      cursor = function()
        local sep_l = ""
        local text = "%2l:%-2v %2L "
        return "%#St_pos_sep#" .. sep_l .. "%#St_pos_icon# %#St_pos_text# " .. text
      end,
      git = function()
        local branch = get_git_branch(50)
        if branch then
          return "%#St_gitIcons#  " .. branch .. " "
        end
        return ""
      end,
    },
  },

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },

  lsp = { signature = true },
}

M.nvdash = {
  load_on_startup = true,

  header = function()
    local cwd = vim.fn.getcwd()
    -- Get just the folder name
    local folder_name = vim.fn.fnamemodify(cwd, ":t")

    local branch = get_git_branch(50)
    local git_branch = branch and ("  " .. branch) or ""

    return {
      --  "     ▄▄         ▄ ▄▄▄▄▄▄▄   ",
      --  "   ▄▀███▄     ▄██ █████▀    ",
      --  "   ██▄▀███▄   ███           ",
      --  "   ███  ▀███▄ ███           ",
      --  "   ███    ▀██ ███           ",
      --  "   ███      ▀ ███           ",
      --  "   ▀██ █████▄▀█▀▄██████▄    ",
      --  "     ▀ ▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀   ",
      --  "                            ",
      --  "     Powered By  eovim    ",
      --  "                            ",
      -- "",
      "  " .. folder_name,
      git_branch,
      "",
      "",
      "",
    }
  end,
}

return M

-- " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
-- " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
-- " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
-- " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
-- " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
-- " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
