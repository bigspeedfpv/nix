pkgs: inputs:
with pkgs; [
  btop
  neovim-nightly
  git
  cachix
  inputs.agenix.packages."${system}".default
  inputs.alejandra.defaultPackage.${system}
]
