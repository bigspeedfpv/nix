pkgs: inputs:
with pkgs; [
  btop
  cachix
  git
  neovim
  killall

  inputs.agenix.packages."${system}".default
  inputs.alejandra.defaultPackage.${system}
]
