export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv >/dev/null && eval "$(pyenv init -)"

# avoid issues with nix g++ environment
alias pyenv="PATH=/bin:/usr/bin:$PATH pyenv"
