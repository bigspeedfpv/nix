pkgs: inputs:
with pkgs; [
  fzf
  ripgrep
  eza
  zoxide
  jq
  neofetch
  tmux
  bat

  nodejs_20 # tsserver compat :(

  gitAndTools.git
  gitAndTools.gh

  inputs.fh.packages."${system}".default
  inputs.pow.packages."${system}".default
]
