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

    git = {
      enable = true;
      userName = "Andrew Brower";
      userEmail = "bigspeedfpv@gmail.com";
    };

    kitty = {
      enable = true;
      theme = "Catppuccin-Mocha";
      font = {
        name = "Geist Mono Semibold";
        size = 13.5;
      };
      extraConfig = ''
        macos_titlebar_color background
        macos_option_as_alt yes
      '';
    };

    tmux = {
      enable = true;
      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.catppuccin;
          extraConfig = ''
            set -g @catppuccin-flavor 'mocha'
            set -g @catppuccin_status_modules_right "application session date_time battery"
          '';
        }
        tmuxPlugins.battery
      ];
    };
  };

  home.shellAliases = {
    search = "fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}' | xargs nvim";
    ll = "eza -l -g --icons --git --group-directories-first";
    lla = "eza -1 --icons --tree --git-ignore";
  };
}
