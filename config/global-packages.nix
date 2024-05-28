pkgs: inputs:
with pkgs; [
  btop
  neovim
  git
  cachix
  inputs.agenix.packages."${system}".default
  inputs.alejandra.defaultPackage.${system}
]
