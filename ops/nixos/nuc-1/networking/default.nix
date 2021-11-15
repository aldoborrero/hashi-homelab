{ config, pkgs, ... }:

{
  imports = [
    ./firewall.nix
    ./nat.nix
    ./wireguard.nix
  ];

  networking = {
    hostName = "nuc-1";
    wireless.enable = false;

    useDHCP = false;

    interfaces.eno1.useDHCP = true;
    interfaces.wlp0s0f3.useDHCP = false;
  };
}
