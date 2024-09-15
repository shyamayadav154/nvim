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
    -- CodeLens
    -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
    -- possible values: ("off"|"all"|"implementations_only"|"references_only")
    code_lens = "off",
    complete_function_calls = false,
    include_completions_with_insert_text = false,
    -- takes to much ram if true
    separate_diagnostic_server = false,
    -- complete_function_calls = true,
    -- importModuleSpecifierPreference = "non-relative",
    -- code_lens = "all",
    tsserver_file_preferences = {
      includeInlayParameterNameHints = "all",
    },
    tsserver_format_options = {
      allowIncompleteCompletions = false,
      allowRenameOfImportPath = false,
    },
    tsserver_plugins = {
      -- for TypeScript v4.9+
      "@styled/typescript-styled-plugin",
      -- or for older TypeScript versions
      -- "typescript-styled-plugin",
    },
  },
}
