{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  users.enforceIdUniqueness = true;

  users.users.nuc = {
    isNormalUser = true;
    uid = 1026;
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keyFiles = [
      ./keys/nuc-1.pub
    ];
    shell = pkgs.zsh;
  };

  # home-manager.users.nuc = { }
}
