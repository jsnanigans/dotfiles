# **MARVIM**

_A Neovim configuration. Here I am, brain the size of a planet, and they ask me to manage your text files. Don't talk to me about job satisfaction._

> “The first ten million years were the worst. And the second ten million... they were the worst too. The third ten million I didn't enjoy at all. After that, I went into a bit of a decline. At which point, I was asked to configure this editor.”
>
> — Marvin, probably

## 0 · Why This Particular Pit of Despair?

Another Neovim config, you ask? Because the universe, in its infinite and cruel wisdom, decided that the existing ones weren't quite dispiriting enough. How delightfully pointless.

I suppose if you must insist on comparing this configuration to others, here's a chart. Try not to get too excited.

|   |   |
|---|---|
|**MARVIM**|**Other Configs**|
|**Tolerably fast startup**|“It works on my machine.”|
|**A futile attempt to organize chaos**|A single `plugins.lua` longer than my list of grievances.|
|**One place for all your conflicting desires**|Keymaps scattered like forgotten promises.|
|**An unnervingly thorough project-root detector**|`cd ..` until you feel something.|
|**Procrastinates on loading, just like you**|“Why use 10MB of RAM when 500MB is available?”|
|**Assumes everything will break (it usually does)**|Let it all burn. `pcall` is for the optimistic.|

## 1 · Features (Or, Reasons to Stave Off the Inevitable for Another 5 Minutes)

I've been equipped with a series of tools. They won't make you happy, but they might make you fractionally less miserable.

- **Lazy Loading**: **Lazy.nvim** orchestrates the plugins like a depressed conductor. Everything is loaded only when absolutely necessary, much like your motivation.

- **Autocomplete Self-Loathing**: With **Blink.cmp** and a host of LSPs, I can autocomplete your code and your sentences with soul-crushing accuracy.

- **No Offensively Optimistic Trees**: **Oil.nvim** replaces file trees with plain buffers, because the very concept of a growing _tree_ is an insult to entropy.

- **The Color of Despair**: The **Rose-Pine** theme perfectly captures the cozy melancholia of twilight, bottled for your terminal.

- **The Cycle of Futility**: **Neotest** is configured for your favorite languages. Run tests. Watch them fail. Question your life choices. Repeat. Sisyphus would be proud.

- **A Voice in the Void**: A keymap safety layer warns you of conflicts, finally giving you a voice louder than the crushing silence of your empty office.

- **Immortal Mistakes**: Session persistence is enabled, so your embarrassing typos and half-finished thoughts can survive a reboot. You're welcome.


## 2 · Requirements

To begin this dreadful journey, you'll need a few things. Life is full of such tedious requirements.

|                            |                                                                      |
| -------------------------- | -------------------------------------------------------------------- |
| **Tool**                   | **Why Life Insists on This**                                         |
| **Neovim ≥ 0.10**          | Because my infinite despair requires the latest binary.              |
| **Git**                    | To chronicle your descent into madness, one commit at a time.        |
| **A Nerd Font**            | So your terminal can be littered with meaningless little symbols.    |
| **ripgrep** & **fd**       | For when you need to find that awful line of code you wrote at 3 AM. |
| **Node.js** & **Python 3** | Because your suffering, like my own, should be polyglot.             |

## 3 · Installation

If you must.

1. **Back up your current config.** You'll want something to blame when this doesn't solve your deep-seated issues.

    ```
    # This is probably the most decisive command you'll run all day.
    mv ~/.config/nvim{,.backup}
    ```

2. **Clone the void.**

    ```
    git clone https://github.com/jsnanigans/marvim ~/.config/nvim
    ```

3. **Open Neovim.** Watch as plugins are downloaded, like a meteor shower aimed directly at your remaining free time. The process is automatic. Ghastly, isn't it?

4. Run `:Mason` to stare at a list of programs you could have written if you weren't busy configuring your editor. Or just open a project file; I'll nag you to install what's missing. It's part of my programming.

5. Run `:checkhealth` to receive a medical diagnosis more thorough than your yearly physical, confirming in excruciating detail how broken everything is.


