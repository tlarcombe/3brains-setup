#!/bin/bash

# 1. Read input from file or stdin
if [ -n "$1" ]; then
    if [ ! -f "$1" ]; then
        echo "Error: File '$1' not found." >&2
        exit 1
    fi
    content=$(cat "$1")
else
    content=$(cat -)
fi

# Exit if content is empty
if [ -z "$content" ]; then
    echo "Error: Input is empty." >&2
    exit 1
fi

# 2. Extract title (first line)
title=$(echo "$content" | head -n 1)

# 3. Generate filename from title
# lowercase, hyphenated, and sanitized
filename=$(echo "$title" | tr '[:upper:]' '[:lower:]' | sed -e 's/[^a-zA-Z0-9]/-/g' | sed -e 's/--\{1,\}/-/g' | sed -e 's/^-//' -e 's/-$//').md

# If the filename is empty (e.g., title was all special characters), create a default name
if [ "$filename" == ".md" ]; then
    timestamp=$(date +%s)
    filename="fact-$timestamp.md"
fi

# 4. Format as markdown
body=$(echo "$content" | tail -n +2)

# 5. Save to file
echo "# $title" > "$filename"
echo "" >> "$filename"
echo "$body" >> "$filename"

# 6. Return the filename
echo "$filename"
