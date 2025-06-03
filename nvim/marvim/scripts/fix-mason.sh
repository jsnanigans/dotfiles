#!/bin/bash

# Fix Mason installation errors by cleaning up symlinks
echo "Cleaning up Mason installation..."

# Remove problematic symlinks
MASON_DIR="$HOME/.local/share/lzvim/mason"

if [ -d "$MASON_DIR" ]; then
    echo "Removing Mason schema symlinks..."
    rm -rf "$MASON_DIR/share/mason-schemas"
    echo "Done. Mason should now be able to install packages properly."
else
    echo "Mason directory not found at $MASON_DIR"
    echo "Mason packages should install properly on next attempt."
fi