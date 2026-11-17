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
      perSystem = { system, ... }: {
        packages.default =
          let
            pkgs = import inputs.nixpkgs { inherit system; };
            name = "nixup";
            nixup = pkgs.writers.writeFishBin "nixup" ./up.fish;
            deps = with pkgs; [
              gh
              fish
            ];
          in
          pkgs.symlinkJoin {
            inherit name;
            paths = [ nixup ] ++ deps;
            buildInputs = [ pkgs.makeWrapper ];
            postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";
          };
      };
    };

}
