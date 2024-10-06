return {
  "NvChad/nvcommunity",
  { import = "nvcommunity.tools.telescope-fzf-native" },
  { import = "nvcommunity.git.lazygit" },
  { import = "nvcommunity.editor.treesj" },
  { import = "nvcommunity.motion.harpoon" },
  { import = "nvcommunity.editor.autosave" },
  -- { import = "nvcommunity.editor.treesittercontext" },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    config = function()
      require("treesitter-context").setup {
        throttle = true,
        max_lines = 5,
        patterns = {
          default = {
            "class",
            "function",
            "method",
          },
          prisma = {
            "type",
            "identifier",
            "model_declaration",
          },
        },
      }
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    event = "BufRead",
    dependencies = "kevinhwang91/promise-async",
    opts = {
      provider = { "lsp", "indent" },
    },
  },
  {
    import = "nvcommunity.editor.treesj",
    opts = { max_join_length = 160 },
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
      provider = "gemini", -- Recommend using Claude
      auto_suggestions_provider = "copilot",
      gemini = {
        endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
        model = "gemini-1.5-flash-002",
        timeout = 30000, -- Timeout in milliseconds
        temperature = 0,
        max_tokens = 4096,
        ["local"] = false,
      },
      -- copilot = {
      --   endpoint = "https://api.githubcopilot.com",
      --   model = "gpt-4o-2024-05-13",
      --   proxy = nil, -- [protocol://]host[:port] Use this proxy
      --   allow_insecure = false, -- Allow insecure server connections
      --   timeout = 30000, -- Timeout in milliseconds
      --   temperature = 0,
      --   max_tokens = 4096,
      -- },
      behaviour = {
        auto_suggestions = false, -- Experimental stage
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
      },
      mappings = {
        --- @class AvanteConflictMappings
        diff = {
          ours = "co",
          theirs = "ct",
          all_theirs = "ca",
          both = "cb",
          cursor = "cc",
          next = "]x",
          prev = "[x",
        },
        suggestion = {
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
        jump = {
          next = "]]",
          prev = "[[",
        },
        submit = {
          normal = "<CR>",
          insert = "<C-s>",
        },
        sidebar = {
          switch_windows = "<Tab>",
          reverse_switch_windows = "<S-Tab>",
        },
      },
      hints = { enabled = true },
      windows = {
        ---@type "right" | "left" | "top" | "bottom"
        position = "right", -- the position of the sidebar
        wrap = true, -- similar to vim.o.wrap
        width = 35, -- default % based on available width
        sidebar_header = {
          align = "center", -- left, center, right for title
          rounded = true,
        },
      },
      highlights = {
        ---@type AvanteConflictHighlights
        diff = {
          current = "DiffText",
          incoming = "DiffAdd",
        },
      },
      --- @class AvanteConflictUserConfig
      diff = {
        autojump = true,
        ---@type string | fun(): any
        list_opener = "copen",
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "aaronhallaert/advanced-git-search.nvim",
    cmd = { "AdvancedGitSearch" },
    config = function()
      -- optional: setup telescope before loading the extension
      require("telescope").setup {
        -- move this to the place where you call the telescope setup function
        extensions = {
          advanced_git_search = {
            -- See Config
          },
        },
      }

      require("telescope").load_extension "advanced_git_search"
    end,
    dependencies = {
      --- See dependencies
    },
  },
  {
    "debugloop/telescope-undo.nvim",
    dependencies = { -- note how they're inverted to above example
      {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
    },
    keys = {
      { -- lazy style key map
        "<leader>tu",
        "<cmd>Telescope undo<cr>",
        desc = "undo history",
      },
    },
    opts = {
      -- don't use `defaults = { }` here, do this in the main telescope spec
      extensions = {
        use_delta = true,
        use_custom_command = nil, -- setting this implies `use_delta = false`. Accepted format is: { "bash", "-c", "echo '$DIFF' | delta" }
        side_by_side = false,
        vim_diff_opts = { ctxlen = vim.o.scrolloff },
        entry_format = "state #$ID, $STAT, $TIME",
        undo = {
          --
        },
      },
      config = function(_, opts)
        -- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
        -- configs for us. We won't use data, as everything is in it's own namespace (telescope
        -- defaults, as well as each extension).
        require("telescope").setup(opts)
        require("telescope").load_extension "undo"
      end,
    },
  },
  -- {
  --   "nvim-lua/lsp-status.nvim",
  -- },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-lua/lsp-status.nvim",
    },
    opts = {},
  },
  -- {
  --   "typed-rocks/ts-worksheet-neovim",
  --   cmd = "Tsw",
  --   opts = {
  --     severity = vim.diagnostic.severity.WARN,
  --   },
  --   config = function(_, opts)
  --     require("tsw").setup(opts)
  --   end,
  -- },
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    config = function()
      require("supermaven-nvim").setup {
        keymaps = {
          accept_suggestion = "<M-l>",
          clear_suggestion = "<C-]>",
          accept_word = "<M-j>",
        },
        ignore_filetypes = { cpp = true },
        color = {
          suggestion_color = "#ffffff",
          cterm = 244,
        },
        disable_inline_completion = false, -- disables inline completion for use with cmp
        disable_keymaps = false, -- disables built in keymaps for more manual control
      }
    end,
  },
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
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true }, -- Optional
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
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
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed.
      "nvim-telescope/telescope.nvim", -- optional
    },
    config = true,
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
  {
    "pmizio/typescript-tools.nvim",
    event = "BufReadPre",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {},
    config = function()
      require "configs.typescript-tools"
    end,
  },
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
    dependencies = {
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = "^1.0.0",
      },
    },
    opts = function()
      local conf = require "nvchad.configs.telescope"
      local actions = require "telescope.actions"
      local telescope = require "telescope" -- no need

      telescope.load_extension "live_grep_args"

      conf.defaults.mappings.n = {
        ["<C-Enter"] = actions.to_fuzzy_refine,
        ["q"] = actions.close,
        ["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
      }

      conf.defaults.mappings.i = {
        ["<c-enter"] = actions.to_fuzzy_refine,
        ["<C-j>"] = actions.cycle_history_next,
        ["<C-k>"] = actions.cycle_history_prev,
        ["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
      }
      return conf
    end,
    -- opts = {
    --   defaults = {
    --     mappings = {
    --       i = {
    --         ["<c-enter>"] = "to_fuzzy_refine",
    --         ["<c-j>"] = "cycle_history_next",
    --         ["<c-k>"] = "cycle_history_prev",
    --         ["<c-w>"] = { "send_selected_to_qflist", "open_qflist" },
    --       },
    --     },
    --   },
    -- },
  },
  -- { import = "nvcommunity.motion.neoscroll" },
  -- {
  --   "christoomey/vim-tmux-navigator",
  --   lazy = false,
  -- },
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
  -- {
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   branch = "canary",
  --   event = "BufRead",
  --   dependencies = {
  --     { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
  --     { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
  --   },
  --   opts = {
  --     debug = false, -- Enable debugging
  --     -- See Configuration section for rest
  --   },
  --   -- See Commands section for default commands if you want to lazy load on them
  -- },
  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   event = "InsertEnter",
  --   opts = {
  --     filetypes = {
  --       yaml = true,
  --       markdown = true,
  --       help = false,
  --       gitcommit = false,
  --       gitrebase = false,
  --       hgcommit = false,
  --       svn = false,
  --       cvs = false,
  --       ["."] = false,
  --     },
  --     suggestion = {
  --       auto_trigger = true,
  --       debounce = 0,
  --     },
  --   },
  -- },
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
    opts = function(_,conf)

      local l = {
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
      }
      table.insert(conf,l)
      return conf
    end,
  },
}
