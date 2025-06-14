# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a Neovim configuration built on **NvChad v2.5** framework. The configuration follows a modular structure with:

- **Base Framework**: NvChad v2.5 provides the foundation with lazy loading via lazy.nvim
- **Plugin Management**: Uses lazy.nvim with performance optimizations
- **LSP Setup**: Comprehensive LSP configuration for web development, Rust, Python, Go, and more
- **Theme**: Uses "onedark" theme with custom statusline modifications
- **AI Integration**: Includes Avante, Copilot, CopilotChat, and Claude Code plugins

## Key Configuration Files

- `init.lua` - Entry point that bootstraps lazy.nvim and loads core configs
- `lua/chadrc.lua` - NvChad configuration overrides, statusline customization
- `lua/plugins/init.lua` - Main plugin specifications and configurations  
- `lua/mappings.lua` - Custom keybindings and mappings
- `lua/options.lua` - Neovim options and autocommands
- `lua/configs/` - Individual plugin configurations

## Development Tools & Languages Supported

**LSP Servers**: html, cssls, graphql, quick_lint_js, jsonls, eslint, prismals, bashls, clangd, dockerls, yamlls, docker_compose_language_service, gopls, mdx_analyzer, marksman, svelte, pyright, rust_analyzer, lua_ls, emmet_ls

**Formatters**: prettier, stylua, black, shfmt (via null-ls)
**Linters**: zsh, codespell (via null-ls)

## Key Features & Plugins

- **Git Integration**: LazyGit, vim-fugitive, gitsigns, diffview, neogit
- **AI Assistants**: Avante (main AI chat), Copilot (code completion), CopilotChat, MCPHub
- **Navigation**: Harpoon, telescope, leap.nvim, nvim-tree
- **Code Enhancement**: treesitter, nvim-ufo (folding), trouble.nvim, refactoring.nvim
- **Database**: vim-dadbod-ui for database operations
- **Testing**: None configured (check project for specific test runners)

## Important Custom Keybindings

- `<space>` - Leader key
- `<leader>gg` - LazyGit
- `<leader>an` - Avante Chat (main AI assistant)
- `<leader>ff` - Find files (including hidden)  
- `<leader>fw` - Live grep with args
- `<leader>a` - Add file to Harpoon
- `<leader>ho` - Harpoon menu
- `<leader>1-4` - Navigate to Harpoon files 1-4
- `;` - Enter command mode (remapped from `:`)
- `jk` - Exit insert mode
- `s`/`S` - Leap forward/backward motion

## Performance Optimizations

- Lazy loading enabled by default for all plugins
- Disabled builtin plugins: netrw, gzip, tar, zip, tutor, etc.
- Uses `lazy = false` only for essential plugins like NvChad core

## Spell Checking & Snippets

- Spell checking enabled for all files
- Custom spell dictionary at `spell/en.utf-8.add`
- Multiple snippet formats supported: VSCode, LuaSnip, Snipmate
- Snippet directories: `lua/configs/vs_snippets/`, `lua/configs/snippets/`, `lua/configs/lua_snippets/`

## TypeScript/JavaScript Specific

- Uses typescript-tools.nvim instead of tsserver
- Prettier formatting via null-ls
- ESLint integration
- Template string auto-conversion with template-string.nvim
- Emmet support for HTML-like files

## Notes for Development

- Configuration uses 4-space indentation
- Folding configured with nvim-ufo (high fold levels)
- Auto-save plugin configured but disabled by default
- Custom statusline shows relative file paths
- Supports both terminal and GUI (Neovide) usage