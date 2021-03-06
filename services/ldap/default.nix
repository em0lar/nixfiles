{ config, pkgs, ... }:

{
  em0lar.secrets = {"ldap/root_password".owner = "openldap"; };

  services.openldap = {
    enable = true;
    settings = {
      attrs = {
        objectClass = "olcGlobal";
        cn = "config";
        olcPidFile = "/run/slapd/slapd.pid";
      };
      children = {
        "cn=schema" = {
          attrs = {
            cn = "schema";
            objectClass = "olcSchemaConfig";
          };
          includes = [
          "${pkgs.openldap}/etc/schema/core.ldif"
          "${pkgs.openldap}/etc/schema/cosine.ldif"
          "${pkgs.openldap}/etc/schema/inetorgperson.ldif"
          "${pkgs.openldap}/etc/schema/nis.ldif"
          ];
        };
        "olcDatabase={-1}frontend" = {
          attrs = {
            objectClass = [
              "olcDatabaseConfig"
              "olcFrontendConfig"
            ];
            olcDatabase = "{-1}frontend";
            olcAccess = [
              "{0}to * by dn.exact=gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth manage by * break"
              "{1}to dn.exact=\"\" by * read"
              "{2}to dn.base=\"cn=Subschema\" by * read"
            ];
          };
        };
        "olcDatabase={0}config" = {
          attrs = {
            objectClass = "olcDatabaseConfig";
            olcDatabase = "{0}config";
            olcAccess = [ "{0}to * by * none break" ];
          };
        };
        "olcDatabase={1}mdb" = {
          attrs = {
            objectClass = [ "olcDatabaseConfig" "olcMdbConfig" ];
            olcDatabase = "{1}mdb";
            olcDbDirectory = "/var/db/ldap";
            olcSuffix = "dc=em0lar,dc=dev";
            olcRootDN = "cn=root,dc=em0lar,dc=dev";
            olcRootPW = {
              path = config.em0lar.secrets."ldap/root_password".path;
            };
            olcAccess = [
              "{0}to attrs=userPassword
                by anonymous auth
                by self write
                by * none"
              "{1}to *
                by dn.children=\"ou=services,dc=em0lar,dc=dev\" write
                by self read by * none"
            ];
          };
        };
      };
    };
  };
}
