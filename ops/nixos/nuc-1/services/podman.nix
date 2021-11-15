{ config, pkgs, ... }:

{
  virtualisation.podman = {
    enable = false;
    dockerSocket = true;
    dockerCompat = true;
  };
}
