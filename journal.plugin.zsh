# storage 
: ${ZSH_JOURNAL_FILE:="$HOME/.zsh-journal.txt"}
: ${ZSH_JOURNAL_LAST_CMD_FILE:="$HOME/.zsh-journal-lastcmd.tmp"}

# capture last executed command
function _zsh_command_notes_capture_history() {
  local cmd="$1"
  
  # ignore note* commands
  if [[ "$cmd" != note* && "$cmd" != notes* ]]; then
    echo "$cmd" > "$ZSH_JOURNAL_LAST_CMD_FILE"
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook zshaddhistory _zsh_command_notes_capture_history

# add note
function note() {
  local last_cmd note_text entry existing temp_file

  if [[ -z "$1" ]]; then
    echo "Usage: note \"your comment here\""
    return 1
  fi

  if [[ ! -f "$ZSH_JOURNAL_LAST_CMD_FILE" ]]; then
    echo "No previous command captured."
    return 1
  fi

  last_cmd="$(<"$ZSH_JOURNAL_LAST_CMD_FILE" | sed 's/[[:space:]]*$//')"
  note_text="$*"
  entry="$last_cmd # $note_text"

  touch "$ZSH_JOURNAL_FILE"

  existing=$(awk -F'#' -v cmd="$last_cmd" '
    {
      gsub(/^[ \t]+|[ \t]+$/, "", $1)
      if ($1 == cmd) {
        print $0
        exit
      }
    }
  ' "$ZSH_JOURNAL_FILE")

  # prevent duplicate commands
  if [[ -n "$existing" ]]; then
    echo "A note already exists for this command:"
    echo "→ ${existing#*# }"
    echo -n "Overwrite it? [y/N]: "
    read -r response
    if [[ "$response" != "y" ]]; then
      echo "Note not changed."
      return 0
    fi

    temp_file=$(mktemp)
    awk -F'#' -v cmd="$last_cmd" '
      {
        gsub(/^[ \t]+|[ \t]+$/, "", $1)
        if ($1 != cmd) print $0
      }
    ' "$ZSH_JOURNAL_FILE" > "$temp_file"
    mv "$temp_file" "$ZSH_JOURNAL_FILE"
  fi

  echo "$entry" >> "$ZSH_JOURNAL_FILE"
  echo "Note saved for: $last_cmd"
}

# list commands
function notes() {
  if [[ ! -f "$ZSH_JOURNAL_FILE" ]]; then
    echo "No notes found."
    return 1
  fi

  awk -F '#' '
    {
      cmd = $1
      gsub(/^[ \t]+|[ \t]+$/, "", cmd)
      note = $2
      gsub(/^[ \t]+|[ \t]+$/, "", note)
      printf("[%d] %s\n    → %s\n\n", NR, cmd, note)
    }
  ' "$ZSH_JOURNAL_FILE"
}

