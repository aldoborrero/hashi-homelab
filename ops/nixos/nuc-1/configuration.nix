{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./nix
    ./services
    ./networking
    ./filesystems
    ./users/nuc.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  environment.systemPackages = with pkgs; [
    bind
    curl
    docker-compose
    ffmpeg-full
    git
    handbrake
    htop
    mkcert
    neovim
    psmisc
    pwgen
    qrencode
    unzip
    wget
    wireguard
    wireguard-tools
  ];

  time.timeZone = "Europe/Madrid";

  i18n.defaultLocale = "en_US.UTF-8";

  system = {
    stateVersion = "21.05";
    autoUpgrade.enable = true;
    autoUpgrade.allowReboot = true;
  };
}
