{
  writers,
  symlinkJoin,
  makeWrapper,
  fish,
  gh,
  ...
}:
let

  name = "nixup";
  deps = [
    fish
    gh
  ];
  nixup = writers.writeFishBin name ./up.fish;

in
symlinkJoin {

  inherit name;
  buildInputs = [ makeWrapper ];
  paths = [ nixup ] ++ deps;
  postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";

}
