pkgs: inputs:
with pkgs; [
  btop
  cachix
  git
  neovim

  inputs.agenix.packages."${system}".default
  inputs.alejandra.defaultPackage.${system}
]
