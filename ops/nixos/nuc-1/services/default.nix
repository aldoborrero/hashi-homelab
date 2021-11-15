{ config, pkgs, ... }:

{
  imports = [
    ./docker.nix
    ./openssh.nix
    ./unbound.nix
  ];
}
