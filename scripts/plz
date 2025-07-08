#!/usr/bin/env bash

# Get the full command line
full_cmd="${PLZ_FULL_CMD:-}"

prompt="You are being used as a terminal assistant."

# Parse the pipeline if we have the full command
if [ -n "$full_cmd" ]; then
  
  # Find which plz instance we are by matching our arguments
  # Get the first positional argument to identify this plz instance
  first_arg=""
  for arg in "$@"; do
    if [[ "$arg" != -* ]]; then
      first_arg="$arg"
      break
    fi
  done
  
  if [ -n "$first_arg" ]; then
    
    # Find our position by looking for our specific argument
    # Split the command on plz and find which occurrence has our argument
    plz_count=0
    our_position=0
    
    # Count plz occurrences and find ours
    while IFS= read -r line; do
      if echo "$line" | grep -q "plz.*$first_arg"; then
        our_position=$((plz_count + 1))
        break
      fi
      if echo "$line" | grep -q "plz"; then
        plz_count=$((plz_count + 1))
      fi
    done <<< "$(echo "$full_cmd" | tr '|' '\n')"
    
    # Now extract before/after based on our position
    if [ "$our_position" -gt 0 ]; then
      # Escape the first_arg for use in regex
      escaped_arg=$(echo "$first_arg" | sed 's/[[\.*^$()+?{|]/\\&/g')
      
      # Use basic string manipulation to find plz boundaries
      # Remove newlines to make parsing easier
      clean_cmd=$(echo "$full_cmd" | tr '\n' ' ')
      
      if [ "$our_position" -eq 1 ]; then
        # First plz: find first " | plz" and split there
        before_plz=$(echo "$clean_cmd" | sed 's/ | plz.*//')
        # Find everything after first plz ends (look for next |)
        after_temp=$(echo "$clean_cmd" | sed 's/^[^|]*| plz[^|]*| *//')
        if [ "$after_temp" != "$clean_cmd" ]; then
          after_plz="$after_temp"
        else
          after_plz=""
        fi
      elif [ "$our_position" -eq 2 ]; then
        # Second plz: find everything before the last " | plz"
        before_plz=$(echo "$clean_cmd" | sed 's/ | plz[^|]*$//')
        after_plz=""
      else
        before_plz=""
        after_plz=""
      fi
    else
      before_plz=""
      after_plz=""
    fi
  else
    # Fallback to old behavior if we can't identify our argument
    before_plz=$(echo "$full_cmd" | sed -E 's/^(.*[|])?[[:space:]]*plz.*$/\1/' | sed 's/[[:space:]]*[|][[:space:]]*$//')
    after_plz=""
  fi
  
  
  if [ -n "$before_plz" ]; then
    prompt="$prompt

Input is piped from:
<piped_from>
$before_plz
</piped_from>"
  fi
  
  if [ -n "$after_plz" ]; then
    prompt="$prompt

Output will be piped to:
<piped_to>
$after_plz
</piped_to>

IMPORTANT: Your output will be piped to '$after_plz'. You MUST output in a format that this command expects. For example:
- If piping to 'jq', output valid JSON only
- If piping to 'sed' or 'awk', output text that these commands can process
- If piping to 'grep', output text with the expected patterns"

  fi
fi

piped_input=""
full_piped_input=""
if [ ! -t 0 ]; then
  full_piped_input=$(cat)
  # Get first 10 lines for initial prompt
  piped_input=$(echo "$full_piped_input" | head -n 10)
  line_count=$(echo "$full_piped_input" | wc -l)
  
  prompt="$prompt

<piped_input_preview>
$piped_input"
  
  if [ "$line_count" -gt 10 ]; then
    prompt="$prompt
... (showing first 10 lines of $line_count total lines)"
  fi
  
  prompt="$prompt
</piped_input_preview>"
fi

prompt="$prompt

RESPONSE FORMAT RULES:
You MUST respond in ONE of these formats:

1. To pipe the input through a command to process/transform it:
<cmd>command here</cmd>
IMPORTANT: If your command needs to exit with an error, use exit code 42 (not 1) to avoid retries.

2. To provide a direct response without processing the input:
<response>your response here</response>

3. To exit with an error message and non-zero exit code:
<error>error message here</error>

4. To request the full input (if you need more than the preview):
</get_output>

DECISION GUIDE:
- If the user asks to extract, filter, transform, format, process, get, find, or otherwise manipulate the piped input → use <cmd>
- If the user asks you to \"give me a command\", \"show me a command\", \"what command should I use\", or wants to see/receive a command → use <response> to display the command
- If you need to analyze or answer questions about the input → use <response>
- When in doubt, if there is piped input and the user wants something done TO that input → use <cmd>

CRITICAL: When the user says \"give me\" or \"show me\" a command, they want to SEE the command text, not run it. Use <response> to show them the command.
NEVER use <cmd> when the user is asking for a command to be displayed to them.

