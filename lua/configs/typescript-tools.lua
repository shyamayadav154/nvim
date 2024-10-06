local map = vim.keymap.set

map("n", "<leader>oi", "<cmd>TSToolsOrganizeImports<cr>", { desc = "Orgainse imports" })
map("n", "<leader>ai", "<cmd>TSToolsAddMissingImports<cr>", { desc = "Add missing imports" })

local api = require "typescript-tools.api"

require("typescript-tools").setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  handlers = {
    -- not used warning disable
    -- ["textDocument/publishDiagnostics"] = api.filter_diagnostics { 6133 },
  },
  settings = {
    -- spawn additional tsserver instance to calculate diagnostics on it
    separate_diagnostic_server = false,
    -- "change"|"insert_leave" determine when the client asks the server about diagnostic
    publish_diagnostic_on = "insert_leave",
    -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
    -- "remove_unused_imports"|"organize_imports") -- or string "all"
    -- to include all supported code actions
    -- specify commands exposed as code_actions
    expose_as_code_action = 'all',
    -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
    -- not exists then standard path resolution strategy is applied
    tsserver_path = nil,
    -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
    -- memory limit in megabytes or "auto"(basically no limit)
    tsserver_max_memory = "1536",
    -- described below
    complete_function_calls = false,
    include_completions_with_insert_text = false,
    -- CodeLens
    -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
    -- possible values: ("off"|"all"|"implementations_only"|"references_only")
    code_lens = "off",
    disable_member_code_lens = true,
    -- JSXCloseTag
    -- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-ts-autotag,
    -- that maybe have a conflict if enable this feature. )
    jsx_close_tag = {
      enable = false,
      filetypes = { "javascriptreact", "typescriptreact" },
    },
    -- importModuleSpecifierPreference = "non-relative",
    -- code_lens = "all",
    tsserver_file_preferences = {
      includeInlayParameterNameHints = "all",
    },
    tsserver_format_options = {
      allowIncompleteCompletions = false,
      allowRenameOfImportPath = false,
    },
    -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
    -- (see 💅 `styled-components` support section)
    tsserver_plugins = {
      -- for TypeScript v4.9+
      "@styled/typescript-styled-plugin",
      -- or for older TypeScript versions
      -- "typescript-styled-plugin",
    },
  },
}
