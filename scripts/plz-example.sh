#!/bin/bash

echo "Example 1: Simple JSON extraction"
echo '{"users": [{"name": "Alice", "age": 30}, {"name": "Bob", "age": 25}]}' | plz "extract just the names"

echo -e "\n\nExample 2: Pipeline-aware transformation"
echo "The assistant should notice it needs to output valid JSON for jq:"
curl -s https://api.github.com/users/zachdaniel | plz "get just username and location" | jq .

echo -e "\n\nExample 3: Getting vs Running commands"
echo "When you ask FOR a command, plz shows it to you:"
ls -la | plz "give me an awk command to extract filenames"
echo
echo "When you ask to DO something, plz runs the command:"
ls -la | plz "extract the filenames using awk"

