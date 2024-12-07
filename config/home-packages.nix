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

  modrinth-app
  prismlauncher

  moonlight-qt

  lazygit

  (discord.override {
    withVencord = true;
  })
  vesktop

  r2modman

  lua-language-server

  nerd-fonts.symbols-only

  inputs.fh.packages.${system}.default
]
