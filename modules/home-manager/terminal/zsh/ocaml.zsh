COMPLETE_FILE="$HOME/.opam/opam-init/complete.zsh"

command -v opam > /dev/null 2> /dev/null && eval $(opam env)

[[ -f "$COMPLETE_FILE" ]] && source "$COMPLETE_FILE"
