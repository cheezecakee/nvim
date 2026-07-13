# nvim config

A personal Neovim configuration built from scratch, moving away from a
previous [NvChad](https://github.com/NvChad/NvChad)-based setup. The goal is
minimal dependencies, single-purpose plugins, and a config that's fully
understandable line by line. No distro layer, no plugin manager framework
sitting between you and what's actually running.

This is my personal daily-driver config, dual-booted between **Windows**
and **NixOS**. It's genuinely barebones by design, so feel free to use it
as-is, fork it, or just pull pieces out of it as a reference/template —
there's nothing here that assumes you'll keep it exactly as written. Some
of the defaults (formatter/linter choices, keymaps, etc.) will keep
changing as I get more comfortable with the setup, so treat this as a
living config rather than a finished product.

## Requirements

- Neovim **0.12+** (uses `vim.pack` as the plugin manager — no external
  package manager plugin required)
- `git`
- [`ripgrep`](https://github.com/BurntSushi/ripgrep) (used by pickers/grep)
- On Windows: [PowerShell 7+ (`pwsh`)](https://github.com/PowerShell/PowerShell)
- On NixOS: bash available at `/run/current-system/sw/bin/bash` (default on any NixOS system)
- Language-specific toolchains (Go, Node, Python, etc.) only as needed —
  Mason installs LSP servers/linters/formatters on demand, nothing is
  installed automatically on startup

## Philosophy

- One tool per job - avoid running two plugins that solve the same problem
- Prefer built-in Neovim behavior over a plugin where one already exists
  (native comment toggling, native buffer/window mechanics, etc.)
- No automatic installs - Mason installs are explicit and manual
- Everything in this repo should be readable and traceable; nothing is
  configured "by inheriting from a base config"

## Structure

```bash
.
├── init.lua              -- entry point: leader keys, requires everything else
└── lua/
    ├── options.lua        -- vim.opt settings, colorscheme, tabline, shell config
    ├── keymaps.lua         -- general-purpose keymaps
    ├── commands.lua        -- custom user commands (:PackAdd, :MasonInstallAll, etc.)
    ├── pack.lua            -- vim.pack.add plugin list + requires for setup files
    ├── lsp.lua             -- Mason + native LSP config (vim.lsp.config/enable)
    ├── linter.lua          -- nvim-lint config
    ├── formatter.lua       -- conform.nvim config
    ├── treesitter.lua      -- nvim-treesitter parser list + FileType autocmd
    ├── mini.lua            -- mini.nvim module configuration
    ├── snack.lua           -- snacks.nvim module configuration
    └── quickswitch.lua     -- custom tab/buffer quick-switch (see below)
```

## Plugins

Installed via `vim.pack.add` in `pack.lua`:

| Plugin | Role |
| --- | --- |
| [mini.nvim](https://github.com/nvim-mini/mini.nvim) | Collection of independent, single-purpose modules (see below) |
| [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) | Snippet collection, loaded via `mini.snippets` |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting / parsing |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP server configs |
| [mason.nvim](https://github.com/mason-org/mason.nvim) | Manual install of LSP servers, linters, formatters |
| [oil.nvim](https://github.com/stevearc/oil.nvim) | Default file explorer (`-` opens parent dir, `<leader>-` toggles float) |
| [tiny-cmdline.nvim](https://github.com/rachartier/tiny-cmdline.nvim) | Centered floating cmdline UI |
| [nvim-lint](https://github.com/mfussenegger/nvim-lint) | Linting for languages the LSP doesn't cover well |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Formatting |
| [snacks.nvim](https://github.com/folke/snacks.nvim) | Picker, notifications, terminal, and other QoL modules (see below) |

### mini.nvim modules in use

- `mini.cmdline` — cmdline autocomplete/autocorrect (`autocorrect` disabled; paired with tiny-cmdline for UI positioning — different concerns, confirmed compatible)
- `mini.surround` — add/delete/change surrounding pairs (default keymaps: `sa`/`sd`/`sr`/`sf`/`sF`/`sh`/`sn`)
- `mini.completion` — completion engine, LSP auto-setup enabled (its `get_lsp_capabilities()` feeds into `lsp.lua`)
- `mini.snippets` — snippet expansion, loads `friendly-snippets` via `gen_loader.from_lang()`
- `mini.clue` — key sequence hints (leader, `[`/`]`, `g`, marks, registers, `<C-w>`, `z` triggers)
- `mini.hipatterns` — highlights FIXME/HACK/TODO/NOTE and live hex color previews
- `mini.ai` — extended text objects
- `mini.input` — `vim.ui.input()` replacement (integrates with `mini.surround`)
- `mini.bracketed` — `[x`/`]x` navigation
- `mini.diff` — git hunks in sign column
- `mini.splitjoin` — toggle single-line/multi-line code
- `mini.trailspace` — highlight/trim trailing whitespace
- `mini.pairs` — auto-close brackets/quotes
- `mini.icons` — icon provider

### snacks.nvim modules in use

- `picker` — file (`<leader>pf`), grep-word (`<leader>ps`), keymaps (`<leader>pk`), diagnostics (`<leader>xx`), help (`<leader>vh`), GitHub issues/PRs
- `notifier` — `vim.notify` implementation, minimal style (replaced `mini.notify`), `<C-h>` clears notifications
- `scroll` — smooth scrolling
- `lazygit` — floating LazyGit integration (`<leader>lg`)
- `gh` — GitHub issue/PR pickers (`<leader>gi`/`<leader>gI`/`<leader>gp`/`<leader>gP`)
- `indent` — indent guides
- `dim` — dim outside active scope, toggle on `<leader>di`
- `scope` — scope detection (feeds `dim`)
- `toggle` — boolean setting toggle keymaps
- `terminal` — floating/split terminal (`<leader>th`/`<leader>tv`/`<leader>tt` for horizontal/vertical/float)
- `rename` — LSP-integrated rename on file move, wired to Oil's `OilActionsPost` event

## LSP (`lsp.lua`)

- Servers: `lua_ls`, `marksman`, `gopls` (enabled via `vim.lsp.enable`, not `nvim-lspconfig`'s legacy setup style)
- `lua_ls` configured with `vim` as a known global (matches this config's own Lua files)
- Completion capabilities merged from `mini.completion`
- `gd` — go to definition, `<leader>df` — line diagnostics float
- `<leader>f` — format via native `vim.lsp.buf.format` (separate from `conform`'s `<leader>fp` — LSP-only fallback formatting, not the primary formatter path)
- Virtual text diagnostics enabled

## Linting (`linter.lua`)

- `javascript`/`typescript`/`jsx`/`tsx`/`svelte` → `biomejs`
- `python` → `pylint`
- `markdown` → `markdownlint-cli2`
- Runs automatically on `BufEnter`, `BufWritePost`, `InsertLeave`; `<leader>l` to trigger manually

## Formatting (`formatter.lua`)

- `formatters_by_ft` covers bash/sh (`shfmt`), C/C++ (`clang-format`), CSS/JS/JSON (`biome-check`), Go (`goimports` + `gofumpt`), HTML/svelte/yaml (`prettier`), Lua (`stylua`), markdown (`mdformat` + conditional `markdownlint-cli2`/`markdown-toc`), Nix (`nixfmt`), Python (`black`)
- `format_on_save` enabled (LSP fallback, 500ms timeout)
- `<leader>fp` — manual format (normal + visual mode, range-aware)

## Treesitter (`treesitter.lua`)

- Ensures parsers for: go, rust, typescript, javascript, tsx, html, css, json, bash, http, dockerfile
- Auto-starts highlighting for any filetype with a matching installed parser via a `FileType` autocmd, rather than a static list

## Options highlights (`options.lua`)

- Colorscheme: catppuccin (built-in to Neovim 0.12+, no plugin)
- Custom native `'tabline'` (`MyTabLine()`) — filename-only per-tab labels instead of the default full-path rendering, always shown (`showtabline = 2`)
- Cross-platform shell config (branches on `vim.fn.has("win32")`):
  - **Windows**: `pwsh`, with `shellquote`/`shellpipe`/`shellxquote`/`shellcmdflag`/`shellredir` set per `:h shell-powershell` for correct quoting
  - **NixOS**: `/run/current-system/sw/bin/bash` (stable path across system generations, unlike a raw `/nix/store/...` path)
- 4-space indentation, expandtab, smartindent, no wrap
- `undofile` enabled with a dedicated undo directory
- Manual folding (`foldmethod = "manual"`, high `foldlevel` so nothing folds by default)
- Yank highlight on `TextYankPost`

## Keymaps highlights (`keymaps.lua`)

- `<leader>d` — delete without yanking into a register; visual `p` — paste over selection without losing the yanked text
- `<C-c>` — escape insert mode / clear search highlight (normal mode)
- Visual mode `J`/`K` — move selected lines down/up; `<`/`>` — indent/unindent and keep selection
- `J` (normal) — join lines without moving the cursor
- `<C-d>`/`<C-u>` and `n`/`N` — centered scrolling/search
- `<leader>s` — replace word under cursor, globally, pre-filled and ready to edit
- `<leader>X` — make current file executable
- `<leader>re` — restart config
- `;` — enter command mode (skip the shift for `:`)
- `<leader>u` — toggle Neovim's built-in undotree

## Custom commands (`commands.lua`)

- `:PackAdd`, `:PackDel`, `:PackUpdate` — thin wrappers around `vim.pack`
- `:MasonInstallAll` — reads `linters_by_ft` (`linter.lua`), `formatters_by_ft`
  (`formatter.lua`), and enabled LSP configs (`lsp.lua`), maps mismatched
  names to their real Mason package names (`biomejs`/`biome-check` → `biome`,
  `lua_ls` → `lua-language-server`), de-duplicates, and installs anything
  missing. Nothing installs automatically — this is run manually on purpose.
- No-auto-comment-continuation autocmd (removes `c`/`r`/`o` from
  `formatoptions` on every filetype)

## Custom modules

### `quickswitch.lua`

Two related but independent features:

**Real tabpage switching** — `t1`, `t2`, `t3`... dynamically (re)bound to
however many tabpages are actually open, refreshed on `TabNew`/`TabClosed`/
`VimEnter`. Stale bindings beyond the current tab count are cleaned up
automatically when tabs close.

**Buffer-list popup** (`bl`, built on `snacks.win`) — lists buffers not
currently visible in the active tab:

- `<number>` — open buffer in place of the active one (current buffer suspends)
- `d<number>` — delete that buffer entirely *(currently buggy — not deleting; known issue, low priority)*
- `s<number>` — open in a horizontal split
- `v<number>` — open in a vertical split

Selecting a buffer that's open in another tab moves it here rather than
just also displaying it — its window(s) in the other tab are closed (if
that was the only window in that tab, the tab itself closes too).

## Backlog / planned

- Fix `quickswitch.lua`'s delete keybind (`d<number>` — not deleting yet)
- Nix tooling: `nil` (LSP), `statix` (linter) — formatter (`nixfmt`) already wired up
- Obsidian-flavored markdown formatting (`mdformat-wikilink`, `mdformat-obsidian`)
- `mini.colors` — consolidate colorscheme + highlight overrides (e.g.
  `FloatBorder`) into one place, keeping catppuccin as the base
- `blink.cmp` vs `mini.completion` — undecided
- `mini.sessions`, `mini.align`, `mini.operators`, `mini.move` — under consideration
- `mini.bufremove` — skip, redundant with `Snacks.bufdelete`
- `snacks.image` — parked for now
