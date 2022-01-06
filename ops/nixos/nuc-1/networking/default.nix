{ config, pkgs, ... }:

{
  networking = {
    hostName = "nuc-1";
    wireless.enable = false;

    useDHCP = false;

    interfaces.eno1.useDHCP = true;
    interfaces.wlp0s0f3.useDHCP = false;

    firewall = {
      enable = true;
      allowedTCPPorts = [
        53
        80
        443
        853
        2377
      ];
      allowedUDPPorts = [
        53
        80
        443
        853
        2377
      ];
    };
  };
}