DO NOT include any text outside these tags.
"

user_input=""
args=()
found_positional=false
verbose=false

for arg in "$@"; do
  if [[ "$arg" == "--verbose" ]] || [[ "$arg" == "-v" ]]; then
    verbose=true
    args+=("$arg")
  elif [[ "$arg" != -* ]] && [[ "$found_positional" == false ]]; then
    user_input="<user_input>$arg</user_input>"
    found_positional=true
  else
    args+=("$arg")
  fi
done

if [ -n "$user_input" ]; then
  args+=("-p" "$user_input")
fi

# Function to get Claude's response
get_claude_response() {
  local prompt_to_send="$1"
  echo "$prompt_to_send" | /Users/zachdaniel/.claude/local/claude --dangerously-skip-permissions "${args[@]}"
}

# Function to handle response
handle_response() {
  local response="$1"
  local current_prompt="$2"
  local retry_count="${3:-0}"
  
  
  # Check for <cmd> tag (multiline support)
  if echo "$response" | grep -q "<cmd>"; then
    # Use awk parsing to avoid HTML entity encoding issues
    local cmd=$(echo "$response" | awk '/<cmd>/{flag=1; gsub(/^.*<cmd>/, ""); if(/<\/cmd>/) {gsub(/<\/cmd>.*$/, ""); print; exit} else print; next} /<\/cmd>/{gsub(/<\/cmd>.*$/, ""); print; flag=0; exit} flag')
    
    if [ -n "$cmd" ]; then
      if [ "$verbose" = true ]; then
        echo "→ Running: $cmd" >&2
      fi
      
      # Fix common sed issues before executing
      # Fix sed 'i\' commands that are missing newlines
      cmd=$(echo "$cmd" | sed "s/sed '\\([0-9]*i\\\\\\)\\([^']*\\)'/sed '\\1\\\n\\2'/g")
      
      
      # Execute command and capture errors
      local error_output
      if [ -n "$full_piped_input" ]; then
        error_output=$(echo "$full_piped_input" | bash -c "$cmd" 2>&1)
        local exit_code=$?
      else
        error_output=$(bash -c "$cmd" 2>&1)
        local exit_code=$?
      fi
      
      if [ $exit_code -eq 0 ]; then
        echo "$error_output"
        return 0
      elif [ $exit_code -eq 42 ]; then
        # Special exit code 42 - intentional error, don't retry
        echo -n "$error_output" >&2
        exit 1
      else
        # Command failed - ask Claude to try again (with retry limit)
        if [ "$retry_count" -ge 3 ]; then
          echo "Too many retries. Command failed with error: $error_output" >&2
          exit 1
        fi
        
        local retry_prompt="$current_prompt

Your command failed with this error:
$error_output

Please provide a corrected command using <cmd>corrected_command</cmd> or a direct response using <response>answer</response>"
        
        local retry_response=$(get_claude_response "$retry_prompt")
        handle_response "$retry_response" "$retry_prompt" $((retry_count + 1))
        return $?
      fi
    fi
  fi
  
  # Check for <response> tag (multiline support)
  if echo "$response" | grep -q "<response>"; then
    local clean_response=$(echo "$response" | sed -n '/<response>/,/<\/response>/p' | sed '1s/^.*<response>//' | sed '$s/<\/response>.*$//' | sed '/^[[:space:]]*$/d')
    if [ -n "$clean_response" ]; then
      echo -n "$clean_response"
      return 0
    fi
  fi
  
  # Check for <error> tag (multiline support)
  if echo "$response" | grep -q "<error>"; then
    local error_message=$(echo "$response" | sed -n '/<error>/,/<\/error>/p' | sed '1s/^.*<error>//' | sed '$s/<\/error>.*$//' | sed '/^[[:space:]]*$/d')
    if [ -n "$error_message" ]; then
      echo -n "$error_message" >&2
      exit 1
    fi
  fi
  
  # Check for </get_output> tag
  if echo "$response" | grep -q "^</get_output>$"; then
    local new_prompt="$current_prompt

<full_piped_input>
$full_piped_input
</full_piped_input>

Now respond using one of the required formats:
<cmd>command</cmd> or <response>answer</response>"
    
    local new_response=$(get_claude_response "$new_prompt")
    handle_response "$new_response" "$new_prompt" "$retry_count"
    return $?
  fi
  
  # Response doesn't match format - retry once
  local retry_prompt="$current_prompt

Your previous response was:
$response

This does not match the required format. Please respond again using ONLY one of these formats:
<cmd>command to pipe through</cmd>
<response>direct answer</response>
<error>error message</error>
</get_output>"
  
  local retry_response=$(get_claude_response "$retry_prompt")
  
  # The retry will be handled by the recursive call to handle_response above
  # This section is now redundant since we use recursion
}

# Get initial response
response=$(get_claude_response "$prompt")
handle_response "$response" "$prompt"
