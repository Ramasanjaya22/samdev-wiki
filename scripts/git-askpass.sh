#!/bin/bash
# Git askpass helper script
# Returns the token when git prompts for password

# Read token from secure location
TOKEN_FILE="/root/.secrets/github_token"

if [ -f "$TOKEN_FILE" ]; then
    cat "$TOKEN_FILE"
else
    echo ""
fi