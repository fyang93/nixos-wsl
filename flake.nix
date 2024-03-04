{
  description = "WSL NixOS Flake";

  # The `outputs` function will return all the build results of the flake.
  # A flake can have many use cases and different types of outputs,
  # parameters in `outputs` are defined in `inputs` and can be referenced by their names.
  # However, `self` is an exception, this special parameter points to the `outputs` itself (self-reference)
  # The `@` syntax here is used to alias the attribute set of the inputs's parameter, making it convenient to use inside the function.
  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-stable,
    nixoswsl,
    home-manager,
    vscode-server,
    ...
  }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";

      specialArgs = {
        username = "yang";
        useremail = "norepfy@gmail.com"; # used by git config

        pkgs-stable = import nixpkgs-stable {
          system = system;
          config.allowUnfree = true;
        };
      } // inputs;

      modules = [
        nixoswsl.nixosModules.wsl {
          wsl.defaultUser = "${specialArgs.username}";
        }

        ./system

        home-manager.nixosModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = specialArgs;
            users."${specialArgs.username}" = import ./home;
          };
        }

        # fix vscode server issue
        # https://github.com/microsoft/vscode-remote-release/issues/7986
        # https://github.com/nix-community/nixos-vscode-server/issues/41
        # check: https://github.com/nix-community/nixos-vscode-server
        #        https://github.com/nix-community/NixOS-WSL/issues/294
        vscode-server.nixosModules.default
        ({ pkgs, ... }: {
          system = {
            stateVersion = "23.05";
          };
          programs.nix-ld.enable = true;
          services.vscode-server.enable = true;
          environment.systemPackages = [
            pkgs.wget
          ];

          wsl = {
            enable = true;
            defaultUser = "${specialArgs.username}";
            extraBin = with pkgs; [
              { src = "${coreutils}/bin/cat"; }
              { src = "${coreutils}/bin/date"; }
              { src = "${coreutils}/bin/dirname"; }
              { src = "${findutils}/bin/find"; }
              { src = "${coreutils}/bin/id"; }
              { src = "${coreutils}/bin/mkdir"; }
              { src = "${coreutils}/bin/mv"; }
              { src = "${coreutils}/bin/readlink"; }
              { src = "${coreutils}/bin/rm"; }
              { src = "${coreutils}/bin/sleep"; }
              { src = "${coreutils}/bin/uname"; }
              { src = "${coreutils}/bin/wc"; }
              { src = "${gnutar}/bin/tar"; }
              { src = "${gzip}/bin/gzip"; }
            ];
          };
        })
      ];
    };
  };

  # This is the standard format for flake.nix. `inputs` are the dependencies of the flake,
  # Each item in `inputs` will be passed as a parameter to the `outputs` function after being pulled and built.
  inputs = {
    # There are many ways to reference flake inputs. The most widely used is github:owner/name/reference,
    # which represents the GitHub repository URL + branch/commit-id/tag.

    # Official NixOS package source, using nixos's unstable branch by default
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";

    # follows https://github.com/nix-community/NixOS-WSL/issues/294
    nixoswsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs dependencies.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # vscode server
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
    };

    # color scheme
    catppuccin-btop = {
      url = "github:catppuccin/btop";
      flake = false;
    };
    catppuccin-bat = {
      url = "github:catppuccin/bat";
      flake = false;
    };
    catppuccin-starship = {
      url = "github:catppuccin/starship";
      flake = false;
    };
  };

  # the nixConfig here only affects the flake itself, not the system configuration!
  nixConfig = {
    experimental-features = ["nix-command" "flakes"];

    substituters = [
      # replace official cache with a mirror located in China
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
    ];
  };
}