#!/bin/bash

# Help message
show_help() {
    echo "Usage: $0 TEXT/FILEPATH [-F|--file=true] encoding"
    echo "Encodes the provided text or contents of a file in the specified encoding type."
    echo
    echo "Arguments:"
    echo "  TEXT/FILEPATH      The text to encode or the path to a file."
    echo "  -F, --file=true    Treat the input as a file path."
    echo "  encoding           The encoding type (html, url, base64, hex, js)."
    echo
    echo "Example:"
    echo "  $0 '<script>' html"
    echo "  $0 /path/to/file.txt --file=true base64"
}

# Check for the correct number of arguments
if [[ $# -lt 2 || $# -gt 3 ]]; then
    show_help
    exit 1
fi

# Parse arguments
INPUT=$1
IS_FILE=false
ENCODING=${@: -1}

if [[ $2 == "-F" || $2 == "--file=true" ]]; then
    IS_FILE=true
fi

# Function to encode
encode() {
    local text="$1"
    local encoding="$2"
    case "$encoding" in
        html)
            echo "$text" | python3 -c "import html; print(html.escape(input()))"
            ;;
        url)
            echo "$text" | python3 -c "import urllib.parse; print(urllib.parse.quote(input()))"
            ;;
        base64)
            echo "$text" | python3 -c "import base64, sys; print(base64.b64encode(input().encode()).decode())"
            ;;
        hex)
            echo "$text" | python3 -c "import sys; print(''.join('%{:02X}'.format(ord(c)) for c in input()))"
            ;;
        js)
            echo "$text" | python3 -c "print(''.join(f'\\\\x{{ord(c):02x}}' for c in input()))"
            ;;
        *)
            echo "Invalid encoding type. Supported types: html, url, base64, hex, js."
            exit 1
            ;;
    esac
}

# Handle input
if $IS_FILE; then
    if [[ -f "$INPUT" ]]; then
        CONTENT=$(cat "$INPUT")
    else
        echo "Error: File '$INPUT' does not exist."
        exit 1
    fi
else
    CONTENT="$INPUT"
fi

# Safely pass content to encoder
CONTENT=$(echo "$CONTENT" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e "s/'/\\'/g")
encode "$CONTENT" "$ENCODING"
