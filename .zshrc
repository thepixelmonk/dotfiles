function mbrew() {
  arch -x86_64 brew $*
}

function bg() {
    nohup $@ > /dev/null 2>&1 &
}

alias ls="ls --color=auto"
alias pip="pip3"
alias vim="lvim"
alias v="lvim"
alias mux="tmuxinator"

# bun completions
[ -s "/Users/pixelmonk/.bun/_bun" ] && source "/Users/pixelmonk/.bun/_bun"

[ -f "/Users/pixelmonk/.ghcup/env" ] && source "/Users/pixelmonk/.ghcup/env" # ghcup-env

eval "$(starship init zsh)"
