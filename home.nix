{pkgs, ...}: {
  home.stateVersion = "23.11";

  programs = {
    home-manager.enable = true;

    bash.enable = true;

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

    # tmux = {
    #   enable = true;
    #   plugins = with pkgs; [
    #     {
    #       plugin = tmuxPlugins.catppuccin;
    #       extraConfig = ''
    #         set -g @catppuccin-flavor 'mocha'
    #         set -g @catppuccin_status_modules_right "application session date_time battery"
    #         set -s escape-time 0
    #       '';
    #     }
    #     tmuxPlugins.battery
    #
    #     tmuxPlugins.resurrect
    #   ];
    # };

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
    };
  };

  home.shellAliases = {
    search = "fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}' | xargs nvim";
    ll = "eza -l -g --icons --git --group-directories-first";
    lla = "eza -1 --icons --tree --git-ignore";
  };
}
