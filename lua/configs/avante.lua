require("avante").setup {

  -- disabled for mcp hub
  disabled_tools = {
    "list_files",
    "search_files",
    "read_file",
    "create_file",
    "rename_file",
    "delete_file",
    "create_dir",
    "rename_dir",
    "delete_dir",
    "bash",
  },
  -- system_prompt as function ensures LLM always has latest MCP server state
  -- This is evaluated for every message, even in existing chats
  system_prompt = function()
    local hub = require("mcphub").get_hub_instance()
    return hub and hub:get_active_servers_prompt() or ""
  end,
  -- Using function prevents requiring mcphub before it's loaded
  custom_tools = function()
    return {
      require("mcphub.extensions.avante").mcp_tool(),
    }
  end,
  ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
  provider = "copilot", -- Recommend using Claude
  mode = "agentic", -- The default mode for interaction. "agentic" uses tools to automatically generate code, "legacy" uses the old planning method to generate code.
  auto_suggestions_provider = "copilot_suggestions", -- The provider to use for auto-suggestions. This can be different from the main provider.
  ---To add support for custom provider, follow the format below
  ---See https://github.com/yetone/avante.nvim/wiki#custom-providers for more details
  ---@type {[string]: AvanteProvider}
  providers = {
    openrouter = {
      __inherited_from = "openai",
      endpoint = "https://openrouter.ai/api/v1",
      api_key_name = "OPENROUTER_API_KEY",
      model = "meta-llama/llama-3.3-8b-instruct:free",
    },
    gemini = {
      endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
      model = "gemini-2.0-flash",
      timeout = 30000, -- Timeout in milliseconds
      temperature = 0,
      max_tokens = 8192,
    },
    copilot = {
      endpoint = "https://api.githubcopilot.com",
      -- model = "gpt-4o-2024-05-13",
      model = "claude-sonnet-4", -- gpt-4o-2024-05-13 | claude-3.7-sonnet | claude-sonnet-4 | gpt-4.1 | gemini-2.5-pro
      proxy = nil, -- [protocol://]host[:port] Use this proxy
      allow_insecure = false, -- Allow insecure server connections
      timeout = 30000, -- Timeout in milliseconds
      extra_request_body = {
        temperature = 0,
        max_tokens = 4096,
      },
    },
    copilot_suggestions = {
      __inherited_from = "copilot",
      model = "gemini-2.0-flash-001", -- gpt-4o-2024-05-13 | claude-3.7-sonnet | claude-sonnet-4 | gpt-4.1 | gemini-2.5-pro
    },
    openai = {
      endpoint = "https://api.openai.com/v1",
      model = "gpt-4o",
      timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
      extra_request_body = {
        temperature = 0,
        max_completion_tokens = 16384, -- Increase this to include reasoning tokens (for reasoning models)
        reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
      },
    },
  },
  behaviour = {
    auto_suggestions = false, -- Experimental stage
    auto_set_highlight_group = true,
    auto_set_keymaps = true,
    auto_apply_diff_after_generation = false,
    support_paste_from_clipboard = false,
    minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
    enable_token_counting = true, -- Whether to enable token counting. Default to true.
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
      accept = "<M-k>",
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
      apply_all = "A",
      apply_cursor = "a",
      retry_user_request = "r",
      edit_user_request = "e",
      switch_windows = "<Tab>",
      reverse_switch_windows = "<S-Tab>",
      remove_file = "d",
      add_file = "@",
      close = { "<Esc>", "q" },
      close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }
    },
  },
  hints = { enabled = true },
  selector = {
    ---@alias avante.SelectorProvider "native" | "fzf_lua" | "mini_pick" | "snacks" | "telescope" | fun(selector: avante.ui.Selector): nil
    ---@type avante.SelectorProvider
    provider = "native",
    provider_opts = {},
    exclude_auto_select = {}, -- List of items to exclude from auto selection
  },
  suggestion = {
    debounce = 600,
    throttle = 600,
  },
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
}