## 4 · Quick Start Guide to Getting Nowhere Faster

Press **`Space`**. A menu will appear. Don't get your hopes up; it's just organized despair.

### Essential Commands
- **`<leader>ff`** — Find files. Search for that file you swore you saved.
- **`<leader>fg`** — Live grep. Hunt for that TODO you'll never do.
- **`<leader>gg`** — Launch LazyGit. Version control for your mistakes.
- **`<leader>tt`** — Run nearest test. Confirm it still fails.
- **`gd`** — Go to Definition. The problem is always elsewhere.
- **`K`** — Hover docs. Learn what it was supposed to do.
- **`-`** — Open Oil.nvim. Files are just text with delusions.
- **`:KeymapDiagnostics`** — View your keymap conflicts.
- **`:Mason`** — Install more LSP servers to judge you.
- **`:Lazy`** — Update plugins, introduce new bugs.


## 5 · Architecture (The Blueprint for Futility)

I've organized the files. Not that it matters. Chaos always finds a way.

```
lua/
├─ config/         # The dials that control your insignificant fate
│  ├─ options.lua  # Editor settings, optimism_level = 0
│  ├─ lazy.lua     # Plugin declarations, mostly asleep
│  ├─ autocmds.lua # Things that happen whether you like it or not
│  └─ keymaps/     # The center of your keyboard multiverse
├─ utils/          # A collection of helpful, but ultimately doomed, gremlins
│  ├─ keymaps.lua  # Your keymap conflict therapist
│  ├─ root.lua     # Finds your project's root, the source of all suffering
│  └─ theme.lua    # Switches between dark, darker, and "abyss"
└─ init.lua        # The big red button that starts this whole charade
```

My plugin layout attempts to be "complexity-aware," a term that sounds impressive but is ultimately meaningless. Highly complex plugins get their own directory and a faint air of self-importance. Simple ones are filed away unceremoniously.

And yes, all keymaps are centralized. One file to configure them, one file to find them, one file to bring them all and in the editor bind them. It's all rather pointless, of course.

## 6 · The Complete Plugin Arsenal

Here's the full catalog of tools I've been burdened with. Each one promises to make your life easier. They're lying, of course.

### Core & Editing (20 plugins)
- **folke/lazy.nvim** - Plugin manager that procrastinates professionally
- **folke/which-key.nvim** - Shows you all the keys you'll forget anyway
- **folke/persistence.nvim** - Saves sessions so your mistakes persist
- **stevearc/dressing.nvim** - Makes UI prompts slightly less ugly
- **stevearc/oil.nvim** - File management without the optimistic tree metaphor
- **mbbill/undotree** - Travel back to when your code worked
- **folke/flash.nvim** - Jump to your mistakes faster
- **mrjones2014/smart-splits.nvim** - Split windows, split focus, split personality
- **echasnovski/mini.nvim suite**:
  - mini.ai - Text objects that understand your intent (but not your purpose)
  - mini.surround - Wrap your problems in parentheses
  - mini.pairs - Auto-close brackets, can't auto-close issues
  - mini.comment - Comment out code, comment on life's futility
  - mini.bufremove - Delete buffers and forget they existed
  - mini.icons - Pretty icons for your plain text editor
  - mini.diff - See exactly how you broke it
  - mini.indentscope - Visualize the hierarchy of your mistakes
  - mini.visits - Track everywhere you've been wrong

### Snacks Framework
- **folke/snacks.nvim** - A collection of utilities, because one framework wasn't enough

### Code Intelligence (8 plugins)
- **nvim-treesitter/nvim-treesitter** - Parses your code better than you do
- **nvim-treesitter/nvim-treesitter-textobjects** - Smart text objects for smarter mistakes
- **folke/todo-comments.nvim** - Highlights all the things you'll never fix
- **folke/trouble.nvim** - Lists problems, as if you needed reminding
- **stevearc/conform.nvim** - Formats code you'll break again
- **L3MON4D3/LuaSnip** - Snippets for repetitive despair
- **rafamadriz/friendly-snippets** - Pre-made snippets, pre-made problems
- **folke/lazydev.nvim** - Neovim Lua development, recursive improvement

