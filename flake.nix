{

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";
  };

  outputs = inputs: {

    defaultPackage.x86_64-linux = inputs.self.packages.x86_64-linux.nixup;

    packages.x86_64-linux.nixup =
      let
        pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
        name = "nixup";
        nixup = pkgs.writers.writeFishBin "nixup" ./up.fish;
        deps = with pkgs; [
          fish
          git
          gh
        ];
      in
      pkgs.symlinkJoin {
        inherit name;
        paths = [ nixup ] ++ deps;
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";
      };

  };

}
