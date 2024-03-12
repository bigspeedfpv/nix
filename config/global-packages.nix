pkgs: inputs:
with pkgs; [
  btop
  neovim-nightly
  git
  inputs.agenix.packages."${system}".default
  inputs.alejandra.defaultPackage.${system}
]
