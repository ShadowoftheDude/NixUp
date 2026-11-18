{ ... }:

{

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      imports = [ ./up.nix ];
      perSystem = { pkgs, config, ... }: {
        packages = {
          nixup = pkgs.callPackage ./up.nix { };
          default = config.packages.nixup;
        };
      };
    };

}
