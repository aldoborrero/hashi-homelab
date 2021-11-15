{ config, pkgs, ... }:

{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      53
      80
      443
      853
    ];
    allowedUDPPorts = [
      53
      80
      443
      853
      51820
    ];
  };
}
