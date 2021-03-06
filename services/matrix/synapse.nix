{ lib, config, pkgs, ... }:

{
  em0lar.secrets."matrix/synapse-secrets.yaml".owner = "matrix-synapse";
  em0lar.secrets."matrix/synapse-homeserver.signing.key".owner = "matrix-synapse";

  services.postgresql = {
    enable = true;
    ensureUsers = [
      { name = "matrix-synapse"; }
    ];
    initialScript = pkgs.writeText "synapse-init.sql" ''
      CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
       ENCODING 'UTF8'
       TEMPLATE template0
       LC_COLLATE = "C"
       LC_CTYPE = "C";
    '';
  };

  users.users.matrix-synapse.extraGroups = [ "mautrix-telegram" ];

  services.matrix-synapse = {
    enable = true;
    enable_registration = false;

    server_name = "labcode.de";
    public_baseurl = "https://matrix.labcode.de:443/";

    database_type = "psycopg2";
    database_args = {
      database = "matrix-synapse";
    };

    listeners = [
      {
        bind_address = "::1";
        port = 8008;
        resources = [
          { names = [ "client" ]; compress = true; }
          { names = [ "federation" ]; compress = false; }
        ];
        type = "http";
        tls = false;
        x_forwarded = true;
      }
    ];

    app_service_config_files = [
      "/var/lib/mautrix-telegram/telegram-registration.yaml"
    ];

    extraConfigFiles = [
      config.em0lar.secrets."matrix/synapse-secrets.yaml".path
    ];

    url_preview_enabled = false;

    turn_uris = [
      "turn:turn.labcode.de:3478?transport=udp"
      "turn:turn.labcode.de:3478?transport=tcp"
    ];
    logConfig = ''
      version: 1
      formatters:
        precise:
          format: '%(asctime)s - %(name)s - %(lineno)d - %(levelname)s - %(request)s - %(message)s'
      filters:
        context:
          (): synapse.util.logcontext.LoggingContextFilter
          request: ""
      handlers:
        console:
          class: logging.StreamHandler
          formatter: precise
          filters: [context]
      loggers:
        synapse:
          level: WARNING
        synapse.storage.SQL:
          # beware: increasing this to DEBUG will make synapse log sensitive
          # information such as access tokens.
          level: WARNING
      root:
        level: WARNING
        handlers: [console]
    '';
  };

  systemd.services.matrix-synapse.serviceConfig.ExecStartPre = [
    "${pkgs.coreutils}/bin/ln -sf ${config.em0lar.secrets."matrix/synapse-homeserver.signing.key".path} ${config.services.matrix-synapse.dataDir}/homeserver.signing.key"
  ];

  services.nginx.virtualHosts."matrix.labcode.de" = {
    forceSSL = true;
    enableACME = true;
    locations = {
      "/" = {
        proxyPass = "http://[::1]:8008";
      };
    };
  };
}