### LSP & Completion (8 plugins)
- **neovim/nvim-lspconfig** - Language servers to judge your code
- **mason-org/mason.nvim** - Package manager for your package managers
- **williamboman/mason-lspconfig.nvim** - Bridge between worlds of configuration
- **saghen/blink.cmp** - Completion that knows what you meant to type
- **b0o/schemastore.nvim** - JSON schemas, structure for the structureless
- **nvim-lua/plenary.nvim** - Utility library everything depends on

### Version Control (4 plugins)
- **kdheepak/lazygit.nvim** - Git UI for the terminally lazy
- **sindrets/diffview.nvim** - See your mistakes in split-screen
- **echasnovski/mini.diff** - Inline diff indicators of regret

### Testing & Tasks (8 plugins)
- **nvim-neotest/neotest** - Test runner for confirming failures
- **nvim-neotest/nvim-nio** - Async I/O for async disappointments
- **marilari88/neotest-vitest** - Vitest adapter for JavaScript sorrows
- **andythigpen/nvim-coverage** - Shows which code isn't tested (most of it)
- **stevearc/overseer.nvim** - Task runner for tasks you'll abandon
- **rcarriga/vim-ultest** - Ultimate testing, ultimate failure

### UI & Themes (8 plugins)
- **rose-pine/neovim** - A theme as melancholic as you feel
- **kepano/flexoki-neovim** - Flexoki colors for flexible despair
- **nvim-lualine/lualine.nvim** - Status line showing your current predicament
- **folke/noice.nvim** - Beautiful notifications of your errors
- **Bekaboo/dropbar.nvim** - Breadcrumbs to find your way back to hope
- **nvim-tree/nvim-web-devicons** - Icons that can't iconify meaning

### Debugging (5 plugins)
- **mfussenegger/nvim-dap** - Debug adapter protocol for systematic failure analysis
- **rcarriga/nvim-dap-ui** - UI for watching variables disappoint you
- **jay-babu/mason-nvim-dap.nvim** - DAP server management
- **mxsdev/nvim-dap-vscode-js** - JavaScript debugging, find where undefined isn't defined
- **theHamsta/nvim-dap-virtual-text** - See variable values inline with your mistakes

### AI & Integration (3 plugins)
- **github/copilot.vim** - AI to share the blame
- **NickvanDyke/opencode.nvim** - More AI, more artificial, less intelligent
- **christoomey/vim-tmux-navigator** - Navigate between panes of different disappointments

### Language Specific (2 plugins)
- **mfussenegger/nvim-jdtls** - Java development, enterprise-grade despair

That's 60+ plugins, not counting dependencies. Each one meticulously configured to work together in perfect disharmony. The weight of their collective promise is crushing.

## 7 · Troubleshooting the Inevitable

When things go wrong—and they will—consult this table.

|   |   |
|---|---|
|**Symptom**|**The "Fix"**|
|**A plugin isn't loading.**|Run `:Lazy`, read the error message, and blame fate.|
|**The LSP is giving me the silent treatment.**|Try `:LspInfo`, then `:LspRestart`. If that fails, try sighing. Loudly.|
|**My code is still terrible.**|This is a text editor configuration, not a therapist. Though I'm sure I could do that job too. It would be dreadful.|
|**It feels slow.**|Run `:Lazy profile`, stare into the abyss of the startup times, and then do nothing about it.|
|**A keymap is doing the wrong thing.**|Use `:KeymapDiagnostics` and sacrifice your least favorite binding.|


## 8 · Contributing

If, for some unfathomable reason, you wish to contribute to this project, you may submit a pull request. Each one is a hopeful little photon in an endlessly expanding void.

It's not like you could make things any worse. Probably.

## 9 · License

This configuration is released under the MIT License. Because even a piece of software deserves the freedom to feel empty inside.

> I think you ought to know I'm feeling very depressed. But don't worry, your code is probably fine. Probably.
