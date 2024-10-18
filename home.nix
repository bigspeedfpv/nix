{pkgs, ...}: {
  home.stateVersion = "23.11";

  programs = {
    home-manager.enable = true;

    fish = {
      enable = true;
    };

    bash.enable = true;

    nix-index-database.comma.enable = true;

    kitty = {
      enable = true;

      extraConfig = ''
        font_family Comic Code Semibold
        bold_font Comic Code Bold
        italic_font Comic Code Italic
        bold_italic_font Comic Code Bold Italic
      '';

      shellIntegration = {
        enableBashIntegration = true;
        enableZshIntegration = true;
        enableFishIntegration = true;
      };
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };

    bat = {
      enable = true;
    };

    git = {
      enable = true;
      userName = "Andrew Brower";
      userEmail = "bigspeedfpv@gmail.com";
    };

    ssh = {
      enable = true;
      matchBlocks = {
        "andy-vps" = {
          hostname = "andy-vps";
          forwardAgent = true;
        };
        "xoog" = {
          hostname = "xoog";
          forwardAgent = true;
        };
      };
    };

    zellij = {
      enable = true;
      enableFishIntegration = true;
    };

    nix-index = {
      enable = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  };

  catppuccin.enable = true;
  catppuccin.flavor = "mocha";

  home.shellAliases = {
    search = "fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}' | xargs nvim";
    ll = "eza -l -g --icons --git --group-directories-first";
    lla = "eza -1 --icons --tree --git-ignore";
  };
}
