# docker-mailserver

Recommended:
- 1 CPU
- 1GB RAM

Minimum:
- 1 CPU
- 512MB RAM

**Note:** You'll need to deactivate some services like ClamAV to be able to run on a host with 512MB of RAM.

## Usage

#### Get latest image

    docker pull tvial/docker-mailserver:latest


#### Start Container
    docker-compose up -d mail

#### Create your mail accounts

    ./setup.sh email add <user@domain> [<password>]

#### Generate DKIM keys

    ./setup.sh config dkim

Now the keys are generated, you can configure your DNS server by just pasting the content of `config/opendkim/keys/domain.tld/mail.txt` in your `domain.tld.hosts` zone.

#### Restart the container

    docker-compose down
    docker-compose up -d mail

You're done!

And don't forget to have a look at the remaining functions of the `setup.sh` script


##### DOVECOT_PASS_FILTER

  - e.g. `(&(objectClass=PostfixBookMailAccount)(uniqueIdentifier=%n))`

##### DOVECOT_PASS_ATTR

- e.g. `uid=user,userPassword=password`
- => Specify the directory to dovecot variable mapping that fits your directory structure.
- Note: This is necessary for directories that do not use the [Postfix Book Schema](test/docker-openldap/bootstrap/schema/mmc/postfix-book.schema).
- Note: The left-hand value is the directory attribute, the right hand value is the dovecot variable.
- More details on the [Dovecot Wiki](https://wiki.dovecot.org/AuthDatabase/LDAP/PasswordLookups)

## Postgrey

##### ENABLE_POSTGREY

  - **0** => `postgrey` is disabled
  - 1 => `postgrey` is enabled

##### POSTGREY_DELAY

  - **300** => greylist for N seconds

Note: This postgrey setting needs `ENABLE_POSTGREY=1`

##### POSTGREY_MAX_AGE

  - **35** => delete entries older than N days since the last time that they have been seen

Note: This postgrey setting needs `ENABLE_POSTGREY=1`

##### POSTGREY_AUTO_WHITELIST_CLIENTS

  - **5** => whitelist host after N successful deliveries (N=0 to disable whitelisting)

Note: This postgrey setting needs `ENABLE_POSTGREY=1`

##### POSTGREY_TEXT

  - **Delayed by postgrey** => response when a mail is greylisted

Note: This postgrey setting needs `ENABLE_POSTGREY=1`

## SASL Auth

##### ENABLE_SASLAUTHD

  - **0** => `saslauthd` is disabled
  - 1 => `saslauthd` is enabled

##### SASLAUTHD_MECHANISMS

  - empty => pam
  - `ldap` => authenticate against ldap server
  - `shadow` => authenticate against local user db
  - `mysql` => authenticate against mysql db
  - `rimap` => authenticate against imap server
  - NOTE: can be a list of mechanisms like pam ldap shadow

##### SASLAUTHD_MECH_OPTIONS

  - empty => None
  - e.g. with SASLAUTHD_MECHANISMS rimap you need to specify the ip-address/servername of the imap server  ==> xxx.xxx.xxx.xxx

##### SASLAUTHD_LDAP_SERVER

  - empty => localhost

##### SASLAUTHD_LDAP_SSL

  - empty or 0 => `ldap://` will be used
  - 1 => `ldaps://` will be used

##### SASLAUTHD_LDAP_BIND_DN

  - empty => anonymous bind
  - specify an object with privileges to search the directory tree
  - e.g. active directory: SASLAUTHD_LDAP_BIND_DN=cn=Administrator,cn=Users,dc=mydomain,dc=net
  - e.g. openldap: SASLAUTHD_LDAP_BIND_DN=cn=admin,dc=mydomain,dc=net

##### SASLAUTHD_LDAP_PASSWORD

  - empty => anonymous bind

##### SASLAUTHD_LDAP_SEARCH_BASE

  - empty => Reverting to SASLAUTHD_MECHANISMS pam
  - specify the search base

##### SASLAUTHD_LDAP_FILTER

  - empty => default filter `(&(uniqueIdentifier=%u)(mailEnabled=TRUE))`
  - e.g. for active directory: `(&(sAMAccountName=%U)(objectClass=person))`
  - e.g. for openldap: `(&(uid=%U)(objectClass=person))`

##### SASL_PASSWD

  - **empty** => No sasl_passwd will be created
  - string => `/etc/postfix/sasl_passwd` will be created with the string as password

## SRS (Sender Rewriting Scheme)

##### SRS_EXCLUDE_DOMAINS

  - **empty** => Envelope sender will be rewritten for all domains
  - provide comma separated list of domains to exclude from rewriting

##### SRS_SECRET

  - **empty** => generated when the container is started for the first time
  - provide a secret to use in base64
  - you may specify multiple keys, comma separated. the first one is used for signing and the remaining will be used for verification. this is how you rotate and expire keys
  - if you have a cluster/swarm make sure the same keys are on all nodes
  - example command to generate a key: `dd if=/dev/urandom bs=24 count=1 2>/dev/null | base64`

##### SRS_DOMAINNAME

  - **empty** => Derived from OVERRIDE_HOSTNAME, DOMAINNAME, or the container's hostname
  - Set this if auto-detection fails, isn't what you want, or you wish to have a separate container handle DSNs

## Default Relay Host

#### DEFAULT_RELAY_HOST

  - **empty** => don't set default relayhost setting in main.cf
  - default host and port to relay all mail through

## Multi-domain Relay Hosts

#### RELAY_HOST

  - **empty** => don't configure relay host
  - default host to relay mail through

#### RELAY_PORT

  - **empty** => 25
  - default port to relay mail through

#### RELAY_USER

  - **empty** => no default
  - default relay username (if no specific entry exists in postfix-sasl-password.cf)

#### RELAY_PASSWORD

  - **empty** => no default
  - password for default relay user
