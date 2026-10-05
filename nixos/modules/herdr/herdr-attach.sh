agents=$(herdr agent list)

rows=$(
  jq -r '
    .result.agents[]?
    | [
        .pane_id,
        (.agent_status // "unknown"),
        (.name // .agent // "unknown"),
        (.foreground_cwd // .cwd // "-")
      ]
    | @tsv
  ' <<<"$agents"
)

if [[ -z "$rows" ]]; then
  echo "No active Herdr agents found." >&2
  exit 1
fi

if ! selected=$(
  printf '%s\n' "$rows" |
    fzf \
      --height=80% \
      --layout=reverse \
      --border \
      --no-multi \
      --delimiter=$'\t' \
      --prompt='Herdr agent> ' \
      --header=$'PANE\tSTATUS\tAGENT\tWORKING DIRECTORY'
); then
  exit 0
fi

pane_id=${selected%%$'\t'*}
exec herdr agent attach "$pane_id"
