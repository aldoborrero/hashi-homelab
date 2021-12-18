{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
    liveRestore = false; # Allow dockerd to be restarted without affecting running container. This option is incompatible with docker swarm.
  };
}
