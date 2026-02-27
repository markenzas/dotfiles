function configMacOS
  source ~/.config/fish/functions/proxy.fish
end

function configLinux
  set -Ux XMODIFIERS '@im=fcitx'

  alias wbrr="pkill waybar && waybar & disown && clear"
  alias godot="godot --display-driver wayland"

  # pnpm
  set -gx PNPM_HOME "/home/markas/.local/share/pnpm"
  if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
  end
  # pnpm end
end

function configShared
  set -g fish_greeting

  zoxide init fish | source

  alias cd=z
  alias ll="ls -lah"
  alias vim=nvim
  alias vi=nvim
  alias lzg=lazygit
  alias lzj=lazyjj
  alias lzd=lazydocker
  alias lzs=lazysql
  alias sail="./vendor/bin/sail"
  alias dcu="docker-compose up -d"
  alias dcd="docker-compose down"
  alias gt="gotestsum"
end

# Load configurations
configShared

switch (uname)
    case Darwin
      configMacOS
    case Linux
      configLinux
end


