{ ... }:

{
  networking.hostName = "foros";
  networking.domain = "int.sig.de.em0lar.dev";
  systemd.network = {
    links."10-eth0" = {
      matchConfig.MACAddress = "2e:5a:56:4f:e4:c4";
      linkConfig.Name = "eth0";
    };
    networks."10-eth0" = {
      DHCP = "yes";
      matchConfig = {
        Name = "eth0";
      };
      routes = [
        {
          routeConfig = {
            Destination = "10.151.0.0/16";
            Gateway = "_dhcp4";
          };
        }
        {
          routeConfig = {
            Destination = "fd8f:d15b:9f40::/48";
            Gateway = "_ipv6ra";
          };
        }
      ];
    };
  };
  networking.useHostResolvConf = false;
  em0lar.nftables.checkIPTables = false;
}
