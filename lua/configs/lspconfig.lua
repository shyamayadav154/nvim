-- LSP Configuration using vim.lsp.config and vim.lsp.enable API
local configs = require "nvchad.configs.lspconfig"
local on_attach = configs.on_attach
local on_init = configs.on_init
local capabilities = configs.capabilities

-- TypeScript specific on_attach
local on_attach_tsserver = function(client, bufnr)
  if client.server_capabilities.codeLensProvider then
    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
      buffer = bufnr,
      callback = vim.lsp.codelens.refresh,
    })
  end
  -- TypeScript specific commands
  vim.keymap.set("n", "<space>oi", function()
    vim.lsp.buf.code_action {
      apply = true,
      context = {
        only = { "source.removeUnused.ts" },
        diagnostics = {},
      },
    }
  end, { buffer = bufnr, desc = "Organize Imports: remove unused imports" })

  -- Auto import word under cursor using nvim-cmp in normal mode
  vim.keymap.set("n", "<leader>ai", function()
    local word = vim.fn.expand "<cword>"
    if word == "" then
      vim.notify("No word under cursor", vim.log.levels.WARN)
      return
    end
    -- Move to end of word and enter insert mode
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("ea", true, false, true), "n", false)
    -- Use a timer to trigger completion after entering insert mode
    vim.defer_fn(function()
      local cmp = require "cmp"
      cmp.complete {
        config = {
          sources = {
            { name = "nvim_lsp" },
          },
        },
      }
      cmp.confirm { select = true, behavior = cmp.ConfirmBehavior.Replace }

      -- go to normal mode after completion
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
      vim.notify("Triggering completion for: " .. word, vim.log.levels.INFO)
    end, 10)
  end, { desc = "Auto import word under cursor using nvim-cmp and lsp" })

  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
  on_attach(client, bufnr)
end

-- Disable ruff hover in favor of Pyright
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end
    if client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = "LSP: Disable hover capability from Ruff",
})

-- Server configurations
local servers = {
  -- Simple servers with default config
  html = {},
  cssls = {},
  graphql = {},
  jsonls = {},
  eslint = {},
  prismals = {},
  bashls = {},
  clangd = {},
  dockerls = {},
  yamlls = {},
  docker_compose_language_service = {},
  gopls = {},
  marksman = {},
  svelte = {},
  ruff = {},

  -- Harper LS for spell checking
  -- harper_ls = {
  --   settings = {
  --     ["harper-ls"] = {
  --       userDictPath = "",
  --       fileDictPath = "",
  --       linters = {
  --         SpellCheck = true,
  --         SpelledNumbers = false,
  --         AnA = true,
  --         SentenceCapitalization = true,
  --         UnclosedQuotes = true,
  --         WrongQuotes = false,
  --         LongSentences = true,
  --         RepeatedWords = true,
  --         Spaces = true,
  --         Matcher = true,
  --         CorrectNumberSuffix = true,
  --       },
  --       codeActions = {
  --         ForceStable = false,
  --       },
  --       markdown = {
  --         IgnoreLinkTitle = false,
  --       },
  --       diagnosticSeverity = "hint",
  --       isolateEnglish = false,
  --       dialect = "American",
  --       maxFileLength = 120000,
  --     },
  --   },
  -- },

  -- Pyright with Ruff integration
  pyright = {
    settings = {
      pyright = {
        disableOrganizeImports = true,
      },
      python = {
        analysis = {
          ignore = { "*" },
          autoSearchPaths = true,
          typeCheckingMode = "basic",
        },
      },
    },
  },

  -- Rust Analyzer
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy",
        },
      },
    },
  },

  -- TypeScript/JavaScript
  ts_ls = {
    on_attach = on_attach_tsserver,
    init_options = {
      hostInfo = "neovim",
      preferences = {
        includeCompletionsForModuleExports = true,
        includeCompletionsForImportStatements = true,
        importModuleSpecifierPreference = "non-relative",
        includePackageJsonAutoImports = "on",
        disableSuggestions = false,
        codeLens = {
          references = true,
          implementations = true,
        },
      },
    },
    settings = {
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
        },
        referencesCodeLens = {
          enabled = false,
          showOnAllFunctions = true,
        },
        implementationsCodeLens = {
          enabled = false,
        },
      },
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
        },
        referencesCodeLens = {
          enabled = false,
          showOnAllFunctions = true,
        },
        implementationsCodeLens = {
          enabled = false,
        },
      },
    },
  },

  -- Lua LS
  lua_ls = {
    settings = {
      Lua = {
        hint = { enable = true },
        telemetry = { enable = false },
      },
    },
  },

  -- Emmet LS
  emmet_ls = {
    filetypes = {
      "html",
      "css",
      "scss",
      "vue",
      "svelte",
      "markdown",
      "pug",
      "haml",
      "xml",
    },
  },
}

-- Configure and enable all servers
for name, opts in pairs(servers) do
  -- Merge with default NvChad config
  opts.on_attach = opts.on_attach or on_attach
  opts.on_init = opts.on_init or on_init
  opts.capabilities = opts.capabilities or capabilities

  vim.lsp.config(name, opts)
end

-- Enable all configured servers
vim.lsp.enable(vim.tbl_keys(servers))
