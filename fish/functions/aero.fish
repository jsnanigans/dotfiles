# AeroSpace helper functions

function aero --description "AeroSpace helper commands"
    set -l cmd $argv[1]
    set -l args $argv[2..-1]
    
    switch $cmd
        case layout l
            # Quick layout presets
            ~/dotfiles/aerospace/scripts/layout-preset.sh $args
            
        case pick p
            # Window picker
            ~/dotfiles/aerospace/scripts/window-picker.sh
            
        case ws workspace
            # Interactive workspace switcher
            ~/dotfiles/aerospace/scripts/workspace-switcher.sh
            
        case list ls
            # Workspace overview
            aerospace list-workspaces --monitor all --empty no | \
                while read -l ws
                    echo "=== Workspace $ws ==="
                    aerospace list-windows --workspace $ws --format '%{app-name} - %{window-title}'
                    echo ""
                end
                
        case focus f
            # Smart focus by app name
            set -l app $args[1]
            set -l window_id (aerospace list-windows --all --format '%{window-id} %{app-name}' | \
                grep -i $app | head -1 | cut -d' ' -f1)
            if test -n "$window_id"
                aerospace focus --window-id $window_id
            else
                echo "No window found for app: $app"
            end
            
        case move m
            # Move current window to workspace
            aerospace move-node-to-workspace $args
            
        case reload r
            # Reload config
            aerospace reload-config
            echo "AeroSpace config reloaded"
            
        case gaps g
            # Toggle gaps on/off
            set -l current (aerospace config get gaps.inner.horizontal)
            if test "$current" = "0"
                # Turn gaps on
                sed -i '' 's/inner.horizontal = 0/inner.horizontal = 8/' ~/.aerospace.toml
                sed -i '' 's/inner.vertical = 0/inner.vertical = 8/' ~/.aerospace.toml
                sed -i '' 's/outer.left = 0/outer.left = 8/' ~/.aerospace.toml
                sed -i '' 's/outer.bottom = 0/outer.bottom = 8/' ~/.aerospace.toml
                sed -i '' 's/outer.top = 0/outer.top = 8/' ~/.aerospace.toml
                sed -i '' 's/outer.right = 0/outer.right = 8/' ~/.aerospace.toml
                echo "Gaps enabled"
            else
                # Turn gaps off
                sed -i '' 's/inner.horizontal = 8/inner.horizontal = 0/' ~/.aerospace.toml
                sed -i '' 's/inner.vertical = 8/inner.vertical = 0/' ~/.aerospace.toml
                sed -i '' 's/outer.left = 8/outer.left = 0/' ~/.aerospace.toml
                sed -i '' 's/outer.bottom = 8/outer.bottom = 0/' ~/.aerospace.toml
                sed -i '' 's/outer.top = 8/outer.top = 0/' ~/.aerospace.toml
                sed -i '' 's/outer.right = 8/outer.right = 0/' ~/.aerospace.toml
                echo "Gaps disabled"
            end
            aerospace reload-config
            
        case help h '*'
            echo "AeroSpace helper commands:"
            echo "  aero layout [preset]  - Apply layout preset (dev/web/comm/focus)"
            echo "  aero pick            - Interactive window picker"
            echo "  aero ws              - Interactive workspace switcher"
            echo "  aero list            - Show workspace overview"
            echo "  aero focus [app]     - Focus window by app name"
            echo "  aero move [ws]       - Move current window to workspace"
            echo "  aero reload          - Reload config"
            echo "  aero gaps            - Toggle gaps on/off"
    end
end