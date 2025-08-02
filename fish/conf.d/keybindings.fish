# Custom key bindings for Fish

# For Ghostty terminal - bind Shift+Enter to insert newline
bind \e\[27\;2\;13~ 'commandline -i \n'

# Alt+Enter as alternative (more universally supported)
bind \e\r 'commandline -i \n'
bind \e\n 'commandline -i \n'

# Debug: Show what key sequence is being sent (remove after testing)
# bind \e\[27\;2\;13~ 'echo "Shift+Enter detected"; commandline -i \n'