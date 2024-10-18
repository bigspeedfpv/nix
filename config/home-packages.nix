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

  moonlight-qt

  gitAndTools.git
  gitAndTools.gh

  lazygit

  inputs.fh.packages."${system}".default
]
