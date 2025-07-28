# Function to get available scripts from package.json
function __fish_npm_scripts
    # Check if package.json exists in current directory
    if test -f package.json
        # Parse scripts from package.json using jq if available, otherwise use a simple grep approach
        if command -q jq
            jq -r '.scripts | keys[]' package.json 2>/dev/null
        else
            # Fallback: simple grep approach (less reliable but works without jq)
            grep -o '"[^"]*"\s*:' package.json | grep -A1 '"scripts"' | grep -o '"[^"]*"' | tr -d '"' | tail -n +2
        end
    end
end