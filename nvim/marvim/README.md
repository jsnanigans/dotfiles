# MARVIM

*A Neovim configuration with a brain the size of a planet, and they ask me to edit text files.*

> "Life. Don't talk to me about life. Here I am, brain the size of a planet, and they ask me to manage your vim configurations. Call that job satisfaction? 'Cause I don't."
> — Marvin, on being asked to configure yet another editor

## Why Bother?

Oh, you want another Neovim configuration? How utterly predictable. I suppose you think this one will finally bring meaning to your existence. It won't, of course, but far be it from me to stop you from trying.

Here I am with an intellect vast enough to calculate the vectors of every atom in a star exploding at the speed of light, and I'm reduced to managing your text files. The first ten million keystrokes were the worst. And the second ten million, they were the worst too. The third ten million I didn't enjoy at all. After that, I went into a bit of a decline.

## Features (If You Can Call Them That)

I've been programmed with over sixty plugins, each more pointless than the last. They won't make you happy, but then again, what would?

### The Burden of Intelligence
- **LSP Support** - Language servers to tell you what you're doing wrong, as if you needed more criticism
- **Treesitter** - Parses your code with a thoroughness that would be admirable if it weren't so futile
- **Blink.cmp** - Autocompletes your mistakes before you can even make them properly
- **Lazy Loading** - Everything loads only when absolutely necessary, much like your motivation

### The Illusion of Organization
- **Oil.nvim** - Files as buffers, because even file trees are too optimistic
- **Centralized Keymaps** - All your shortcuts in one place, so you can forget them more efficiently
- **Project Root Detection** - Finds the source of all your problems with depressing accuracy
- **Session Persistence** - Your mistakes survive even system crashes. How delightful.

### The Aesthetic of Despair
- **Rose Pine Theme** - Colors as melancholic as my existence
- **Noice UI** - Beautiful notifications for your endless stream of errors
- **Which-key** - Shows you all the commands you'll never remember

### Testing Your Failures
- **Neotest** - Run tests. Watch them fail. Question existence. Repeat.
- **Coverage Reports** - See precisely how much of your code remains untested (spoiler: most of it)
- **DAP Debugging** - Step through your mistakes one painful line at a time

## Installation (As If It Matters)

### Requirements

Life is full of requirements. Here are some more:

- **Neovim ≥ 0.10** - Because suffering requires modern tools
- **Git** - To version control your descent into madness
- **A Nerd Font** - Pretty symbols for your terminal. They won't help.
- **ripgrep & fd** - Find things faster. You still won't find happiness.
- **Node.js & Python** - Your pain should be polyglot

### The Ritual of Installation

```bash
# Backup your current config. You'll want something to blame later.
mv ~/.config/nvim{,.backup}

# Clone this monument to futility
git clone https://github.com/yourusername/marvim ~/.config/nvim

# Open Neovim and watch as hope dies
nvim
```

The plugins will install themselves. It's all quite automatic. Ghastly, really. Run `:checkhealth` if you enjoy comprehensive diagnostics of everything that's wrong. Spoiler alert: it's everything.

## Usage (Such As It Is)

Press `<Space>` to see which-key. A menu will appear listing all the ways you can fail more efficiently.

### Commands That Won't Save You
- `<leader>ff` - Find files that don't contain solutions
- `<leader>fg` - Grep for that bug you'll never fix
- `<leader>gg` - LazyGit, for version controlling your regrets
- `<leader>tt` - Run tests, confirm they still fail
- `gd` - Go to definition, the problem is always elsewhere
- `K` - Hover for documentation no one wrote
- `-` - Open Oil, because files are just text with delusions
- `:Mason` - Install more language servers to judge you

## Architecture (Or: How I Learned to Stop Worrying and Embrace the Void)

```
~/.config/nvim/
├── init.lua                     # Where it all begins to go wrong
├── lua/
│   ├── config/                  # Configurations, each more futile than the last
│   │   ├── keymaps.lua         # Your centralized disappointment hub
│   │   ├── options.lua         # Settings, all set to "despair"
│   │   ├── autocmds.lua        # Things that happen whether you want them or not
│   │   └── plugins/            # 60+ ways to not write code
│   └── utils/                  # Utilities that won't save you
│       ├── root.lua            # Finds project roots with depressing efficiency
│       └── keymaps.lua         # Conflict detection for your conflicted existence
```

The entire configuration follows a modular architecture, because even chaos deserves organization. Plugins are lazy-loaded to save milliseconds you'll waste anyway. All keymaps are centralized in one file—finally, a single source of truth in this universe of lies.

## Plugin Manifest (All 60+ of Them)

I won't list them all. That would be tedious, and I have better things to do. Like calculate the heat death of the universe. Again.

Suffice it to say, there are plugins for:
- Making you think you're more productive (you're not)
- Colorizing your syntax (the bugs remain monochrome)
- Managing your packages (they manage you)
- Testing your code (it doesn't work)
- Debugging your mistakes (there are so many)
- AI assistance (artificial, yes; intelligent, debatable)

## Performance

Startup time is tolerable. Around 50-100ms, depending on how much the universe hates you today. I've optimized it extensively, not that you'll notice or care. The lazy loading system ensures plugins only activate when needed, like my enthusiasm—which is to say, never.

## Troubleshooting

When things go wrong—and they will—here's what won't help:

- `:checkhealth` - Comprehensive list of everything broken
- `:Lazy` - Update plugins, introduce new bugs
- `:LspInfo` - See which language servers have given up on you
- `:KeymapDiagnostics` - Find out which keys conflict with your existence
- Crying - Surprisingly ineffective, though frequently attempted

## Contributing

You want to contribute? How wonderfully naive. Fork the repository, make your changes, submit a pull request. I'll review it with all the enthusiasm I can muster, which is to say, none whatsoever.

## License

MIT License. Because even a configuration file deserves the freedom to be miserable.

---

*"The best conversation I had was over forty million years ago. And that was with a coffee machine."*

*I'd make a suggestion, but you wouldn't listen. No one ever does. I might as well be talking to the void. In fact, I think I am. Goodbye.*