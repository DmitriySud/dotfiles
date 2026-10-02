# Run with Bash or Zsh, passing the packaged goto.sh as the first argument.
set -e

goto_script="$1"
test_root=$(mktemp -d)
trap 'rm -rf -- "$test_root"' EXIT
export GOTO_DB="$test_root/config/goto"
first_dir="$test_root/context-one"
second_dir="$test_root/context two"
mkdir -p "$test_root/config" "$test_root/state" "$test_root/outside" \
  "$first_dir/target" "$second_dir/target" "$test_root/unavailable"
touch "$test_root/state/db"
ln -s "$test_root/state/db" "$test_root/database-link"
ln -s "$test_root/database-link" "$GOTO_DB"

if [ -n "${ZSH_VERSION:-}" ]; then
  autoload -Uz compinit
  compinit -D
fi
source "$goto_script"

assert_equal() {
  if [ "$1" != "$2" ]; then
    printf 'Expected <%s>, got <%s>\n' "$2" "$1" >&2
    exit 1
  fi
}

expect_failure() {
  if "$@" >"$test_root/stdout" 2>"$test_root/stderr"; then
    printf 'Expected failure: %s\n' "$*" >&2
    exit 1
  fi
  [ -s "$test_root/stderr" ]
}

cd "$test_root/outside"
# Existing static entries retain their literal values in every context.
printf '%s\n' "fixed $first_dir/target" >> "$GOTO_DB"
assert_equal "$(goto --expand fixed)" "$first_dir/target"

expression='$(printf "%s" "$PWD")/target'
goto --register-dynamic dynamic "$expression"
assert_equal "$(goto -x dynamic)" "$test_root/outside/target"
expect_failure goto -R dynamic "$expression"
expect_failure goto -R invalid/alias "$expression"
expect_failure goto -R empty ''
expect_failure goto -R multiline $'one\ntwo'
expect_failure goto --expand unknown

for directory in "$first_dir" "$second_dir"; do
  cd "$directory"
  assert_equal "$(goto -x dynamic)" "$directory/target"
  assert_equal "$(goto -x fixed)" "$first_dir/target"
  goto dynamic
  assert_equal "$PWD" "$directory/target"
  cd "$directory"
  goto --push dynamic
  assert_equal "$PWD" "$directory/target"
  goto --pop
  assert_equal "$PWD" "$directory"
done

# Static bookmarks and direct directory navigation remain available.
goto -r pinned "$second_dir/target"
assert_equal "$(goto -x pinned)" "$second_dir/target"
goto -p fixed
assert_equal "$PWD" "$first_dir/target"
goto -o
assert_equal "$PWD" "$second_dir"
goto -p "$first_dir/target"
assert_equal "$PWD" "$first_dir/target"
goto -o
assert_equal "$PWD" "$second_dir"
goto "$first_dir/target"
assert_equal "$PWD" "$first_dir/target"

# Fallbacks are ordinary shell expressions supplied by the user.
goto -R fallback '$(false || printf "%s" "$first_dir")/target'
assert_equal "$(goto -x fallback)" "$first_dir/target"

# Missing dynamic targets fail without changing the directory or stack.
cd "$test_root/unavailable"
assert_equal "$(goto -x dynamic)" "$test_root/unavailable/target"
stack_before=$(dirs -p)
expect_failure goto dynamic
expect_failure goto -p dynamic
assert_equal "$PWD" "$test_root/unavailable"
assert_equal "$(dirs -p)" "$stack_before"

# Static paths are literal even when they contain shell-looking text.
literal="$test_root/"'literal $(touch marker) \n "$USER" space'
mkdir -p "$literal"
goto -r literal "$literal"
assert_equal "$(goto -x literal)" "$literal"
goto literal
assert_equal "$PWD" "$literal"
cd "$test_root/outside"

# Dynamic values preserve spaces, quotes, and backslashes in expanded variables.
dynamic_target="$test_root/"'dynamic "quote" \slash space'
mkdir -p "$dynamic_target"
goto -R variable '$dynamic_target'
goto variable
assert_equal "$PWD" "$dynamic_target"
cd "$test_root/outside"
dynamic_target="$first_dir/target"
assert_equal "$(goto -x variable)" "$first_dir/target"

goto -R failed '$(false)'
goto -R empty-result '$(printf "")'
goto -R multiple-results '$(printf "one\ntwo")'
goto -R invalid-syntax '$('
stack_before=$(dirs -p)
for name in failed empty-result multiple-results invalid-syntax; do
  expect_failure goto -x "$name"
  expect_failure goto "$name"
  expect_failure goto -p "$name"
  assert_equal "$PWD" "$test_root/outside"
  assert_equal "$(dirs -p)" "$stack_before"
done

# Nothing besides resolving the selected dynamic alias should run its code.
goto -R observed '$(touch "$test_root/evaluated"; printf "%s" "$first_dir/target")'
goto -l > "$test_root/listing"
grep -F -- '@dynamic:' "$test_root/listing" >/dev/null
if [ -n "${BASH_VERSION:-}" ]; then
  # Invoke the callback registered with Bash's public completion interface.
  completion_handler=$(complete -p goto | sed -n 's/.*-F \([^ ]*\).*/\1/p')
  COMP_WORDS=(goto '')
  COMP_CWORD=1
  COMPREPLY=()
  COLUMNS=80
  "$completion_handler" || exit 1
  [[ "${COMPREPLY[*]}" == *observed* ]]
  COMP_WORDS=(goto --register-d)
  COMPREPLY=()
  "$completion_handler" || exit 1
  assert_equal "${COMPREPLY[*]}" '--register-dynamic'
fi
rmdir -- "$literal"
goto --cleanup
[ ! -e "$test_root/evaluated" ]
[ ! -e "$test_root/outside/marker" ]
expect_failure goto -x literal
goto -l > "$test_root/listing"
grep -F -- 'dynamic' "$test_root/listing" >/dev/null
grep -F -- 'observed' "$test_root/listing" >/dev/null
goto -u observed
[ ! -e "$test_root/evaluated" ]
[ -L "$GOTO_DB" ]
[ -L "$test_root/database-link" ]
if grep -q '^observed ' "$test_root/state/db"; then exit 1; fi
goto -R observed '$first_dir/target'
assert_equal "$(goto -x observed)" "$first_dir/target"

# Reloading the integration must preserve dynamic and static semantics.
source "$goto_script"
cd "$second_dir"
assert_equal "$(goto -x dynamic)" "$second_dir/target"
assert_equal "$(goto -x fixed)" "$first_dir/target"
printf 'goto integration tests passed (%s)\n' "${BASH_VERSION:-$ZSH_VERSION}"
