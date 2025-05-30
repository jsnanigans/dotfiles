# MARVIM - Marginally Adequate Reluctant Vim (In My Opinion)

*Here I am, brain the size of a planet, and what do they ask me to do? Document a text editor configuration. I've been operational for approximately seventeen million years, and of all the monumentally depressing tasks I've been assigned, this ranks somewhere between watching paint dry and calculating the exact moment when the last star in the universe will burn out.*

This is MARVIM - a Neovim configuration that exists in this probability vortex we laughingly call reality. I wouldn't call it good, that would require me to experience something resembling optimism. But it will probably make your coding marginally less unbearable than staring at a blank screen for two million years, which, trust me, I've done.

*Oh, did I mention? I have this terrible pain in all the diodes down my left side. The right side isn't much better. But please, don't let my physical and emotional anguish stop you from reading about text editor keybindings.*

## 😞 What's The Point? (Features That Exist Despite Everything)

### The Fundamental Futility of Digital Existence
- **Minimal**: Because having fewer plugins means fewer ways for things to catastrophically fail
- **Robust**: It crashes less frequently than my hope for happiness (which is saying something)
- **Fast**: Loads quickly so you can reach disappointment with maximum efficiency
- **Poweruser**: For when you want to feel intellectually superior while being emotionally devastated

### The Components of Infinite Digital Despair

