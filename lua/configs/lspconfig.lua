-- EXAMPLE
local configs = require "nvchad.configs.lspconfig"
local on_attach = configs.on_attach
local on_init = configs.on_init
local capabilities = configs.capabilities

local lspconfig = require "lspconfig"

local function organise_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = "",
  }
  vim.lsp.buf.execute_command(params)
end

local function add_missing_import()
  local params = {
    command = "_typescript.addMissingImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = "",
  }
  vim.lsp.buf.execute_command(params)
end

local servers = {
  "html",
  -- "tsserver",
  "cssls",
  "graphql",
  "quick_lint_js",
  "jsonls",
  "eslint",
  "prismals",
  -- "grammarly",
  "bashls",
  "clangd",
  "dockerls",
  "yamlls",
  "docker_compose_language_service",
  "jsonls",
  "gopls",
  "mdx_analyzer",
  "marksman",
  "svelte",
  -- "pylsp"
  -- add python lsp
  "pyright",
  "ruff",
  -- "tailwindcss",
}

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

local util = require "lspconfig/util"

-- lspconfig.tailwindcss.setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
--   root_dir = util.root_pattern(
--     "tailwind.config.js",
--     "tailwind.config.ts",
--     "tailwind.config.mjs",
--     "tailwind.config.cjs"
--   ),
-- }

lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    pyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        -- Ignore all files for analysis to exclusively use Ruff for linting
        ignore = { "*" },
      },
    },
  },
}

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end
    if client.name == "ruff" then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = "LSP: Disable hover capability from Ruff",
})

lspconfig.rust_analyzer.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy",
      },
    },
  },
}

-- typescript
--disable formatimg on attach for tsserver
local on_attach_tsserver = function(client, bufnr)
  if client.server_capabilities.codeLensProvider then
    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
      buffer = bufnr,
      callback = vim.lsp.codelens.refresh,
    })
  end
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
  on_attach(client, bufnr)
end

-- lspconfig.ts_ls.setup {
--   on_attach = on_attach_tsserver,
--   on_init = on_init,
--   capabilities = capabilities,
--   init_options = {
--     preferences = {
--       disableSuggestions = false,
--       codeLens = {
--         references = true,
--         implementations = true,
--       },
--     },
--   },
--   commands = {
--     OrganizeImports = {
--       organise_imports,
--       description = "Organize Imports",
--     },
--     AddMissingImports = {
--       add_missing_import,
--       description = "Add missing imports",
--     },
--   },
--   settings = {
--     importModuleSpecifierPreference = "non-relative",
--     -- enable code lens
--     javascript = {
--       codeLens = {
--         references = true,
--         implementations = true,
--       },
--       inlayHints = {
--         -- includeInlayEnumMemberValueHints = true,
--         -- includeInlayFunctionLikeReturnTypeHints = true,
--         -- includeInlayFunctionParameterTypeHints = true,
--         includeInlayParameterNameHints = "all",
--         -- includeInlayParameterNameHintsWhenArgumentMatchesName = true,
--         -- includeInlayPropertyDeclarationTypeHints = true,
--         -- includeInlayVariableTypeHints = true,
--       },
--     },
--     typescript = {
--       codeLens = {
--         references = true,
--         implementations = true,
--       },
--       inlayHints = {
--         -- includeInlayEnumMemberValueHints = true,
--         -- includeInlayFunctionLikeReturnTypeHints = true,
--         -- includeInlayFunctionParameterTypeHints = true,
--         includeInlayParameterNameHints = "all",
--         -- includeInlayParameterNameHintsWhenArgumentMatchesName = true,
--         -- includeInlayPropertyDeclarationTypeHints = true,
--         -- includeInlayVariableTypeHints = true,
--       },
--     },
--   },
-- }

lspconfig.lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  Lua = {
    hint = { enable = true },
    telemetry = { enable = false },
  },
}

lspconfig.emmet_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  jsx = { enabled = true },
  filetypes = {
    "html",
    "css",
    "scss",
    -- "javascriptreact",
    -- "typescriptreact",
    "vue",
    "svelte",
    "markdown",
    "pug",
    "haml",
    "xml",
  },
}
