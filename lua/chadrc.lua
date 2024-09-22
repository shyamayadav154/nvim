-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

local stbufnr = function()
    return vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
end


local separators = { left = "", right = "" }

local function get_relative_path()
  local full_path = vim.fn.expand('%:p')
  local cwd = vim.fn.getcwd()
  return vim.fn.fnamemodify(full_path, ':.' .. cwd .. ':~:.')
end


local sep_r = separators["right"]

M.ui = {
    theme = "onedark",

    tabufline = {
        lazyload = true,
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
                local path= get_relative_path()
                local name = path

                -- local name = (path == "" and "Empty ") or path:match "([^/\\]+)[/\\]*$"

                if name ~= "Empty " then
                    local devicons_present, devicons = pcall(require, "nvim-web-devicons")

                    if devicons_present then
                        local ft_icon = devicons.get_icon(name)
                        icon = (ft_icon ~= nil and ft_icon) or icon
                    end
                end

                local new_name = name:gsub("([^/]+)$", " ".. icon .. " %1")
                local final_name= " " .. new_name .. " "
                return "%#St_file# " .. final_name.. "%#St_file_sep#" .. sep_r
            end,
            lsp_msg = function()
                -- to enable fidget to work
                require('lsp-status').status()
            end,
            -- The default cursor module is override
            cursor = function()
                local sep_l = ""
                local text = "%2l:%-2v %2L "
                return "%#St_pos_sep#" .. sep_l .. "%#St_pos_icon# %#St_pos_text# " .. text
            end,
        },
    },

    -- nvdash (dashboard)
    nvdash = {
        load_on_startup = true,
        header = {
            " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
            " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
            " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
            " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
            " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
            " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
        },
    },

    hl_override = {
        Comment = { italic = true },
        ["@comment"] = { italic = true },
    },

    lsp = { signature = true },
}

return M
