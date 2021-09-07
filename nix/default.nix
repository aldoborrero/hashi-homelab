{
  system ? builtins.currentSystem,
  nixpkgs ? import ./nixpkgs.nix { inherit system; }
}:

let
  tf = nixpkgs.terraform.withPlugins (p: [
    p.null
    p.local
    p.random
  ]);

  tf-alias = nixpkgs.writeShellScriptBin "tf" ''
    exec ${tf}/bin/terraform "$@"
  '';

  mkEnv = nixpkgs.callPackage ./mkEnv.nix {};
in
{
  inherit nixpkgs;

  env = mkEnv {
    paths = [
      tf-alias
      tf
    ];
  };
}
