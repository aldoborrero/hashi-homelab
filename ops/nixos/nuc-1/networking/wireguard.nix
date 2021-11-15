{ config, pkgs, ... }:

{
  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "192.168.3.0/24" ];
      listenPort = 51820;
      privateKeyFile = "/etc/wireguard/server";
      postUp = ''
        ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 192.168.3.0/24 -o eno1 -j MASQUERADE
      '';
      preDown = ''
        ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 192.168.3.0/24 -o eno1 -j MASQUERADE
      '';
      peers = [
        {
          # iPhone
          publicKey = "irBxyF40Y41wPGW9Hu9jLVOaefXG9ynFAbx0m+UScQo=";
          presharedKeyFile = "/etc/wireguard/clients/iphone.psk";
          allowedIPs = [ "192.168.3.10/32" ];
        }
        {
          # Galaxy Z Flip
          publicKey = "8FvCx7DM9UJTAN3bd1nl1bq3FAetMjO2E/qReUJZbyI=";
          presharedKeyFile = "/etc/wireguard/clients/galaxy_z_flip.psk";
          allowedIPs = [ "192.168.3.15/32" ];
        }
        {
          # Galaxy S7 Tab
          publicKey = "Oz27wanB8Js46UmuBhZr03yYTLmMShzkTikKCU1lxS8=";
          presharedKeyFile = "/etc/wireguard/clients/galaxy_s7_tab.psk";
          allowedIPs = [ "192.168.3.20/32" ];
        }
        {
          # ThinkPad X1 Extreme
          publicKey = "/2TNHJBzi+Zkcq8w8aZFXqrFqyB6Ii8HgDbuNMC7onM=";
          presharedKeyFile = "/etc/wireguard/clients/thinkpad_x1.psk";
          allowedIPs = [ "192.168.3.25/32" ];
        }
        {
          # MacBook Pro
          publicKey = "oQI4QtEf0wsJ9qSlpSMvld2Olqv7R5IQjllD0j/8TAM=";
          presharedKeyFile = "/etc/wireguard/clients/macbook_pro.psk";
          allowedIPs = [ "192.168.3.30/32" ];
        }
      ];
    };
  };
}
