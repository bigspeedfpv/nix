pkgs: inputs: let
  modrinth = let
    inherit (pkgs) stdenv lib;
  in
    pkgs.modrinth-app.overrideAttrs (_: {
      broken = !stdenv.hostPlatform.isx86_64 && !stdenv.hostPlatform.isDarwin;
      postInstall =
        lib.optionalString stdenv.hostPlatform.isDarwin ''
          mkdir -p "$out"/bin
          mv "$out"/Applications/Modrinth\ App.app/Contents/MacOS/Modrinth\ App "$out"/bin/modrinth-app
          ln -s "$out"/bin/modrinth-app "$out"/Applications/Modrinth\ App.app/Contents/MacOS/Modrinth\ App
        ''
        + lib.optionalString stdenv.hostPlatform.isLinux ''
          desktop-file-edit \
            --set-comment "Modrinth's game launcher" \
            --set-key="StartupNotify" --set-value="true" \
            --set-key="Categories" --set-value="Game;ActionGame;AdventureGame;Simulation;" \
            --set-key="Keywords" --set-value="game;minecraft;mc;" \
            --set-key="StartupWMClass" --set-value="ModrinthApp" \
            $out/share/applications/modrinth-app.desktop
        '';
    });
in
  with pkgs; [
    fzf
    ripgrep
    eza
    zoxide
    jq
    neofetch
    bat

    nil

    qemu
    podman
    podman-compose

    gitAndTools.git
    gitAndTools.gh

    lazygit

    spotify

    vesktop

    inputs.fh.packages."${system}".default
  ]
