{
  pkgs,
  inputs,
  hyprland,
  ...
}: let
  toggle = program: service: let
    prog = builtins.substring 0 14 program;
  in "pkill ${prog} || ${program}";
in {
  imports = [
    inputs.anyrun.homeManagerModules.default
  ];

  home.packages = with pkgs;
    import ../config/home-packages.nix pkgs inputs
    ++ [
      _1password
      _1password-gui

      gnome-tweaks

      firefox
      vesktop

      obs-studio

      modrinth-app

      easyeffects

      steam
      heroic

      spotify
      neovim
    ];

  programs.fish = {
    enable = true;
    shellInit = ''
      direnv hook fish | source
    '';
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "Comic Code Ligatures Semibold";
      size = 11;
    };
  };

  programs.zellij.enableFishIntegration = true;

  catppuccin.enable = true;
  catppuccin.flavor = "mocha";

  programs.direnv = {
    enable = true;
    enableBashIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Andrew Brower";
    userEmail = "bigspeedfpv@gmail.com";

    extraConfig = ''
      [user]
        signingkey = ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAxWL2XZtoicDaL/UlZQGTRbs2iLN/Vpivv0nOZOMoII

      [gpg]
        format = ssh

      [gpg "ssh"]
        program = "/etc/profiles/per-user/andy/bin/op-ssh-sign"

      [commit]
        gpgsign = true
    '';
  };

  programs.neovim.defaultEditor = true;

  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          blur-my-shell.extensionUuid
        ];
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    settings = {
      "$mod" = "SUPER";

      monitor = [ 
        "DP-1, preferred, 0x0, 2"
        "HDMI-A-1, preferred, 1920x0, 1"
      ];

      bind =
        [
          "$mod, B, exec, firefox"
          ", Print, exec, grimblast --notify copysave area"
          "$mod, C, exec, kitty"
          "$mod SHIFT, E, exec, pkill hyprland"
          "$mod, Q, killactive,"
          "$mod, F, fullscreen,"
          "$mod, G, togglegroup,"
          "$mod SHIFT, N, changegroupactive, f"
          "$mod SHIFT, P, changegroupactive, b"
          "$mod, R, togglesplit,"
          "$mod, T, togglefloating,"
          "$mod, P, pseudo,"
          "$mod ALT, , resizeactive,"

          "$mod, h, movefocus, l"
          "$mod, l, movefocus, r"
          "$mod, j, movefocus, d"
          "$mod, k, movefocus, u"

          "$mod ALT, h, focusmonitor, l"
          "$mod ALT, l, focusmonitor, r"

          "$mod SHIFT ALT, h, movecurrentworkspacetomonitor, l"
          "$mod SHIFT ALT, l, movecurrentworkspacetomonitor, r"

          "$mod, SPACE, exec, ${toggle "anyrun" true}"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (
              i: let
                ws = i + 1;
              in [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9)
        );

      input = {
        force_no_accel = true;
      };

      cursor = {
        no_hardware_cursors = true;
      };

      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      ];

      general.allow_tearing = true;
      windowrulev2 = [
        "immediate, class:^(cs2)$"
        "immediate, class:^(Overwatch)"
      ];
    };
  };

  programs.anyrun = {
    enable = true;
    config = {
      x = {fraction = 0.5;};
      y = {fraction = 0.3;};
      width = {fraction = 0.5;};

      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        # randr
        rink
        shell
        symbols
      ];
    };
  };
}
