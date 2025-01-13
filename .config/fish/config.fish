set -g fish_greeting
set -Ux XMODIFIERS '@im=fcitx'

if status is-interactive
    # Commands to run in interactive sessions can go here
end

zoxide init fish | source

# Aliases
alias cd=z
alias ll="ls -lah"
alias vim=nvim
alias vi=nvim
alias lzg=lazygit
alias lzd=lazydocker

fastfetch
