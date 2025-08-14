function tm --description "Tmux session manager (legacy wrapper for 'session' command)"
    # This is a compatibility wrapper for the new unified session manager
    # Redirects to the 'session' command with appropriate arguments
    
    source $DOTFILES/fish/functions/session.fish
    
    # If no arguments, use session manager
    if test (count $argv) -eq 0
        session
        return
    end

    set cmd $argv[1]

    switch $cmd
        case new n
            session new $argv[2..-1]

        case kill k
            session kill $argv[2..-1]

        case list ls
            session list

        case attach a
            session attach $argv[2..-1]

        case switch s
            session switch $argv[2..-1]

        case help h '*'
            echo "Tmux session manager (Legacy)"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo ""
            echo "⚠️  This command is deprecated!"
            echo "Please use 'session' instead for the unified session manager."
            echo ""
            echo "Migration examples:"
            echo "  tm           → session"
            echo "  tm new       → session new"
            echo "  tm kill      → session kill"
            echo "  tm list      → session list"
            echo "  tm attach    → session attach"
            echo "  tm switch    → session switch"
            echo ""
            echo "New features in 'session':"
            echo "  session project    - Project-based sessions"
            echo "  session clone      - Clone sessions"
            echo "  session save       - Save layouts"
            echo "  session restore    - Restore layouts"
            echo ""
            echo "Run 'session help' for full documentation"
    end
end