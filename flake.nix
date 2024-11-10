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
    nixos-wsl,
    home-manager,
    ...
  }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";

      specialArgs = {
        username = "yang";
        useremail = "norepfy@gmail.com"; # used by git config

        pkgs = import nixpkgs {
          system = system;
          config.allowUnfree = true;
        };
      } // inputs;

      modules = [
        nixos-wsl.nixosModules.default
        ({ pkgs, ... }: {
          system.stateVersion = "24.05";
          wsl = {
            enable = true;
            wrapBinSh = false; # https://github.com/microsoft/vscode-remote-release/issues/10375
            useWindowsDriver = true; # required by nvidia-container-toolkit-cdi-generator
            defaultUser = "${specialArgs.username}";
          };
          programs.nix-ld = {
            enable = true;
            package = pkgs.nix-ld-rs; # only for NixOS 24.05
            libraries = with pkgs; [
            ];
          };
        })

        ./system

        home-manager.nixosModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = specialArgs;
            users."${specialArgs.username}" = import ./home;
          };
        }
      ];
    };
  };

  # This is the standard format for flake.nix. `inputs` are the dependencies of the flake,
  # Each item in `inputs` will be passed as a parameter to the `outputs` function after being pulled and built.
  inputs = {
    # There are many ways to reference flake inputs. The most widely used is github:owner/name/reference,
    # which represents the GitHub repository URL + branch/commit-id/tag.

    # Official NixOS package source, using nixos's stable branch by default
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # follows https://github.com/nix-community/NixOS-WSL/issues/294
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs dependencies.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # useful nushell scripts, such as auto_completion
    nushell-scripts = {
      url = "github:nushell/nu_scripts";
      flake = false;
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
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
    ];
  };
}
