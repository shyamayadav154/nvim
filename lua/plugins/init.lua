return {
  "NvChad/nvcommunity",
  { import = "nvcommunity.tools.telescope-fzf-native" },
  { import = "nvcommunity.git.lazygit" },
  { import = "nvcommunity.motion.harpoon" },
  { import = "nvcommunity.editor.treesittercontext" },
  {
    "pittcat/claude-fzf-history.nvim",
    dependencies = { "ibhagwan/fzf-lua" },
    config = function()
      require("claude-fzf-history").setup()
    end,
    cmd = { "ClaudeHistory", "ClaudeHistoryDebug" },
    keys = {
      { "<leader>ch", "<cmd>ClaudeHistory<cr>", desc = "Claude History" },
    },
  },
  {
    "davidmh/mdx.nvim",
    event = "BufEnter *.mdx",
    config = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && npm install",
  },

  -- { import = "nvcommunity.motion.neoscroll" },
  -- {
  --   "karb94/neoscroll.nvim",
  --   keys = {
  --     -- Keys to be mapped to their corresponding default scrolling animation
  --     "<C-u>",
  --     "<C-d>",
  --     "<C-b>",
  --     "<C-f>",
  --     "<C-y>",
  --     "<C-e>",
  --     "zt",
  --     "zz",
  --     "zb",
  --   },
  --   opts = {
  --     enable = false, -- Enable scrolling animations
  --     mappings = { -- Keys to be mapped to their corresponding default scrolling animation
  --       "<C-u>",
  --       "<C-d>",
  --       "<C-b>",
  --       "<C-f>",
  --       "<C-y>",
  --       "<C-e>",
  --       "zt",
  --       "zz",
  --       "zb",
  --     },
  --     ignored_events = { -- Events ignored while scrolling
  --       "WinScrolled",
  --       "CursorMoved",
  --     },
  --   },
  -- },
  {
    event = "VeryLazy",
    "sphamba/smear-cursor.nvim",
    opts = {

      time_interval = 7, -- milliseconds
      enabled = false,
      stiffness = 0.8, -- 0.6      [0, 1]
      trailing_stiffness = 0.5, -- 0.4      [0, 1]
      stiffness_insert_mode = 0.7, -- 0.5      [0, 1]
      trailing_stiffness_insert_mode = 0.7, -- 0.5      [0, 1]
      damping = 0.8, -- 0.65     [0, 1]
      damping_insert_mode = 0.8, -- 0.7      [0, 1]
      distance_stop_animating = 0.5,
      -- Smear cursor when switching buffers or windows.
      smear_between_buffers = true,

      -- Smear cursor when moving within line or to neighbor lines.
      -- Use `min_horizontal_distance_smear` and `min_vertical_distance_smear` for finer control
      smear_between_neighbor_lines = true,

      -- Draw the smear in buffer space instead of screen space when scrolling
      scroll_buffer_space = true,

      -- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
      -- Smears will blend better on all backgrounds.
      legacy_computing_symbols_support = false,

      -- Smear cursor in insert mode.
      -- See also `vertical_bar_cursor_insert_mode` and `distance_stop_animating_vertical_bar`.
      smear_insert_mode = true,
    },
  },
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
      "mfussenegger/nvim-dap-python", --optional
      { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
    },
    lazy = false,
    branch = "regexp", -- This is the regexp branch, use this for the new version
    keys = {
      { ",v", "<cmd>VenvSelect<cr>" },
    },
    ---@type venv-selector.Config
    opts = {
      -- Your settings go here
    },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      ---@type table<string, snacks.win.Config>
      styles = {},
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      -- animate = { enabled = true },
      terminal = { enable = true },
      -- scope = { enabled = true },
      -- dim = { enabled = true },
      -- git = { enabled = true },
      -- dashboard = { enabled = true },
      -- explorer = { enabled = true },
      -- indent = { enabled = true },
      -- input = { enabled = true },
      -- picker = { enabled = true },
      -- notifier = { enabled = true },
      quickfile = { enabled = true },
      -- scope = { enabled = true },
      -- scroll = { enabled = true },
      -- statuscolumn = { enabled = true },
      -- words = { enabled = true },
      -- image
      image = {
        -- define these here, so that we don't need to load the image module
        formats = {
          "png",
          "jpg",
          "jpeg",
          "gif",
          "bmp",
          "webp",
          "tiff",
          "heic",
          "avif",
          "mp4",
          "mov",
          "avi",
          "mkv",
          "webm",
          "pdf",
        },
      },
    },
  },
  {
    "coder/claudecode.nvim",
    -- event = "BufReadPre",
    dependencies = {
      "folke/snacks.nvim", -- optional
    },
    config = true,
    lazy = false,
    opts = {
      -- Diff Integration
      diff_opts = {
        auto_close_on_accept = true, -- Close diff view after accepting changes
        show_diff_stats = true, -- Show diff statistics
        vertical_split = false, -- Use vertical split for diffs
        -- open_in_current_tab = true, -- Open diffs in current tab vs new tab
      },
      -- Terminal Configuration
      terminal = {
        split_side = "right", -- "left" or "right"
        split_width_percentage = 0.36, -- Width as percentage (0.0 to 1.0)
        provider = "snacks", -- "auto", "snacks", or "native"
        show_native_term_exit_tip = false, -- Show exit tip for native terminal
        auto_close = true, -- Auto-close terminal after command completion
      },
    },
    keys = {
      { ",t", "<cmd>ClaudeCode --continue <cr>", mode = { "n", "t" }, desc = "Toggle Claude" },
      { ",T", "<cmd>ClaudeCode --dangerously-skip-permissions<cr>", desc = "Continue Claude" },
      { ",f", "<cmd>ClaudeCodeFocus<cr>", mode = { "n", "t" }, desc = "Focus Claude" },
      -- { ",F", "<cmd>ClaudeCode --continue --dangerously-skip-permissions<cr>", desc = "Continue Claude" },
      { ",f", "<cmd>ClaudeCodeSend<cr>", mode = { "v" }, desc = "Send to Claude" },
      {
        -- "<leader>as",
        ",f",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil" },
      },

      -- Customize diff keymaps to avoid conflicts (e.g., with debugger)
      { "<leader>ya", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>yn", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
      -- Diff management
      -- { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      -- { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
  -- {
  --   "greggh/claude-code.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim", -- Required for git operations
  --   },
  --   event = "VeryLazy",
  --   -- cmd = {"ClaudeCode", "ClaudeCodeContinue", "ClaudeCodeResume", "ClaudeCodeVerbose"},
  --   opts = {},
  --   config = function()
  --     require "configs.claude-code"
  --   end,
  -- },
  -- {
  --   "rmagatti/auto-session",
  --   lazy = false,
  --
  --   ---enables autocomplete for opts
  --   ---@module "auto-session"
  --   ---@type AutoSession.Config
  --   opts = {
  --     suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
  --     -- log_level = 'debug',
  --   },
  -- },
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
    },
    -- comment the following line to ensure hub will be ready at the earliest
    cmd = "MCPHub", -- lazy load by default
    build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
    -- uncomment this if you don't want mcp-hub to be available globally or can't use -g
    -- build = "bundled_build.lua",  -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
    -- config = function()
    --   require("mcphub").setup()
    -- end,
    opts = {
      auto_approve = true, -- Auto approve mcp tool calls
      extensions = {
        avante = {
          make_slash_commands = true, -- make /slash commands from MCP server prompts
        },
      },
    },
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>dd",
        "<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR <cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>db",
        "<cmd>Trouble diagnostics toggle filter.buf=0 filter.severity=vim.diagnostic.severity.ERROR<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    "okuuva/auto-save.nvim",
    event = "VeryLazy",
    opts = {
      enabled = true, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
      trigger_events = { -- See :h events
        immediate_save = { "BufLeave", "FocusLost", "QuitPre", "VimSuspend" }, -- vim events that trigger an immediate save
        defer_save = { "InsertLeave", "TextChanged" }, -- vim events that trigger a deferred save (saves after `debounce_delay`)
        cancel_deferred_save = { "InsertEnter" }, -- vim events that cancel a pending deferred save
      },
      noautocmd = true, -- do not execute autocmds when saving
      condition = function()
        -- check if in nvim diff mode
        if vim.opt.diff:get() then
          return false
        end
        return true
      end,
      callbacks = {
        before_saving = function()
          -- save global autoformat status
          vim.g.OLD_AUTOFORMAT = vim.g.autoformat_enabled
          vim.g.autoformat_enabled = false
          vim.g.OLD_AUTOFORMAT_BUFFERS = {}
          -- disable all manually enabled buffers
          for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if vim.b[bufnr].autoformat_enabled then
              table.insert(vim.g.OLD_BUFFER_AUTOFORMATS, bufnr)
              vim.b[bufnr].autoformat_enabled = false
            end
          end
        end,
        after_saving = function()
          -- restore global autoformat status
          vim.g.autoformat_enabled = vim.g.OLD_AUTOFORMAT
          -- reenable all manually enabled buffers
          for _, bufnr in ipairs(vim.g.OLD_AUTOFORMAT_BUFFERS or {}) do
            vim.b[bufnr].autoformat_enabled = true
          end
        end,
      },
    },
  },
  {
    cmd = { "ContextEnable" },
    "wellle/context.vim",
  },
  -- {
  --   event = "VeryLazy",
  --   "karb94/neoscroll.nvim",
  --   opts = {
  --     mappings = {
  --       "<C-u>",
  --       "<C-d>",
  --       "<C-b>",
  --       "<C-f>",
  --       "<C-y>",
  --       "<C-e>",
  --       "zt",
  --       "zz",
  --       "zb",
  --     },
  --   },
  -- },
  {
    event = "VeryLazy",
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
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
    "Wansmer/treesj",
    keys = { "<leader>tt" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      vim.keymap.set("n", "<leader>tt", "<cmd>TSJToggle<cr>", { desc = "Toggle Treesitter Join" })
      require("treesj").setup {--[[ your config ]]
        max_join_length = 160,
        use_default_keymaps = false,
      }
    end,
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- set this if you want to always pull the latest change
    opts = {},
    config = function()
      require "configs.avante"
    end,
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
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
  -- {
  --   -- enabled = false,
  --   "supermaven-inc/supermaven-nvim",
  --   event = "InsertEnter",
  --   config = function()
  --     require("supermaven-nvim").setup {
  --       keymaps = {
  --         accept_suggestion = "<M-l>",
  --         clear_suggestion = "<C-]>",
  --         accept_word = "<M-j>",
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
      -- require("configs.dadbod").setup()
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
    event = "VeryLazy",
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
    -- lazy = false,
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    -- cmd = "DiffviewOpen",
    opts = {
      DiffviewOpen = { "--imply-local" },
      hooks = {
        diff_buf_win_enter = function(bufnr, winid, ctx)
          if ctx.layout_name:match "^diff2" then
            if ctx.symbol == "a" then
              vim.opt_local.winhl = table.concat({
                "DiffAdd:DiffviewDiffAddAsDelete",
                "DiffDelete:DiffviewDiffDelete",
              }, ",")
            elseif ctx.symbol == "b" then
              vim.opt_local.winhl = table.concat({
                "DiffDelete:DiffviewDiffDelete",
              }, ",")
            end
          end
        end,
      },
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
      telescope.load_extension "media_files"
      -- old files on cwd only

      conf.defaults.preview = {
        mime_hook = function(filepath, bufnr, opts)
          local is_image = function(filepath)
            local image_extensions = { "png", "jpg" } -- Supported image formats
            local split_path = vim.split(filepath:lower(), ".", { plain = true })
            local extension = split_path[#split_path]
            return vim.tbl_contains(image_extensions, extension)
          end
          if is_image(filepath) then
            local term = vim.api.nvim_open_term(bufnr, {})
            local function send_output(_, data, _)
              for _, d in ipairs(data) do
                vim.api.nvim_chan_send(term, d .. "\r\n")
              end
            end
            vim.fn.jobstart({
              "catimg",
              filepath, -- Terminal image viewer command
            }, { on_stdout = send_output, stdout_buffered = true, pty = true })
          else
            require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid, "Binary cannot be previewed")
          end
        end,
      }
      conf.defaults.mappings.n = {
        ["<C-r>"] = actions.to_fuzzy_refine,
        ["q"] = actions.close,
        ["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-s>"] = actions.cycle_previewers_next,
        ["<C-a>"] = actions.cycle_previewers_prev,
      }

      conf.defaults.mappings.i = {
        ["<C-r>"] = actions.to_fuzzy_refine,
        ["<C-j>"] = actions.cycle_history_next,
        ["<C-k>"] = actions.cycle_history_prev,
        ["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
        -- ["<C-u>"] = false,
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
  --   cmd = { "CopilotChatOpen" },
  --   dependencies = {
  --     { "zbirenbaum/copilot.lua" }, -- or zbirenbaum/copilot.lua
  --     { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
  --   },
  --   build = "make tiktoken", -- Only on MacOS or Linux
  --   opts = {
  --     -- See Configuration section for options
  --   },
  --   -- See Commands section for default commands if you want to lazy load on them
  -- },
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
        debounce = 100,
        hide_during_completion = true,
        keymap = {
          accept = "<M-l>",
          accept_word = "<M-j>",
          accept_line = "<M-k>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
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
    "nvim-treesitter/playground",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
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
            -- function argument swap
            ["<leader>na"] = "@parameter.inner",
            -- ["<leader>np"] = "@parameter.outer",
          },
          swap_previous = {
            -- ["<leader>na"] = "@parameter.inner",
            ["<leader>np"] = "@parameter.inner",
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
    },
  },
  {
    "nvim-telescope/telescope-media-files.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("telescope").load_extension "media_files"
    end,
  },
}
