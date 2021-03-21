{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./wireguard.nix
      ../../common
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "haku";
  networking.domain = "pbb.wob.de.em0lar.dev";
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = true;
  boot.kernel.sysctl."net.ipv4.conf.all.forwarding" = true;

  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  networking.useHostResolvConf = false;
  system.stateVersion = "20.09";

  em0lar = {
    secrets = {
      "backup_ssh_key".owner = "root";
      "backup_passphrase".owner = "root";
    };
    backups = {
      enable = true;
      repo = "backup@helene.int.sig.de.labcode.de:/mnt/backup/repos/synced/haku.pbb.wob.de.em0lar.dev";
    };
  };
}


