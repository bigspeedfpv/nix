{
  pkgs,
  inputs,
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
      gnome-tweaks
      ranger

      easyeffects
      obs-studio

      firefox

      grimblast

      steam
      heroic

      jetbrains-toolbox
      lunar-client

      inputs.ghostty.packages.${system}.default
    ];

  programs.git = {
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAxWL2XZtoicDaL/UlZQGTRbs2iLN/Vpivv0nOZOMoII";
      signByDefault = true;
    };

    extraConfig = {
      gpg.format = "ssh";
      gpg.ssh.program = "op-ssh-sign";
    };
  };

  programs.neovim.defaultEditor = true;

  programs.ssh = {
    extraConfig = ''
      Host *
       IdentityAgent "~/.1password/agent.sock"
    '';
  };

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

      xwayland.force_zero_scaling = true;

      exec-once = [
        "clipse -listen"
      ];

      monitor = [
        "DP-3, preferred, 0x0, 2"
        "DP-1, preferred, 1920x0, 1, vrr, 1"
      ];

      bind =
        [
          "$mod, B, exec, firefox"
          ", Print, exec, grimblast --notify copysave area"
          "$mod, C, exec, ghostty"
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

          "$mod, V, exec, ghostty --class clipse -e clipse"
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

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      input = {
        force_no_accel = true;
      };

      cursor = {
        no_hardware_cursors = true;
      };

      workspace = builtins.concatLists (builtins.genList (
          i: let
            ws = i + 1;
            isEven = num: (pkgs.lib.mod num 2) == 0;
            display =
              if isEven ws
              then "DP-3"
              else "DP-1";
          in [
            "${toString ws}, monitor:${display}"
          ]
        )
        9);

      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "__GL_GSYNC_ALLOWED,1"
        "__GL_VRR_ALLOWED,1"
      ];

      general.allow_tearing = true;
      windowrulev2 = [
        "immediate, class:^(cs2)$"
        "immediate, title:(Overwatch)"
        "immediate, class:^(Minecraft)"
        "immediate, class:^(Lunar Client)"
        "immediate, class:^(velocidrone)"
        "float, title:^(Picture-in-Picture|Firefox)$"
        "size 800 450, title:^(Picture-in-Picture|Firefox)$"
        "pin, title:^(Picture-in-Picture|Firefox)$"
        "float, class:(clipse)"
        "size 622 652, class:(clipse)"
      ];

      misc = {
        vrr = 1;
      };

      animations = {
        enabled = true;

        bezier = [
          "b, 0.10, 0.9, 0.1, 1.05"
        ];

        animation = [
          "windows, 1, 3, b, slide"
          "windowsOut, 1, 3, b, slide"
          "border, 1, 6, default"
          "fade, 1, 4, default"
          "workspaces, 1, 4, default"
        ];
      };
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

  services.flatpak = {
    remotes = pkgs.lib.mkOptionDefault [
      {
        name = "flathub-beta";
        location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
      }
    ];

    packages = [
      {
        appId = "org.gimp.GIMP";
        origin = "flathub-beta";
      }
      {
        flatpakref = "https://sober.vinegarhq.org/sober.flatpakref";
        sha256 = "1pj8y1xhiwgbnhrr3yr3ybpfis9slrl73i0b1lc9q89vhip6ym2l";
      }
    ];
  };

  fonts.fontconfig.enable = true;
}
