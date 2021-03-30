{ config, pkgs, modulesPath, ... }:

{
  imports = [
      "${modulesPath}/virtualisation/lxc-container.nix"
      ./wireguard.nix
      ./network.nix
      ../../common
      ../../services/gitea
      ../../services/hedgedoc
      ../../services/matrix
  ];

  em0lar = {
    secrets = {
      "backup_ssh_key".owner = "root";
      "backup_passphrase".owner = "root";
    };
    backups = {
      enable = true;
      repo = "backup@helene.lan.int.sig.de.em0lar.dev:/mnt/backup/repos/synced/beryl.int.sig.de.em0lar.dev";
    };
    telegraf = {
      enable = true;
      host = "[fd8f:d15b:9f40:102:5c52:b6ff:fee2:db4d]";
    };
  };
}
