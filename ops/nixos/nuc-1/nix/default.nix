{ config, pkgs, ... }:

{
  imports = [
    ./nixpkgs-config.nix
    ./gc.nix
  ];
}
