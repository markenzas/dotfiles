set -g fish_greeting

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
#
zoxide init fish | source

# Aliases
alias cd=z
alias ll="ls -lah"
alias vim=nvim
alias vi=nvim
alias lzg=lazygit
alias lzd=lazydocker

neofetch
