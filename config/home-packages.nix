pkgs: inputs:
with pkgs; [
  fzf
  ripgrep
  eza
  zoxide
  jq
  neofetch
  bat

  nil

  qemu
  podman
  podman-compose

  gitAndTools.git
  gitAndTools.gh

  prismlauncher

  lazygit

  (discord-canary.override {
    withVencord = true;
  })

  r2modman

  bash-language-server
  lua-language-server

  nerd-fonts.symbols-only

  imagemagick

  inputs.fh.packages.${system}.default
]
