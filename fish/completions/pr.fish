# Completion for pr (pnpm run alias)
# Disable file completions and only show package.json scripts
complete -c pr -f -a "(__fish_npm_scripts)" -d "pnpm script"