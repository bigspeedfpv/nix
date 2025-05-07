{
  pkgs,
  inputs,
  config,
  ...
}: {
  home.stateVersion = "23.11";

  programs = {
    home-manager.enable = true;

    fish.enable = true;
    zsh.enable = true;
    bash.enable = true;

    nix-index-database.comma.enable = true;

    helix.enable = true;

    kitty = {
      enable = true;

      settings.font_family = "Comic Code Semibold";
      settings.bold_font = "Comic Code Bold";
      settings.italic_font = "Comic Code Italic";
      settings.bold_italic_font = "Comic Code Bold Italic";

      settings.map = builtins.concatStringsSep "\n" (builtins.concatLists (builtins.genList (
          i: [
            "map alt+${toString i} goto_tab ${toString i}"
          ]
        )
        9));

      shellIntegration = {
        enableBashIntegration = true;
        enableZshIntegration = true;
        enableFishIntegration = true;
      };
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
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

    tmux = {
      enable = true;
      plugins = with pkgs; [
        tmuxPlugins.battery
        tmuxPlugins.resurrect
      ];
      extraConfig = ''
        set -s escape-time 0
      '';
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

    spicetify = let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        beautiful-lyrics
      ];
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
    };

    nushell = {
      enable = true;
      extraConfig = ''
        let carapace_completer = {|spans|
          carapace $spans.0 nushell $spans | from json
        }
        $env.config = {
          show_banner: false,
          completions: {
            case_sensitive: false # case-sensitive completions
            quick: true    # set to false to prevent auto-selecting completions
            partial: true    # set to false to prevent partial filling of the prompt
            algorithm: "fuzzy"    # prefix or fuzzy
            external: {
              # set to false to prevent nushell looking into $env.PATH to find more suggestions
              enable: true
              # set to lower can improve completion performance at the cost of omitting some options
              max_results: 100
              completer: $carapace_completer # check 'carapace_completer'
            }
          }
        }
        $env.PATH = ($env.PATH |
        split row (char esep) |
        prepend /home/myuser/.apps |
        append /usr/bin/env
        )
      '';
    };
    carapace.enable = true;
    carapace.enableNushellIntegration = true;

    starship = {
      enable = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };

    mpv = {
      enable = true;
      scripts = builtins.attrValues {
        inherit
          (pkgs.mpvScripts)
          sponsorblock
          thumbfast
          mpv-webm
          uosc
          ;
      };
      bindings = {
        "ALT+k" = "add sub-scale +0.1";
        "ALT+j" = "add sub-scale -0.1";
      };
      config = {
        sub-border-style = "background-box";
        sub-back-color = "#00000044"; # Transparent background for the blur effect
        sub-blur = "3"; # Adjust blur amount as needed
        sub-margin-y = "36"; # Margin from bottom of screen
      };
    };

    feh = {
      enable = true;
    };
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";
    mako.enable = false;
    waybar.enable = true;
    gtk.enable = true;
    mpv.enable = false;
  };

  home.shellAliases = {
    icat = "kitten icat";
    search = "fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}' | xargs nvim";
    ll = "eza -l -g --icons --git --group-directories-first";
    lla = "eza -1 --icons --tree --git-ignore";
    dev = "nix develop --command fish";
    devimpure = "nix develop --impure --command fish";
  };
}
