#!/bin/bash

# setup-gemini-hook.sh
# Installs a Git post-commit hook to automate the GEMINI.md protocol.

HOOK_DIR=".git/hooks"
HOOK_FILE="$HOOK_DIR/post-commit"

echo "🏗️ Setting up GEMINI.md automation..."

# Create hooks directory if it doesn't exist
mkdir -p "$HOOK_DIR"

# Create the post-commit hook
cat << 'EOF' > "$HOOK_FILE"
#!/bin/bash

# Automate GEMINI.md updates
# This script extracts the latest commit and prepends it to the context file.

CONTEXT_FILE="GEMINI.md"

if [ -f "$CONTEXT_FILE" ]; then
    LAST_COMMIT=$(git log -1 --pretty=format:"- **%as**: %s (%h)")
    
    # Use a temporary file to update the section
    # On macOS, sed -i requires an empty string for the backup extension
    sed -i '' "/<!-- AUTOMATED_SECTION_START -->/a\\
$LAST_COMMIT" "$CONTEXT_FILE"
    
    # Optional: Keep only the last 10 log entries (omitted for simplicity in this basic hook)
fi
EOF

# Make the hook executable
chmod +x "$HOOK_FILE"

echo "✅ Git hook installed successfully."
echo "💡 From now on, every 'git commit' will automatically update your GEMINI.md file."
