set -g fish_greeting
set -gx LC_ALL en_US.UTF-8
set -Ux LIBGL_ALWAYS_SOFTWARE 1 # WSLg
set -Ux XMODIFIERS '@im=fcitx'
set -Ux BROWSER '/mnt/c/Program files/BraveSoftware/Brave-Browser/Application/brave.exe'

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
alias lzs=lazysql
alias sail="./vendor/bin/sail"

fastfetch
