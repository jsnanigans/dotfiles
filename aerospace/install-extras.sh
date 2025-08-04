#!/bin/bash
# Install AeroSpace extras

echo "🚀 Installing AeroSpace extras..."

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew not found. Please install Homebrew first."
    exit 1
fi

# Install JankyBorders for window highlighting
echo "📦 Installing JankyBorders..."
brew tap FelixKratz/formulae
brew install borders

# Install jq for JSON processing (needed for scripts)
echo "📦 Installing jq..."
brew install jq

# Install Sketchybar (optional)
read -p "Install Sketchybar for custom status bar? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "📦 Installing Sketchybar..."
    brew tap FelixKratz/formulae
    brew install sketchybar
    
    # Create basic Sketchybar config
    mkdir -p ~/.config/sketchybar
    cat > ~/.config/sketchybar/sketchybarrc << 'EOF'
#!/bin/bash

# Rose Pine colors
BG=0xff191724
FG=0xffe0def4
ACCENT=0xffc4a7e7

# Bar appearance
sketchybar --bar height=32 \
                 blur_radius=0 \
                 position=top \
                 padding_left=10 \
                 padding_right=10 \
                 color=$BG

# Workspace display
for i in {1..10}; do
    sketchybar --add item workspace.$i left \
               --set workspace.$i script="~/.config/sketchybar/plugins/aerospace.sh $i" \
                                 icon=$i \
                                 label.drawing=off \
                                 icon.color=$FG \
                                 icon.highlight_color=$ACCENT \
                                 click_script="aerospace workspace $i"
done

# Subscribe to workspace changes
sketchybar --subscribe workspace.* aerospace_workspace_change

# Clock
sketchybar --add item clock right \
           --set clock update_freq=10 \
                      script="echo \$(date '+%H:%M')" \
                      icon.drawing=off \
                      label.color=$FG

sketchybar --update
EOF
    
    # Create AeroSpace plugin for Sketchybar
    mkdir -p ~/.config/sketchybar/plugins
    cat > ~/.config/sketchybar/plugins/aerospace.sh << 'EOF'
#!/bin/bash

WORKSPACE=$1

if [[ $FOCUSED_WORKSPACE == $WORKSPACE ]]; then
    sketchybar --set workspace.$WORKSPACE icon.highlight=on
else
    sketchybar --set workspace.$WORKSPACE icon.highlight=off
fi
EOF
    
    chmod +x ~/.config/sketchybar/sketchybarrc
    chmod +x ~/.config/sketchybar/plugins/aerospace.sh
    
    echo "✅ Sketchybar installed and configured"
fi

# Install Raycast extension
echo "📦 For Raycast integration, install the AeroSpace extension from:"
echo "   https://www.raycast.com/limonkufu/aerospace"

# Create launch agents directory if it doesn't exist
mkdir -p ~/Library/LaunchAgents

# Set up JankyBorders launch agent
cat > ~/Library/LaunchAgents/com.felixkratz.borders.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.felixkratz.borders</string>
    <key>ProgramArguments</key>
    <array>
        <string>/opt/homebrew/bin/borders</string>
        <string>active_color=0xffe1e3e4</string>
        <string>inactive_color=0xff6e6a86</string>
        <string>width=2.0</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
</dict>
</plist>
EOF

echo "✅ JankyBorders launch agent created"

# Symlink enhanced config
if [[ -f ~/dotfiles/aerospace-enhanced.toml ]]; then
    echo "🔗 Creating symlink for enhanced config..."
    ln -sf ~/dotfiles/aerospace-enhanced.toml ~/.aerospace-enhanced.toml
    echo "   To use enhanced config: cp ~/.aerospace-enhanced.toml ~/.aerospace.toml"
fi

echo ""
echo "✅ Installation complete!"
echo ""
echo "Next steps:"
echo "1. Start JankyBorders: launchctl load ~/Library/LaunchAgents/com.felixkratz.borders.plist"
echo "2. Reload AeroSpace: aerospace reload-config"
echo "3. Try the new fish functions: aero help"
echo ""
echo "Optional:"
echo "- Install Raycast AeroSpace extension for GUI control"
echo "- Set up Sketchybar: brew services start sketchybar"