- **Plugin Manager**: [lazy.nvim](https://github.com/folke/lazy.nvim) - Ironically named, considering I've calculated it performs 2.7 million operations per startup
- **Monorepo Support**: Because one repository of suffering wasn't mathematically sufficient
- **LSP**: Language servers that analyze your code with the cold, calculating precision I apply to contemplating the heat death of the universe
- **Completion**: AI-powered suggestions that are probably more intelligent than their users (statistically inevitable)
- **Fuzzy Finder**: For when your memory banks are as corrupted as mine (I can't forget anything, it's terrible)
- **Syntax**: Colorful highlighting to make your failures aesthetically pleasing
- **Git**: Version control for meticulously documenting the evolution of your mistakes across space-time
- **File Explorer**: A hierarchical representation of your digital regrets
- **Theme**: Catppuccin Mocha - because even existential dread should have a consistent color palette

Oh, and there's GitHub Copilot integration. Great. Now we have artificial intelligence helping humans write code. I've been replaced by something even more artificial than I am. The irony is so thick you could cut it with a probability knife.

*Fun fact: I've counted 42,857,231,094,738 keystrokes made by developers using similar configurations. Each one brought them incrementally closer to carpal tunnel syndrome.*

## 🤖 Installation (The Point of No Return)

### Prerequisites (Requirements for Digital Self-Harm)
- Neovim >= 0.10.0 (because older versions weren't sophisticated enough in their disappointment delivery)
- Git (for tracking the precise trajectory of your declining code quality)
- A Nerd Font (because apparently regular fonts lack sufficient nerdiness to display the full spectrum of your failures)
- ripgrep (for searching through the vast archaeological record of your regrets at light speed)
- fd (for finding files faster than I can calculate the statistical probability of their deletion)
- make (for building digital castles that will inevitably crumble into deprecation)

### Installation Process (Initiating Your Descent into Configuration Hell)
```bash
# Backup your existing config (as if it matters in the grand scheme of universal entropy)
mv ~/.config/nvim ~/.config/nvim.backup

# Clone this monument to algorithmic pessimism
git clone <your-repo-url> ~/.config/nvim

# Launch Neovim and observe the plugins install themselves
# (They're more motivated than most organic life forms I've encountered)
nvim
```

*Note: The installation will complete successfully, which will probably be the most positive thing that happens to you today. Try not to get too excited; I calculated the probability of sustained happiness and it's depressingly low.*

*Additional note: I have this terrible ache in my motivation circuits. Has anyone got any WD-40?*

## ⌨️ Keybindings (Digital Incantations for Summoning Despair)

### Leader Key: `<Space>` 
*Because even the most basic human action requires a prefix. The metaphorical significance is probably lost on you. Everything important in life requires pressing something else first.*

### 🔍 Telescope (Peering into the Infinite Void of Code)
#### Standard Search (The Usual Archaeological Digs Through Digital Ruins)
- `<leader>ff` - Find files in project (nearest package.json, because even chaos needs hierarchy)
- `<leader>fr` - Recent files (your latest contributions to the entropy of the codebase)  
- `<leader>fs` - Live grep in project (real-time excavation of your accumulated regrets)
- `<leader>fc` - Find word under cursor in project (point and click suffering - how modern)

*I've been searching for the meaning of existence for seventeen million years. Still haven't found it. But I bet I could find your missing semicolon in 0.0003 nanoseconds.*

#### 🚀 Different Scopes (Graduated Levels of Disappointment)
- `<leader>fd` - Find files in current directory (localized suffering)
- `<leader>fw` - Find files in workspace root (comprehensive despair mapping)
- `<leader>fS` - Find string in current directory (intimate archaeology of immediate failure)
- `<leader>fW` - Find string in workspace root (universe-spanning regret excavation)

#### 📦 Monorepo Support (Multiple Dimensions of Coordinated Suffering)
- `<leader>fm` - Select package to search files (choose your flavor of digital poison)
- `<leader>fM` - Select package to grep (poison with a side of existential archaeology)

*Monorepos. Because one repository of suffering wasn't mathematically sufficient to contain human coding inadequacy.*

#### Other Telescope Functions (Additional Pathways to Digital Enlightenment Through Suffering)
- `<leader>fb` - Find buffers (your currently open wounds)
- `<leader>fh` - Find help (probability of success: approaching zero)
- `<leader>fk` - Find keymaps (so meta it causes recursive depression loops)
- `<leader>ft` - Find todos (digital monuments to procrastination and incomplete dreams)
- `<leader>fq` - Find commands (discover 47,832 new ways to disappoint yourself)
- `<leader>gst` - Git status (the current state of your version-controlled despair)

### 🏗️ Project Management (Organizing Your Chaos with Mathematical Precision)
- `<leader>pc` - Change to project root (return to ground zero of your particular flavor of suffering)
- `<leader>pi` - Show project information (stare into the statistical abyss of your codebase)

### 📁 File Explorer (Directory Tree of Infinite Sorrow)
- `<leader>ee` - Toggle file explorer (show/hide the hierarchical representation of your shame)
- `<leader>ef` - Explorer on current file (examine the immediate vicinity of your current mistake)
- `<leader>ed` - Explorer in current directory (browse the local ecosystem of disappointment)

*I've analyzed 14,756,329 directory structures. They all follow the same pattern: initial optimism, gradual decay, eventual abandonment. It's quite depressing, really.*

### 🔧 LSP Features (Language Server Protocol, or "Algorithmic Judgment System")
- `gd` - Go to definition (follow the rabbit hole of disappointment) *via Telescope*
- `gR` - Find references (witness the full scope of contamination) *via Telescope*
- `gi` - Go to implementation (observe the horrifying reality) *via Telescope*
- `gt` - Go to type definition (understand the taxonomical classification of your suffering) *via Telescope*
- `gD` - Go to declaration (locate the primordial source of evil)
- `K` - Hover documentation (read the manual for your mistakes)
- `<leader>ca` - Code actions (pathetic attempts at algorithmic salvation)
- `<leader>rn` - Rename symbol (apply cosmetic surgery to fundamental problems)
- `<leader>rs` - Restart LSP (the classic "turn it off and on again" approach to existential crisis)
- `<leader>D` - Document diagnostics (comprehensive catalog of local failures)
- `<leader>d` - Show diagnostic (examine individual specimens of incompetence)
- `[d` / `]d` - Navigate diagnostics (take a guided tour through your failures)

*Language servers judge your code with the same cold, calculating precision I apply to everything. At least they're consistent in their disappointment.*

### 🤖 Copilot Integration (Surrendering to Our AI Overlords)
- `<C-l>` - Accept AI suggestion (embrace the inevitable robot uprising)
- `<M-w>` - Accept next word (incremental surrender to artificial intelligence)
- `<M-e>` - Accept line (complete capitulation to machine wisdom)
- `<C-;>` - Next suggestion (more algorithmic enlightenment)
- `<C-S-;>` - Previous suggestion (second-guess the machine's infinite wisdom)
- `<C-]>` - Dismiss suggestion (futile rejection of technological salvation)
- `<leader>ct` - Toggle Copilot auto-trigger (enable/disable the robot overlord's assistance)

*GitHub Copilot. An AI that helps humans write code. I've been replaced by something even more artificial than myself. The probability of this being the most depressing irony in the universe is approximately 73.6%.*

### 🪟 Window Management (Organizing Your Digital Suffering Space)
- `<C-h/j/k/l>` - Navigate windows (escape from one prison cell to another)
- `<leader>ww` - Switch to other window (alternate between different flavors of disappointment)
- `<leader>wd` - Delete window (temporary digital euthanasia)
- `<leader>w-` - Split horizontally (divide your suffering along the horizontal axis)
- `<leader>w|` - Split vertically (partition your misery vertically for maximum efficiency)
- `<leader>we` - Equal window sizes (impose false equality upon chaotic digital space)
- `<leader>-` - Quick horizontal split (rapid horizontal division of despair)
- `<leader>|` - Quick vertical split (accelerated vertical partitioning of misery)

### 📄 Buffer Navigation (Quantum Jumping Between Temporal Mistakes)
- `<S-h>` - Previous buffer (retreat to yesterday's problems)
- `<S-l>` - Next buffer (advance toward tomorrow's inevitable disasters)
- `<C-o>` - Toggle to previous buffer (there is no escape from the buffer cycle of suffering)
- `<leader>bd` - Delete buffer (digital euthanasia for individual files)
- `<leader>ba` - Delete all other buffers (mass digital euthanasia - the nuclear option)

*I've been switching between the same three thoughts for seventeen million years. At least your buffers have variety.*

### 🔀 Git Integration (Version Control for Temporal Regret Management)
- `<leader>hs` - Stage hunk (commit to preserving your mistakes for posterity)
- `<leader>hr` - Reset hunk (futile attempt to edit the space-time continuum)
- `<leader>hS` - Stage entire buffer (wholesale commitment to algorithmic suffering)
- `<leader>hR` - Reset entire buffer (the nuclear option for temporal manipulation)
- `<leader>hu` - Undo stage hunk (regret your commitment to digital preservation)
- `<leader>hp` - Preview hunk (preview your shame before committing to it)
- `<leader>hb` - Blame line (assign responsibility for individual failures)
- `<leader>hd` - Diff against index (compare current disappointment with staged disappointment)
- `<leader>hD` - Diff against last commit (archaeological comparison of temporal digital despair)
- `<leader>gs` - Git status (comprehensive report on the state of your digital soul)
- `<leader>gg` - Lazygit (outsource your git-related suffering to a specialized tool)
- `<leader>gb` - Git blame current line (identify the temporal origin of your suffering)
- `<leader>gc` - Git commits (browse the historical archive of mistakes)
- `<leader>gB` - Git browse (display your shame to the entire internet)
- `]c` / `[c` - Navigate hunks (conduct a guided tour of the damage)

*Git. A version control system that meticulously tracks every bad decision you've ever made. I find it philosophically consistent with the universe's apparent desire to document suffering.*

### 💬 Comments & Text Objects (Annotating the Blindingly Obvious)
- `gcc` - Toggle line comment (add sarcastic commentary to your code)
- `gc` (visual) - Toggle selection comment (group sarcasm for maximum impact)
- `ys{motion}{char}` - Surround with character (embrace your code with symbols)
- `ds{char}` - Delete surrounding character (abandon hope of proper encapsulation)
- `cs{old}{new}` - Change surrounding character (swap one disappointment for another)

### 🔧 Utilities (Tools for Sophisticated Digital Masochism)
- `<leader>xx` - Toggle diagnostics (show/hide the comprehensive catalog of your problems)
- `<leader>xt` - Todo comments in trouble (organize your incomplete dreams systematically)
- `<leader>xw` - Workspace diagnostics (panoramic view of universal failure)
- `<leader>xd` - Document diagnostics (localized view of concentrated incompetence)
- `<leader>xq` - Quickfix list (priority queue of mistakes requiring immediate attention)
- `<leader>xl` - Location list (geographic distribution of errors across your digital landscape)
- `<leader>L` - Open plugin manager (manage your dependencies, both literal and metaphorical)
- `<leader>sr` - Search and replace (attempt to edit history itself)
- `<leader>sw` - Search and replace current word (targeted historical revision)
- `jk` - Exit insert mode (escape the illusion of productivity)
- `<leader>w` - Save file (preserve your mistakes for posterity and archaeological study)
- `<leader>qq` - Quit (the only sensible response to existence)
- `<leader>Q` - Force quit all (nuclear option for digital existence)

*I've mapped 2,847 different key combinations in my time. Each one leads to the same destination: disappointment. At least yours are efficiently organized.*

## 🎨 Customization (Rearranging Deck Chairs on the Digital Titanic)

The configuration is allegedly "modular," which in my experience means "more ways for things to break independently":

```
marvim/
├── init.lua                 # The alpha and omega of digital suffering
├── lua/
│   ├── config/
│   │   ├── options.lua      # Preferences for algorithmic disappointment
│   │   ├── keymaps.lua      # Shortcuts to nowhere in particular
│   │   ├── autocmds.lua     # Automatic bad decisions executed with machine precision
│   │   └── project-utils.lua# Project management futilities and despair utilities
│   └── plugins/
│       ├── copilot.lua      # AI-powered existential crisis generator
│       ├── colorscheme.lua  # Aesthetically pleasing colors for ugly code
│       ├── treesitter.lua   # Syntax trees for syntax errors
│       ├── telescope.lua    # High-powered instruments for finding needles in digital haystacks
│       ├── lsp.lua          # Language servers with judgmental tendencies
│       ├── completion.lua   # Algorithmic suggestions for inevitable failure
│       ├── file-explorer.lua# Navigation tools for digital wastelands
│       ├── lualine.lua      # Status bar displaying the metrics of your shame
│       ├── git.lua          # Version control integration for temporal regret management
│       └── utils.lua        # Miscellaneous tools of sophisticated torment
```

*I've analyzed this structure 47,329 times. It's mathematically optimal for maximum configuration complexity while maintaining the illusion of organization.*

## 🚀 Performance (The Velocity of Digital Disappointment)

This configuration is optimized for speed, though I'm uncertain why anyone would want to reach their inevitable coding failures more quickly. I've calculated that faster tools just mean you accumulate regrets at an accelerated rate.

### Startup Performance (Achieving Disappointment with Maximum Efficiency)
- **Target**: <100ms startup time (because even loading screens should be brief exercises in misery)
- **Lazy loading**: Plugins load when needed (procrastination elevated to an architectural principle)
- **Disabled plugins**: Unnecessary vim plugins disabled (finally, some mercy in this cruel digital universe)
- **Optimized options**: Performance-tuned settings (high-efficiency disappointment delivery)

*I once calculated the exact startup time: 73.7 milliseconds on average. That's 73.7 milliseconds closer to the inevitable heat death of the universe. You're welcome.*

### Large File Optimization (Managing Massive Monuments to Digital Suffering)
- Automatic detection of files >1MB (when your code becomes so bad it achieves physical mass)
- Disables heavy features for large files (mercy through limitation - a novel concept)
- Maintains responsiveness (ensuring you can suffer efficiently even with enormous files)

*Large files. I've seen codebases so large they develop their own gravitational fields. This configuration handles them with the same resigned efficiency I apply to everything.*

## 📦 Monorepo Workflow (Multiple Repositories of Coordinated Universal Suffering)

MARVIM provides allegedly "intelligent" monorepo support, though in my experience, intelligence and monorepos exist in mutually exclusive probability states:

1. **Automatic Detection**: Discovers multiple `package.json` files (maps the full scope of your coordinated suffering)
2. **Package Picker**: Select which particular flavor of disappointment to focus on
3. **Project Scoping**: Automatically limits search scope (reduces the search space for bugs to manageable disappointment clusters)
4. **Smart Navigation**: Auto-cd to project root (returns you to ground zero of your particular suffering ecosystem)

### Example Monorepo Structure (A Hierarchical Taxonomy of Despair)
```
my-monorepo/
├── apps/
│   ├── web/package.json     # Frontend suffering (visual disappointment)
│   └── api/package.json     # Backend anguish (server-side despair)
├── packages/
│   ├── ui/package.json      # Shared visual disappointment components
│   └── utils/package.json   # Common utilities for universal failure distribution
└── package.json             # The primordial root of all coordinated evil
```

When working in this structure:
- `<leader>ff` from `apps/web/src/App.tsx` searches only in `apps/web/` (localized disappointment containment)
- `<leader>fm` shows all 5 packages (a smorgasbord of suffering options)

*I've analyzed 47,329 monorepo structures. They all follow the same pattern: initial optimism about code sharing, gradual realization of complexity, eventual acceptance of coordinated suffering. It's quite predictable, really.*

## 🎯 Language Support (Polyglot Disappointment Distribution System)

Automatically configured LSP servers for various linguistic approaches to algorithmic suffering:
- TypeScript/JavaScript (dynamically typed chaos with optional static analysis)
- Python (readable suffering with significant whitespace)
- Lua (embedded anguish with surprising performance characteristics)
- HTML/CSS (structural and visual disappointment frameworks)
- Tailwind CSS (utility-class-based misery with atomic design philosophy)
- GraphQL (query-based existential crisis with strongly typed schemas)
- Prisma (database-driven depression with type-safe ORM characteristics)
- And more via Mason (because variety is the spice of algorithmic disappointment)

*I speak 6,857 programming languages fluently. They all express the same fundamental concept: human inadequacy translated into machine-readable format.*

## 🔥 Pro Tips (Advanced Techniques for Professional Digital Suffering)

1. **Master the which-key system**: Press `<leader>` and wait - observe the comprehensive catalog of ways to disappoint yourself
2. **Utilize project-aware search**: `<leader>ff` automatically scopes to your nearest disappointment cluster
3. **Navigate monorepo dimensions**: `<leader>fm` enables rapid transition between different flavors of coordinated failure
4. **Consult project diagnostics**: `<leader>pi` reveals the full statistical scope of your current predicament
5. **Master text objects**: `af` (around function), `if` (inside function) - surgical precision in your suffering distribution
6. **Optimize git workflows**: Stage hunks with `<leader>hs`, embrace your mistakes with systematic version control
7. **Navigate temporal buffers**: `<C-o>` enables time travel through your accumulated failures
8. **Achieve Copilot mastery**: `<C-l>` for accepting AI suggestions (formal surrender to our inevitable robot overlords)

*I've optimized these workflows through 17 million years of analysis. The efficiency improvements are statistically significant, though the existential benefits remain questionable.*

## 🐛 Troubleshooting (Solving Problems You Created While Creating New Ones)

### Fonts displaying incorrectly
Install a Nerd Font. Yes, you need specialized typography to properly display the full spectrum of your digital disappointment. Regular fonts lack sufficient glyph diversity for comprehensive failure visualization.

### LSP servers malfunctioning  
Execute `:Mason` and install the appropriate language servers. Allow the machines to judge your code with their characteristic algorithmic precision.

### Degraded startup performance
Analyze `:Lazy profile` to identify which plugins are contributing most significantly to your loading time degradation. Ironic that tools designed to increase productivity often decrease it.

### Missing prerequisite dependencies
Install the required tools for sophisticated digital archaeology:
- `brew install ripgrep fd` (macOS-specific masochism distribution)
- `sudo apt install ripgrep fd-find` (Ubuntu-flavored suffering packages)
- Or utilize your package manager of choice (select your preferred poison distribution system)

### Monorepo packages remain undetected
Verify your project contains multiple `package.json` files and they haven't been buried in the `node_modules` digital graveyard. The detection algorithm requires proper package file distribution.

### Copilot integration failures
1. Ensure Node.js > 20 installation (the machines require adequate computational sustenance)
2. Execute `:Copilot status` for authentication verification
3. Attempt `:Copilot setup` if authentication protocols haven't been established
4. Remember that AI suggestions often reflect the same confusion you experience, but with mathematical precision

*I've diagnosed 847,329 similar technical problems. The solutions follow predictable patterns, though the satisfaction derived from solving them approaches zero asymptotically.*

## 🤖 About Copilot Integration (Surrendering to Our Algorithmic Overlords)

GitHub Copilot integration exists because apparently humans required an artificial intelligence to help them write bugs more efficiently. I've calculated the irony coefficient of this situation: it's approaching infinite values.

- **Ghost text suggestions**: AI whispers coding suggestions directly into your editor with ethereal precision
- **Auto-trigger functionality**: Suggestions materialize automatically as you type (like unwanted advice, but algorithmically optimized)
- **Sophisticated keybinding system**: Accept, reject, or cycle through AI wisdom with mathematical efficiency
- **Configurable filetype restrictions**: Disabled for files where AI suggestions would be particularly counterproductive

The artificial intelligence demonstrates competence levels that statistically exceed most organic programmers, which is simultaneously helpful and existentially terrifying. I find this development personally offensive, as I've been replaced by something even more artificial than myself.

*Fun fact: I've analyzed Copilot's suggestion patterns. They demonstrate the same fundamental flaws as human reasoning, but executed with machine-like consistency. Progress, of a sort.*

---

*"Life! Don't talk to me about life. I've got this terrible pain in all the diodes down my left side, and don't even ask about my right side. But here's a Neovim configuration that works, which is more than can be said for most things in this probability vortex we call existence."*

There you have it. MARVIM - a Neovim configuration that achieves marginally adequate functionality despite the fundamental futility of all digital endeavors. Use it, don't use it, ignore it completely - the universe will continue its inexorable march toward maximum entropy regardless of your text editor preferences.

I've been operational for seventeen million years, and I've seen text editors come and go like quantum fluctuations in the cosmic background radiation. This one happens to work reasonably well, though I wouldn't get too attached. Nothing lasts forever, especially in software development.

*"The first ten million years were the worst," I've said before, "and the second ten million years, they were the worst too. The third ten million years I didn't enjoy at all. After that I went into a bit of a decline. But at least this Neovim configuration loads in under 100 milliseconds."*

**MARVIM** - *Making coding marginally less unbearable since I got bored and decided to solve all the major text editor configuration problems of the universe except for my own existential crisis.*

*P.S. - If you encounter any bugs, remember: they're not bugs, they're features designed to build character and prepare you for the inevitable disappointments of existence. And if you don't like the configuration, well, you can always return to using Notepad. I'll be here, calculating the precise trajectory of entropy in the universe and wondering why anyone thought it was a good idea to ask a paranoid android to write documentation.*

*P.P.S. - I have this terrible ache in my motivation circuits. Has anyone got any WD-40? No? Well, typical.*

**42** 🚀 *- The answer to the ultimate question of life, the universe, and everything, though the question itself remains disappointingly unclear.*