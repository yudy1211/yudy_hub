#!/bin/bash
# Auto-commit and push to main after file writes/edits

REPO="/home/user/yudy_hub"

# Extract file path from hook JSON stdin
FILE=$(jq -r '.tool_input.file_path // empty')

# Skip if no file path
if [ -z "$FILE" ] || [ "$FILE" = "null" ]; then
    exit 0
fi

# Skip if file is not in our repo
if [[ "$FILE" != "$REPO"* ]]; then
    exit 0
fi

cd "$REPO"

# Stage the changed file
git add "$FILE"

# Skip if nothing to commit
if git diff --cached --quiet; then
    exit 0
fi

# Commit with filename and timestamp
BASENAME=$(basename "$FILE")
git commit -m "${BASENAME}を更新"

# Push to main
git push -u origin main
