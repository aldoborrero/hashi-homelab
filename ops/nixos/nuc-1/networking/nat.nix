{ config, pkgs, ... }:

{
  networking.nat = {
    enable = true;
    externalInterface = "eno1";
    internalInterfaces = [ "wg0" ];
  };
}
