# ==========================
# Dump command for Zsh
# ==========================
# Usage:
#   dump file1 file2
#   dump -c file1
#   dump --to images img1.png
#   dump -c -t images img1.png
#
# Environment:
#   DUMP_DIR   Base directory for dumped files
# ==========================

# ---- helpers --------------------------------------------------------------

_dump_error() {
  print -u2 "dump: $1"
  return 1
}

_dump_ensure_dir() {
  local dir="$1"

  if [[ ! -d "$dir" ]]; then
    mkdir -p "$dir" || _dump_error "failed to create directory: $dir"
  fi
}

# ---- main command ---------------------------------------------------------

dump() {
  # ---- config ----
  local dump_base="${DUMP_DIR:-}"

  if [[ -z "$dump_base" ]]; then
    _dump_error "DUMP_DIR is not set"
    return 1
  fi

  # ---- defaults ----
  local mode="move"
  local subdir=""
  local -a files=()

  # ---- argument parsing ----
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -c|--copy)
        mode="copy"
        shift
        ;;
      -t|--to)
        if [[ -z "$2" ]]; then
          _dump_error "--to requires a directory name"
          return 1
        fi
        subdir="$2"
        shift 2
        ;;
      --)
        shift
        break
        ;;
      -*)
        _dump_error "unknown option: $1"
        return 1
        ;;
      *)
        files+=("$1")
        shift
        ;;
    esac
  done

  # ---- validation ----
  if (( ${#files[@]} == 0 )); then
    _dump_error "no files specified"
    return 1
  fi

  # ---- target directory ----
  local target_dir="$dump_base"

  if [[ -n "$subdir" ]]; then
    target_dir="$dump_base/$subdir"
  fi

  _dump_ensure_dir "$target_dir" || return 1

  # ---- operation ----
  local f
  for f in "${files[@]}"; do
    if [[ ! -e "$f" ]]; then
      _dump_error "file not found: $f"
      continue
    fi

    if [[ "$mode" == "copy" ]]; then
      cp -R "$f" "$target_dir/"
    else
      mv "$f" "$target_dir/"
    fi
  done
}

