-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

local stbufnr = function()
    return vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
end


local default_sep_icons = {
  default = { left = "", right = "" },
  round = { left = "", right = "" },
  block = { left = "█", right = "█" },
  arrow = { left = "", right = "" },
}

local separators = { left = "", right = "" }

local sep_l = separators["left"]
local sep_r = separators["right"]


local short_name = function()
    -- Get the current buffer's file path
    local full_path = vim.fn.expand('%:p')

    -- Split the path into components
    local components = {}
    for component in string.gmatch(full_path, '[^/]+') do
        table.insert(components, component)
    end

    -- Get the last 3 components (or fewer if there aren't 3)
    local last_3 = {}
    for i = math.max(1, #components - 2), #components do
        table.insert(last_3, components[i])
    end


    -- Add folder icon to last 2 components (if they exist)
    local folder_icon = " " -- You can change this to any icon you prefer
    if #last_3 >= 2 then
        last_3[#last_3 - 1] = folder_icon .. last_3[#last_3 - 1]
    end
    if #last_3 >= 3 then
        last_3[#last_3 - 2] = folder_icon .. last_3[#last_3 - 2]
    end

    -- Join the last 3 components
    local result = table.concat(last_3, ' > ')
    return result
end

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
            -- The default cursor module is override
            file = function()
                local icon = "󰈚"
                local path = vim.api.nvim_buf_get_name(stbufnr())
                local name = short_name()
                -- local name = (path == "" and "Empty ") or path:match "([^/\\]+)[/\\]*$"

                if name ~= "Empty " then
                    local devicons_present, devicons = pcall(require, "nvim-web-devicons")

                    if devicons_present then
                        local ft_icon = devicons.get_icon(name)
                        icon = (ft_icon ~= nil and ft_icon) or icon
                    end
                end

                local new_name = name:gsub("([^>]+)$", " "..icon .. "%1")
                local x = { icon, new_name}
                local final_name= " " .. x[2] .. " "
                return "%#St_file# " .. final_name.. "%#St_file_sep#" .. sep_r
            end,
            lsp_msg = function()
                require('lsp-status').status()
                -- Get the current buffer's file path
                -- local file_name = short_name()
                -- return file_name
            end,
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
