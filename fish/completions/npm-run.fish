# Completion for npm run and pnpm run commands

# Complete npm run with available scripts
complete -c npm -n "__fish_seen_subcommand_from run" -a "(__fish_npm_scripts)" -d "npm script"

# Complete pnpm run with available scripts  
complete -c pnpm -n "__fish_seen_subcommand_from run" -a "(__fish_npm_scripts)" -d "pnpm script"

# Add completion for run subcommand if not already present
complete -c npm -n "not __fish_seen_subcommand_from run" -a "run" -d "Run npm script"
complete -c pnpm -n "not __fish_seen_subcommand_from run" -a "run" -d "Run pnpm script"