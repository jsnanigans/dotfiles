# Completion for nr (npm run alias)
# Disable file completions and only show package.json scripts
complete -c nr -f -a "(__fish_npm_scripts)" -d "npm script"