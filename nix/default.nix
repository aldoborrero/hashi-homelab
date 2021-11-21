{ system ? builtins.currentSystem
, nixpkgs ? import ./nixpkgs.nix { inherit system; }
}:

let
  mkEnv = nixpkgs.callPackage ./mkEnv.nix { };

  just = nixpkgs.just;
  just-alias = nixpkgs.writeShellScriptBin "j" ''
    exec ${just}/bin/just "$@"
  '';

  trash-updater = nixpkgs.callPackage ./pkgs/trash-updater { };
in
{
  inherit nixpkgs;

  env = mkEnv {
    paths = [
      just
      just-alias
      nixpkgs.acme-sh
      nixpkgs.hadolint
      nixpkgs.mkcert
      nixpkgs.nixos-generators
      nixpkgs.nixpkgs-fmt
      nixpkgs.nodejs-16_x
      nixpkgs.nodePackages.prettier
      nixpkgs.shfmt
      nixpkgs.treefmt
      nixpkgs.yarn
      nixpkgs.yq-go
      trash-updater
    ];
  };
}
