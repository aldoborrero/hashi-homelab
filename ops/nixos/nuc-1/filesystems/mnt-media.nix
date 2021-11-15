{ config, pkgs, ... }:

{
  fileSystems."/mnt/media" = {
    device = "192.168.1.9:/volume1/Media";
    fsType = "nfs";
  };

}
