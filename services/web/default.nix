{ ... }:

{
  services.nginx.virtualHosts = {
    "auth.em0lar.de" = {
      enableACME = true;
      forceSSL = true;
      serverAliases = [
        "auth.emolar.de"
        "auth.labcode.de"
      ];
      locations."/" = {
        extraConfig = "return 301 https://auth.em0lar.dev$request_uri;";
      };
    };
    "auth.em0lar.dev" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://phoebe.lan.int.sig.de.em0lar.dev:8080";
    };
    "md.em0lar.dev" = {
      enableACME = true;
      forceSSL = true;
      serverAliases = [
        "md.emolar.de"
        "md.labcode.de"
      ];
      locations."/" = {
        extraConfig = "return 301 https://md.em0lar.de$request_uri;";
      };
    };
    "md.em0lar.de" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://hyperion.lan.int.sig.de.em0lar.dev:40001";
    };
    "matrix.labcode.de" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "https://matrix.labcode.de";
    };
  };
}