{
  description = "Sushi's Darwin system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, config, ... }: {
      system.primaryUser = "sushi";
      nixpkgs.config.allowUnfree = true;
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
          pkgs.aldente
          pkgs.brave
          pkgs.chatgpt
          pkgs.gitkraken
          pkgs.iina
          pkgs.jetbrains-toolbox
          pkgs.postman
          pkgs.raycast
          pkgs.spotify
          pkgs.podman
          pkgs.podman-desktop
          pkgs.podman-compose

          pkgs.mkalias
          pkgs.claude-code
          pkgs.neovim
          pkgs.dust
          pkgs.bat
          pkgs.gh
          pkgs.bun
          pkgs.btop
          pkgs.fd
          pkgs.fzf
          pkgs.ffmpeg
          pkgs.ghostscript
          pkgs.carapace
          pkgs.gemini-cli
          pkgs.go
          pkgs.delta
          pkgs.lua
          pkgs.nodejs
          pkgs.nushell
          pkgs.ripgrep
          pkgs.stow
          pkgs.surfer
          pkgs.zoxide
          pkgs.lazygit
          pkgs.codex
          pkgs.starship
        ];

        homebrew = {
            enable = true;
            casks = [
                "aldente"
                "chatgpt"
                "ghostty"
                "graalvm-jdk@21"
                "linearmouse"
                "lm-studio"
                "minecraft"
                "nordvpn"
                "signal"
                "visual-studio-code"
            ];
            brews = [
                "supabase"
                "llvm@18"
                "lua"
                "luarocks"
                "icarus-verilog"
                "mas"
            ];
            masApps = {
                "WhatsApp Messenger" = 310633997;
                "Goodnotes: AI Notes, Docs, PDF" = 1444383602;
                "Microsoft Word" = 462054704;
                "Microsoft Excel" = 462058435;
                "Microsoft PowerPoint" = 462062816;
                "Xcode" = 497799835;
            };
            onActivation.cleanup = "zap";
            onActivation.autoUpdate = true;
            onActivation.upgrade = true;
        };

      fonts.packages = [
        pkgs.lilex 
        pkgs.nerd-fonts.lilex 
      ];

      
system.activationScripts.applications.text = let
  env = pkgs.buildEnv {
    name = "system-applications";
    paths = config.environment.systemPackages;
    pathsToLink = ["/Applications"];
  };
in
  pkgs.lib.mkForce ''
  # Set up applications.
  echo "setting up /Applications..." >&2
  rm -rf /Applications/Nix\ Apps
  mkdir -p /Applications/Nix\ Apps
  find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
  while read -r src; do
    app_name=$(basename "$src")
    echo "copying $src" >&2
    ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
  done
      '';

      system.defaults = {
        dock.persistent-apps = [
            "/System/Applications/Phone.app"
            "/Applications/Safari.app"
            "/Applications/WhatsApp.app"
            "/Applications/Signal.app"
            "/System/Applications/Reminders.app"
            "/System/Applications/Mail.app"
            "/System/Applications/iPhone Mirroring.app"
            "${pkgs.chatgpt}/Applications/ChatGPT.app"
            "/Applications/Ghostty.app"
        ];
        finder.FXPreferredViewStyle = "clmv";
        loginwindow.GuestEnabled = false;
        NSGlobalDomain.AppleInterfaceStyle = "Dark";
        NSGlobalDomain.KeyRepeat = 2;
      };


      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."sushi-mac" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration 
        nix-homebrew.darwinModules.nix-homebrew
        {
            nix-homebrew = {
                enable = true;
                enableRosetta = true;
                user = "sushi";
                autoMigrate = true;
            };
        }
    ];
    };

    darwinPackages = self.darwinConfigurations."sushi-mac".packages;
  };
}
