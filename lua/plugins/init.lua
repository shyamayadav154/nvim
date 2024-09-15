return {
  "NvChad/nvcommunity",
  { import = "nvcommunity.tools.telescope-fzf-native" },
  { import = "nvcommunity.git.neogit" },
  { import = "nvcommunity.git.lazygit" },
  { import = "nvcommunity.motion.harpoon" },
  { import = "nvcommunity.editor.treesj" },
  { import = "nvcommunity.motion.harpoon" },
  { import = "nvcommunity.editor.autosave" },
  { import = "nvcommunity.editor.treesittercontext" },
  {
    import = "nvcommunity.editor.treesj",
    opts = { max_join_length = 160 },
  },
  {
    "nvim-lua/lsp-status.nvim",
  },
  -- {
  --   'Bekaboo/dropbar.nvim',
  --   event = 'VeryLazy',
  --   -- optional, but required for fuzzy finder support
  --   dependencies = {
  --     'nvim-telescope/telescope-fzf-native.nvim'
  --   }
  -- },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {},
  },
  -- {
  --   "supermaven-inc/supermaven-nvim",
  --   event = "InsertEnter",
  --   config = function()
  --     require("supermaven-nvim").setup {
  --       keymaps = {
  --         accept_suggestion = "<M-l>",
  --         clear_suggestion = "<C-]>",
  --         accept_word = "<C-j>",
  --       },
  --       ignore_filetypes = { cpp = true },
  --       color = {
  --         suggestion_color = "#ffffff",
  --         cterm = 244,
  --       },
  --       disable_inline_completion = false, -- disables inline completion for use with cmp
  --       disable_keymaps = false, -- disables built in keymaps for more manual control
  --     }
  --   end,
  -- },
  {
    "kevinhwang91/nvim-hlslens",
    event = "VeryLazy",
    opts = {},
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji", "hrsh7th/cmp-cmdline" },
    --@param opts cmp.ConfigSchema
    opts = function(_, opts)
      -- local cmp = require "cmp"

      -- cmp.setup.cmdline("/", {
      --     mapping = cmp.mapping.preset.cmdline(),
      --     sources = {
      --         { name = "buffer" },
      --     },
      -- })

      -- cmp.setup.cmdline(":", {
      --     mapping = cmp.mapping.preset.cmdline(),
      --     sources = {
      --         { name = "path" },
      --         {
      --             name = "cmdline",
      --             option = {
      --                 ignore = { "Manh", "!" },
      --             },
      --         },
      --     },
      -- })

      -- deprioriize lsp Text completion
      local function deprio(kind)
        return function(e1, e2)
          if e1:get_kind() == kind then
            return false
          end
          if e2:get_kind() == kind then
            return true
          end
        end
      end
      local types = require "cmp.types"
      local compare = require "cmp.config.compare"
      -- better lsp completion suggestion
      opts.sorting = {
        priority_weight = 1,
        comparators = {
          -- deprio(types.lsp.CompletionItemKind.Snippet),
          deprio(types.lsp.CompletionItemKind.Text),
          -- deprio(types.lsp.CompletionItemKind.Keyword),
          compare.offset,
          compare.exact,
          -- compare.scopes,
          compare.score,
          compare.recently_used,
          compare.locality,
          compare.sort_text,
          compare.length,
          compare.order,
        },
      }
    end,
  },
  {
    -- vim dadbod
    "tpope/vim-dadbod",
    dependencies = {
      "kristijanhusak/vim-dadbod-ui",
      "kristijanhusak/vim-dadbod-completion",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("configs.dadbod").setup()
    end,
    cmd = {
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUI",
    },
  },
  {
    "axieax/urlview.nvim",
    event = "BufRead",
    opts = {},
  },
  {
    -- leap nvim
    "ggandor/leap.nvim",
    dependencies = "tpope/vim-repeat",
    opts = {},
    event = "VeryLazy",
  },
  {
    -- vim signature
    "kshenoy/vim-signature",
    event = "VeryLazy",
  },
  {
    -- vim visual multi
    "mg979/vim-visual-multi",
    event = "VeryLazy",
  },
  -- {
  --     "barrett-ruth/import-cost.nvim",
  --     event = "BufRead",
  --     build = "sh install.sh yarn",
  --     config = true,
  -- },
  {
    "tpope/vim-fugitive",
    cmd = {
      "Git",
      "Gdiffsplit",
      "Gvdiffsplit",
      "Gsplit",
      "Gvsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "GRemove",
      "GRename",
      "Glgrep",
      "Gedit",
    },
    opt = {},
  },
  {
    "sindrets/diffview.nvim",
    event = "BufRead",
    cmd = "DiffviewOpen",
    opts = {
      view = {
        -- For more info, see ':h diffview-config-view.x.layout'.
        default = {
          -- Config for changed files, and staged files in diff views.
          layout = "diff2_horizontal",
          winbar_info = false, -- See ':h diffview-config-view.x.winbar_info'
        },
        merge_tool = {
          -- Config for conflicted files in diff views during a merge or rebase.
          layout = "diff3_mixed",
          disable_diagnostics = false, -- Temporarily disable diagnostics for conflict buffers while in the view.
          winbar_info = true, -- See ':h diffview-config-view.x.winbar_info'
        },
        file_history = {
          -- Config for changed files in file history views.
          layout = "diff2_horizontal",
          winbar_info = false, -- See ':h diffview-config-view.x.winbar_info'
        },
      },
    },
  },
  {
    "nvim-pack/nvim-spectre",
    opts = {},
  },
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
  -- {
  --   "pmizio/typescript-tools.nvim",
  --   event = "BufReadPre",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "neovim/nvim-lspconfig",
  --   },
  --   opts = {},
  --   config = function()
  --     require "configs.typescript-tools"
  --   end,
  -- },
  {
    "axelvc/template-string.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "ThePrimeagen/refactoring.nvim",
    cmd = "Refactor",
    opts = {},
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "mattn/emmet-vim",
    cmd = { "Emmet", "EmmetInstall" },
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    event = "BufReadPre",
    config = function()
      require "configs.null-ls"
    end,
  },
  -- {
  --   "mfussenegger/nvim-lint",
  --   event = { "BufReadPre", "BufNewFile" },
  --   config = function()
  --     local lint = require "lint"
  --     lint.linters_by_ft = {
  --       javascript = { "cspell", "codespell" },
  --     }
  --     -- Create autocommand which carries out the actual linting
  --     -- on the specified events.
  --     local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
  --     vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  --       group = lint_augroup,
  --       callback = function()
  --         require("lint").try_lint()
  --       end,
  --     })
  --     vim.keymap.set("n", "<leader>lt", function()
  --       lint.try_lint()
  --     end, { desc = "Trigger linting for current file" })
  --   end,
  -- },
  -- {
  --     "tpope/vim-fugitive",
  --     cmd = {
  --         "Git",
  --         "Gdiffsplit",
  --         "Gvdiffsplit",
  --         "Gsplit",
  --         "Gvsplit",
  --         "Gread",
  --         "Gwrite",
  --         "Ggrep",
  --         "GMove",
  --         "GDelete",
  --         "GBrowse",
  --         "GRemove",
  --         "GRename",
  --         "Glgrep",
  --         "Gedit",
  --     },
  --     ft = { "fugitive" },
  -- },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        mappings = {
          i = { ["<c-enter>"] = "to_fuzzy_refine" },
        },
      },
    },
  },
  -- { import = "nvcommunity.motion.neoscroll" },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    "f-person/git-blame.nvim",
    cmd = {
      "GitBlameToggle",
      "GitBlameEnable",
      "GitBlameOpenCommitURL",
      "GitBlameCopySHA",
      "GitBlameCopyCommitURL",
    },
  },
  {
    -- jsx/tsx comment
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = "BufRead",
    dependencies = "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
  },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    opts = {},
  },
  {
    -- autotag rename
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    config = function()
      require("nvim-ts-autotag").setup {
        opts = {
          -- Defaults
          enable_close = true, -- Auto close tags
          enable_rename = true, -- Auto rename pairs of tags
          enable_close_on_slash = false, -- Auto close on trailing </
        },
        -- Also override individual filetype configs, these take priority.
        -- Empty by default, useful if one of the "opts" global settings
        -- doesn't work well in a specific filetype
        per_filetype = {
          ["html"] = {
            enable_close = true,
          },
        },
      }
    end,
  },
  -- {
  --     "David-Kunz/gen.nvim",
  --     cmd = { "Gen", "GenOnly" },
  -- },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "rrethy/vim-illuminate",
    event = { "CursorHold", "CursorHoldI" },
    dependencies = "nvim-treesitter",
    opts = {
      -- dont show under line
      under_cursor = false,
      filetypes_denylist = {
        "NvimTree",
        "Trouble",
        "Outline",
        "TelescopePrompt",
        "Empty",
        "dirvish",
        "fugitive",
        "alpha",
        "packer",
        "neogitstatus",
        "spectre_panel",
        "toggleterm",
        "DressingSelect",
        "aerial",
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](false)
          -- in middle scree
          vim.cmd "normal! zz"
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
      end

      map("]]", "next")
      map("[[", "prev")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
    keys = {
      { "]]", desc = "Next Reference" },
      { "[[", desc = "Prev Reference" },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    event = "BufRead",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {
      debug = false, -- Enable debugging
      -- See Configuration section for rest
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      filetypes = {
        yaml = true,
        markdown = true,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
      suggestion = {
        auto_trigger = true,
        debounce = 0,
      },
    },
  },
  {
    -- indent guess prisma mainly
    "NMAC427/guess-indent.nvim",
    event = "BufReadPre",
    opts = {},
  },
  -- {
  -- -- doesn't work well shows's more indent spaces sometimes
  --     "tpope/vim-sleuth",
  --     event = "BufRead",
  -- },
  -- {
  --   "stevearc/conform.nvim",
  --   -- event = 'BufWritePre', -- uncomment for format on save
  --   config = function()
  --     require "configs.conform"
  --   end,
  -- },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      -- { "j-hui/fidget.nvim", opts = {} },
      { "folke/neodev.nvim", opts = {} },
    },
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  {
    "williamboman/mason.nvim",
    -- deprecated
    -- opts = {
    --   ensure_installed = {
    --     "lua-language-server",
    --     "stylua",
    --     "html-lsp",
    --     "css-lsp",
    --     "prettier",
    --     "typescript-language-server",
    --     "graphql",
    --   },
    -- },
  },
  {
    "nvim-treesitter/playground",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
    opts = {
      auto_install = true,
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "graphql",
        "json",
      },
      textobjects = {
        select = {
          enable = true,
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["am"] = "@function.outer",
            ["im"] = "@function.inner",

            ["ac"] = "@call.outer",
            ["ic"] = "@call.inner",
            ["ai"] = "@conditional.outer",
            ["ii"] = "@conditional.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["ar"] = "@return.outer",
            ["ir"] = "@return.inner",

            -- ["ac"] = "@class.outer",
            -- ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
          },
          selection_modes = {
            ["@parameter.outer"] = "v", -- charwise
            ["@function.outer"] = "V", -- linewise
            ["@class.outer"] = "<c-v>", -- blockwise
          },

          include_surrounding_whitespace = false,
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>nf"] = "@function.outer",
            ["<leader>nm"] = "@function.outer",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]m"] = "@function.outer",
            -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
            ["]l"] = "@loop.inner",
            -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
            --
            -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
            -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
            -- ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
            ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
          },
          -- goto_next_end = {
          --   ["]M"] = "@function.outer",
          --   ["]["] = "@class.outer",
          -- },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[m"] = "@function.outer",
            ["[l"] = "@loop.inner",
          },
          -- goto_previous_end = {
          --   ["[M"] = "@function.outer",
          --   ["[]"] = "@class.outer",
          -- },
          -- Below will go to either the start or the end, whichever is closer.
          -- Use if you want more granular movements
          -- Make it even more gradual by adding multiple queries and regex.
          goto_next = {
            ["]i"] = "@conditional.outer",
          },
          goto_previous = {
            ["[i"] = "@conditional.outer",
          },
        },
      },
      highlights = {
        enable = true,
      },
      indent = {
        enable = true,
        -- disable = {
        --   "ruby"
        -- },
      },
    },
  },
}
