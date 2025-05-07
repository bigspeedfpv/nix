{
  pkgs,
  inputs,
  ...
}: let
  toggle = program: service: let
    prog = builtins.substring 0 14 program;
  in "pkill ${prog} || ${program}";
in {
  home.packages = with pkgs;
    import ../config/home-packages.nix pkgs inputs
    ++ [
      ranger

      firefox

      grimblast

      steam
      heroic

      kitty
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

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    settings = {
      "$mod" = "SUPER";

      xwayland.force_zero_scaling = true;

      general.gaps_out = "5, 20, 20, 20";

      exec-once = [
        "clipse -listen"
      ];

      monitor = [
        "eDP-1, preferred, 0x0, 1.6, vrr, 1"
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

          "$mod, o, setprop, active opaque toggle"

          "$mod SHIFT ALT, h, movecurrentworkspacetomonitor, l"
          "$mod SHIFT ALT, l, movecurrentworkspacetomonitor, r"

          "$mod, SPACE, exec, ${toggle "anyrun" true}"

          "$mod, V, exec, kitty --class clipse -e clipse"

          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
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

      binde = [
        ", XF86MonBrightnessUp, exec, brightnessctl -d intel_backlight set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl -d intel_backlight set 5%-"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      input = {
        touchpad = {
          natural_scroll = true;
        };
      };

      device = {
        name = "logitech-usb-receiver-mouse";
        sensitivity = -0.3;
        accel_profile = "flat";
      };

      cursor = {
        no_hardware_cursors = true;
      };

      workspace = builtins.concatLists (builtins.genList (
          i: let
            ws = i + 1;
          in [
            "${toString ws}, monitor:eDP-1"
          ]
        )
        9);

      general.allow_tearing = true;
      windowrulev2 = [
        "opaque, title:(.*YouTube.*)"
        "immediate, class:^(cs2)$"
        "immediate, title:^(Marvel Rivals)"
        "immediate, title:(Overwatch)"
        "immediate, class:^(Minecraft)"
        "immediate, class:^(velocidrone)"
        "immediate, title:^(Elite - Dangerous)"
        "float, title:^(Picture-in-Picture|Firefox)$"
        "size 800 450, title:^(Picture-in-Picture|Firefox)$"
        "pin, title:^(Picture-in-Picture|Firefox)$"
        "float, class:(clipse)"
        "size 622 652, class:(clipse)"
      ];

      misc = {
        vrr = 1;
      };

      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"
      ];

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

      decoration = {
        rounding = 4;
        active_opacity = 0.9;
        inactive_opacity = 0.9;
        blur = {
          enabled = true;
          size = 12;
          passes = 3;
          popups = true;
          input_methods = true;
        };
      };
    };
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        output = ["eDP-1"];
        layer = "top";
        position = "top";
        height = 30;
        margin = "0px 15px 0px 15px";
        modules-left = ["hyprland/workspaces" "hyprland/window"];
        modules-center = ["clock"];
        modules-right = ["mpd" "battery"];

        battery = {
          states = {
            warning = 25;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-icons = ["" "" "" "" ""];
        };
      };
    };
    style = ''
      * {
        font-size: 15px;
        min-height: 0;
        box-shadow: none;
        text-shadow: none;
      }

      button:hover {
        box-shadow: none;
        text-shadow: none;
        background: none;
        transition: none;
        border: none;
      }

      #waybar {
        background: transparent;
        color: @pink;
      }

      #workspaces {
        border-radius: 1rem;
        margin: 5px;
        background-color: @surface0;
      }

      #workspaces button {
        color: @pink;
        border-radius: 1rem;
      }

      #workspaces button.active {
        color: @sky;
        font-weight: bold;
      }

      #workspaces button:hover {
        background-color: @surface1;
      }

      #window {
        font-size: 12px;
        border-radius: 1rem;
        background-color: @surface0;
        color: @pink;
        margin: 5px;
        padding: 0px 10px 0px 10px;
      }

      #clock {
        color: @text;
        font-weight: bold;
        border-radius: 1rem;
        margin: 5px;
        background-color: @surface0;
        padding: 0px 10px 0px 10px;
      }

      #battery {
        border-radius: 1rem;
        margin: 5px;
        background-color: @surface0;
        padding: 0px 10px 0px 10px;
        color: @sky;
      }

      #battery.charging {
        color: @green;
      }

      #battery.warning:not(.charging) {
        color: @yellow;
      }

      #battery.critical:not(.charging) {
        color: @red;
      }
    '';
  };

  programs.anyrun = {
    enable = true;
    config = {
      x = {fraction = 0.5;};
      y = {fraction = 0.3;};
      width = {fraction = 0.5;};

      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        rink
        shell
        symbols
      ];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      animations = {
        enabled = true;
        bezier = "linear, 1, 1, 0, 0";
        animation = [
          "fadeIn, 1, 5, linear"
          "fadeOut, 1, 5, linear"
          "inputFieldDots, 1, 2, linear"
        ];
      };
    };
  };

  services.hyprpolkitagent.enable = true;

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "pidof hyprlock || hyprlock";
      };

      listener = [
        {
          timeout = 90;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 120;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 150;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 600;
          on-timeout = "systemctl suspend";
        }
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
        flatpakref = "https://sober.vinegarhq.org/sober.flatpakref";
        sha256 = "1pj8y1xhiwgbnhrr3yr3ybpfis9slrl73i0b1lc9q89vhip6ym2l";
      }
    ];
  };

  fonts.fontconfig.enable = true;
}
