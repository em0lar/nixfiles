{ helper, dns, config, lib, ... }:

{
  zone = with dns.lib.combinators; {
    TTL = 3600;
    SOA = ((ttl 600) {
      nameServer = "ns1.em0lar.dev.";
      adminEmail = "noc@labcode.de";
      serial = 2021061101;
      refresh = 3600;
      expire = 604800;
      minimum = 600;
    });

    NS = helper.ns;

    A = helper.hosts.web.A;
    AAAA = helper.hosts.web.AAAA;

    MX = helper.mail.mxSimple;
    TXT = [
      helper.mail.spf
    ];
    DMARC = helper.mail.dmarc;

    CAA = helper.caa;
    subdomains = {
      www.CNAME = [ "foros.int.sig.de.em0lar.dev." ];
      "*".A = [ "162.55.82.116" ];
    };
  };
}
