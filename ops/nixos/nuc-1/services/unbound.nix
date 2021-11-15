{ config, pkgs, ... }:

{
  services.unbound = {
    enable = true;
    enableRootTrustAnchor = true;
    settings = {
      server = {
        # log verbosity
        verbosity = 1;

        # default interface to listen
        interface = "0.0.0.0";
        port = 53;

        # control which client ips are allowed to make (recursive) queries to this
        # server. Specify classless netblocks with /size and action.  By default
        # everything is refused, except for localhost.  Choose deny (drop message),
        # refuse (polite error reply), allow (recursive ok), allow_snoop (recursive
        # and nonrecursive ok)
        access-control = [
          "0.0.0.0/0 allow"
          "::0/0 allow"
        ];

        # Enforce privacy of these addresses. Strips them away from answers.  It may
        # cause DNSSEC validation to additionally mark it as bogus.  Protects against
        # 'DNS Rebinding' (uses browser as network proxy).  Only 'private-domain' and
        # 'local-data' names are allowed to have these private addresses. No default.
        private-address = [
          "10.0.0.0/8"
          "127.0.0.0/8"
          "172.16.0.0/12"
          # "192.168.0.0/16"
          "fd00::/8"
          "fe80::/10"
        ];

        # Enable IPv4
        do-ip4 = "yes";

        # Enable IPv6
        do-ip6 = "yes";

        # Enable UDP
        do-udp = "yes";

        # Enable TCP
        do-tcp = "yes";

        # number of threads to create.
        num-threads = 1;

        # the number of slabs to use for cache and must be a power of 2 times the
        # number of num-threads set above. more slabs reduce lock contention, but
        # fragment memory usage.
        msg-cache-slabs = 2;
        infra-cache-slabs = 2;
        key-cache-slabs = 2;
        rrset-cache-slabs = 2;

        # Increase the memory size of the cache. Use roughly twice as much rrset cache
        # memory as you use msg cache memory. Due to malloc overhead, the total memory
        # usage is likely to rise to double (or 2.5x) the total cache memory.
        rrset-cache-size = "256m";
        msg-cache-size = "128m";
        key-cache-size = "32m";

        # If yes, Unbound rotates RRSet order in response (the random num-
        # ber is taken from the query ID, for speed  and  thread  safety).
        rrset-roundrobin = "yes";

        # the time to live (TTL) value lower bound, in seconds. Default 0.
        # If more than an hour could easily give trouble due to stale data.
        cache-min-ttl = 3600;

        # the time to live (TTL) value cap for RRsets and messages in the
        # cache. Items are not cached for longer. In seconds.
        cache-max-ttl = 86400;

        # perform prefetching of close to expired message cache entries.  If a client
        # requests the dns lookup and the TTL of the cached hostname is going to
        # expire in less than 10% of its TTL, unbound will (1st) return the ip of the
        # host to the client and (2nd) pre-fetch the dns request from the remote dns
        # server. This method has been shown to increase the amount of cached hits by
        # local clients by 10% on average.
        prefetch = "yes";

        # If  yes,  fetch  the  DNSKEYs earlier in the validation process,
        # when a DS record is encountered.  This lowers the latency of re-
        # quests.   It  does  use a little more CPU.  Also if the cache is
        # set to 0, it is no use. Default is no.
        prefetch-key = "yes";

        # If  yes,  Unbound  does not insert authority/additional sections
        # into response messages when those  sections  are  not  required.
        # This  reduces  response  size  significantly,  and may avoid TCP
        # fallback for some responses.  This may cause a  slight  speedup.
        # The  default  is  yes, even though the DNS protocol RFCs mandate
        # these sections, and the additional content could be of  use  and
        # save roundtrips for clients.  Because they are not used, and the
        # saved roundtrips are easier saved with prefetch, whilst this  is
        # faster.
        minimal-responses = "yes";

        # enable to not answer id.server and hostname.bind queries.
        hide-identity = "yes";

        # enable to not answer version.server and version.bind queries.
        hide-version = "yes";

        # Aggressive  NSEC  uses the DNSSEC NSEC chain to synthesize NXDO-
        # MAIN and other denials, using information  from  previous  NXDO-
        # MAINs  answers.   Default  is  no.  It helps to reduce the query
        # rate towards targets that  get  a  very  high  nonexistent  name
        # lookup rate.
        aggressive-nsec = "yes";

        # Use 0x20-encoded random bits in the query to foil spoof attempts.
        # http://tools.ietf.org/html/draft-vixie-dnsext-dns0x20-00
        # While upper and lower case letters are allowed in domain names, no significance
        # is attached to the case. That is, two names with the same spelling but
        # different case are to be treated as if identical. This means calomel.org is the
        # same as CaLoMeL.Org which is the same as CALOMEL.ORG.
        use-caps-for-id = "yes";

        # Will trust glue only if it is within the servers authority.
        # Harden against out of zone rrsets, to avoid spoofing attempts.
        # Hardening queries multiple name servers for the same data to make
        # spoofing significantly harder and does not mandate dnssec.
        harden-glue = "yes";

        # Require DNSSEC data for trust-anchored zones, if such data is absent, the
        # zone becomes  bogus.  Harden against receiving dnssec-stripped data. If you
        # turn it off, failing to validate dnskey data for a trustanchor will trigger
        # insecure mode for that zone (like without a trustanchor).  Default on,
        # which insists on dnssec data for trust-anchored zones.
        harden-dnssec-stripped = "no";

        # Harden the referral path by performing  additional  queries  for
        # infrastructure data.  Validates the replies if trust anchors are
        # configured and the zones are signed.  This enforces DNSSEC vali-
        # dation  on  nameserver NS sets and the nameserver addresses that
        # are encountered on the referral path to the answer.  Default no,
        # because  it  burdens  the  authority  servers, and it is not RFC
        # standard, and could lead to performance problems because of  the
        # extra  query  load  that is generated.  Experimental option.  If
        # you enable it  consider  adding  more  numbers  after  the  tar-
        # get-fetch-policy to increase the max depth that is checked to.
        harden-referral-path = "no";

        # Harden  against algorithm downgrade when multiple algorithms are
        # advertised in the DS record.  If no, allows  the  weakest  algo-
        # rithm  to  validate the zone.  Default is no.  Zone signers must
        # produce zones that allow this feature  to  work,  but  sometimes
        # they  do not, and turning this option off avoids that validation
        # failure.
        harden-algo-downgrade = "yes";

        # From RFC 8020 (with title "NXDOMAIN: There Really Is Nothing Un-
        # derneath"), returns nxdomain to queries for a name below another
        # name  that is already known to be nxdomain.  DNSSEC mandates no-
        # error for empty nonterminals, hence this is possible.  Very  old
        # software might return nxdomain for empty nonterminals (that usu-
        # ally happen for reverse IP address lookups), and thus may be in-
        # compatible  with  this.  To try to avoid this only DNSSEC-secure
        # nxdomains are used, because  the  old  software  does  not  have
        # DNSSEC.   Default  is  yes.   The  nxdomain must be secure, this
        # means nsec3 with optout is insufficient.
        harden-below-nxdomain = "yes";

        # Read  the  root  hints from this file. Default is nothing, using built in
        # hints for the IN class. The file has the format of  zone files,  with  root
        # nameserver  names  and  addresses  only. The default may become outdated,
        # when servers change,  therefore  it is good practice to use a root-hints
        # file. get one from https://www.internic.net/domain/named.root
        # root-hints = "/var/lib/unbound/root.hints";

        # speed tweaks
        # qname-minimisation = "yes";

        # Faster UDP with multithreading
        so-reuseport = "yes";

        # buffer size for UDP port 53 incoming (SO_RCVBUF socket option). This sets
        # the kernel buffer larger so that no messages are lost in spikes in the traffic.
        # so-rcvbuf = "1m";

        # buffer size for UDP port 53 outgoing. This sets
        # the kernel buffer larger so that no messages are lost in spikes in the traffic.
        # so-sndbuf = "1m";

        # If nonzero, unwanted replies are not only reported in statistics, but also
        # a running total is kept per thread. If it reaches the threshold, a warning
        # is printed and a defensive action is taken, the cache is cleared to flush
        # potential poison out of it. A suggested value is 10000000, the default is
        # 0 (turned off). We think 10K is a good value.
        unwanted-reply-threshold = 10000;

        # Should additional section of secure message also be kept clean of unsecure
        # data. Useful to shield the users of this validator from potential bogus
        # data in the additional section. All unsigned data in the additional section
        # is removed from secure messages.
        val-clean-additional = "yes";

        # IMPORTANT FOR TESTING: If you are testing and setup NSD or BIND  on
        # localhost you will want to allow the resolver to send queries to localhost.
        # Make sure to set do-not-query-localhost: yes . If yes, the above default
        # do-not-query-address entries are present. if no, localhost can be queried
        # (for testing and debugging).
        do-not-query-localhost = "no";
      };
      forward-zone = {
        name = ".";
        forward-tls-upstream = "yes";
        forward-addr = [
          "1.0.0.1@853#one.one.one.one"
          "1.1.1.1@853#one.one.one.one"
        ];
      };
    };
  };
}
