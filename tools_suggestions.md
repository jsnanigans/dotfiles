# Modern CLI Tools Suggestions

A curated list of modern command-line tools that can significantly improve your development workflow.

## File & Code Search

### ripgrep (`rg`)
- **Repository**: https://github.com/BurntSushi/ripgrep
- **Description**: Blazing fast grep alternative
- **Install**: `brew install ripgrep`
- **Usage**: `rg "pattern" --type js`

### fd
- **Repository**: https://github.com/sharkdp/fd
- **Description**: Simple, fast alternative to `find` (from the `bat` author)
- **Install**: `brew install fd`
- **Usage**: `fd "*.js" --type f`

### fzf
- **Repository**: https://github.com/junegunn/fzf
- **Description**: Fuzzy finder for everything
- **Install**: `brew install fzf`
- **Usage**: `ctrl+r` for history, `**<tab>` for files

## File Management & Navigation

### zoxide (`z`)
- **Repository**: https://github.com/ajeetdsouza/zoxide
- **Description**: Smarter `cd` that learns your habits
- **Install**: `brew install zoxide`
- **Usage**: `z project` jumps to most frecent matching directory

### broot
- **Repository**: https://github.com/Canop/broot
- **Description**: Interactive tree view with search and navigation
- **Install**: `brew install broot`
- **Usage**: `br` to launch interactive explorer

### yazi
- **Repository**: https://github.com/sxyazi/yazi
- **Description**: Blazing fast terminal file manager
- **Install**: `brew install yazi`
- **Usage**: `yazi` to launch file manager

## System Monitoring

### btop
- **Repository**: https://github.com/aristocratos/btop
- **Description**: Beautiful alternative to `top`/`htop`
- **Install**: `brew install btop`
- **Usage**: `btop` for system monitoring

### dust
- **Repository**: https://github.com/bootandy/dust
- **Description**: More intuitive `du` for disk usage
- **Install**: `brew install dust`
- **Usage**: `dust` to see disk usage

### procs
- **Repository**: https://github.com/dalance/procs
- **Description**: Modern `ps` replacement
- **Install**: `brew install procs`
- **Usage**: `procs` to list processes

## Git Enhancements

### lazygit
- **Repository**: https://github.com/jesseduffield/lazygit
- **Description**: Terminal UI for git
- **Install**: `brew install lazygit`
- **Usage**: `lazygit` in any git repository

### delta
- **Repository**: https://github.com/dandavison/delta
- **Description**: Better git diff viewer
- **Install**: `brew install git-delta`
- **Configuration**: Add to `.gitconfig`:
  ```ini
  [core]
      pager = delta
  [delta]
      navigate = true
      light = false
      side-by-side = true
  ```

### gitui
- **Repository**: https://github.com/extrawurst/gitui
- **Description**: Fast git TUI written in Rust
- **Install**: `brew install gitui`
- **Usage**: `gitui` in any git repository

## Development Tools

### httpie
- **Repository**: https://github.com/httpie/cli
- **Description**: Human-friendly `curl` alternative
- **Install**: `brew install httpie`
- **Usage**: `http GET api.example.com/users`

### jq
- **Repository**: https://github.com/jqlang/jq
- **Description**: JSON processor (essential!)
- **Install**: `brew install jq`
- **Usage**: `curl api.example.com | jq '.data[]'`

### fx
- **Repository**: https://github.com/antonmedv/fx
- **Description**: Interactive JSON viewer
- **Install**: `brew install fx`
- **Usage**: `curl api.example.com | fx`

### hyperfine
- **Repository**: https://github.com/sharkdp/hyperfine
- **Description**: Command-line benchmarking tool
- **Install**: `brew install hyperfine`
- **Usage**: `hyperfine 'command1' 'command2'`

## Text Processing

### sd
- **Repository**: https://github.com/chmln/sd
- **Description**: Intuitive find-and-replace, simpler than `sed`
- **Install**: `brew install sd`
- **Usage**: `sd 'before' 'after' file.txt`

### choose
- **Repository**: https://github.com/theryangeary/choose
- **Description**: Human-friendly `cut`/`awk`
- **Install**: `brew install choose`
- **Usage**: `ps | choose 1 3` (select columns 1 and 3)

### glow
- **Repository**: https://github.com/charmbracelet/glow
- **Description**: Render markdown in terminal
- **Install**: `brew install glow`
- **Usage**: `glow README.md`

## Shell Enhancements

### atuin
- **Repository**: https://github.com/atuinsh/atuin
- **Description**: Magical shell history with sync
- **Install**: `brew install atuin`
- **Usage**: Replaces ctrl+r with powerful history search

### starship
- **Repository**: https://github.com/starship/starship
- **Description**: Fast, customizable prompt
- **Install**: `brew install starship`
- **Configuration**: Add to `~/.config/fish/config.fish`:
  ```fish
  starship init fish | source
  ```

### direnv
- **Repository**: https://github.com/direnv/direnv
- **Description**: Per-directory environment variables
- **Install**: `brew install direnv`
- **Usage**: Create `.envrc` files in project directories

## File Preview & Viewing

### hexyl
- **Repository**: https://github.com/sharkdp/hexyl
- **Description**: Hex viewer with colors
- **Install**: `brew install hexyl`
- **Usage**: `hexyl binary_file`

### tokei
- **Repository**: https://github.com/XAMPPRocky/tokei
- **Description**: Fast code statistics
- **Install**: `brew install tokei`
- **Usage**: `tokei` in project directory

## Already Configured

These tools are already set up in your dotfiles:
- **eza** - Modern replacement for `ls`
- **bat** - Cat clone with syntax highlighting
- **ripgrep** - Fast grep alternative
- **delta** - Git diff viewer
- **fzf** - Fuzzy finder

## Priority Recommendations

Based on immediate impact, prioritize installing:

1. **zoxide** - Makes navigation incredibly fast
2. **fd** - Complements ripgrep for file finding
3. **lazygit** or **gitui** - Transforms git workflow
4. **jq** - Essential for any JSON work
5. **btop** - Beautiful system monitoring

## Installation

Most tools can be installed via Homebrew:
```bash
brew install zoxide fd lazygit jq btop
```

## Fish Shell Integration

Many of these tools have Fish shell completions available. After installation, run:
```fish
fish_update_completions
```