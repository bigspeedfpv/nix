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

  lazygit

  spotify

  inputs.fh.packages."${system}".default
]
