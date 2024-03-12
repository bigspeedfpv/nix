{ pkgs, ... }:
{
    home.stateVersion = "23.11";

    programs.home-manager.enable = true;

    programs.fish = {
        enable = true;
        shellInit = ''
            direnv hook fish | source
        '';
    };

    programs.zoxide = {
        enable = true;
        enableFishIntegration = true;
    };



    programs.git = {
        enable = true;
        userName = "Andrew Brower";
        userEmail = "bigspeedfpv@gmail.com";

    };



    programs.kitty = {
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

    programs.tmux = {
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

    home.shellAliases = {
        search = "fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}' | xargs nvim";
        ll = "eza -l -g --icons --git --group-directories-first";
        lla = "eza -1 --icons --tree --git-ignore";
    };
}
