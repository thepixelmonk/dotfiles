alias ls="ls --color=auto"
alias pip="pip3"
alias vim="lvim"
alias v="lvim"

[ -s "/Users/pixelmonk/.bun/_bun" ] && source "/Users/pixelmonk/.bun/_bun"
[ -f "/Users/pixelmonk/.ghcup/env" ] && source "/Users/pixelmonk/.ghcup/env"

eval "$(starship init zsh)"

function mbrew() {
  arch -x86_64 brew $*
}

function bg() {
    nohup $@ > /dev/null 2>&1 &
}
