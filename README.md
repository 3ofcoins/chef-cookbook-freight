freight Cookbook
================
This cookbook installs Freight, a modern take on the Debian archive. See https://github.com/rcrowley/freight for more details


Requirements
------------
#### packages
Apache2  (*optional*)

### cookbooks
apt
apache2(optional)


Attributes
-----------
See `attributes/default.rb` for default values.
You can over-ride both the paths to your freight `cache` and `lib` folders along with repository information like `origin` and `label`.


Usage
-----
Create a databag containing the following (<> denotes a placeholder value you won't need these characters in your databag)
Mame this databag `freight`. The recipe uses the `main` data bag item.

{
  "id": "main",
  "fqdn": "apt.chef.local",
  "hostname": "debs.chef.local",
  "pgp": {
    "email": "user@tld.com",
    "fingerprint": "<GPG finger print>",
    "public_key": "<GPG Public Key>",
    "private_key": "<GPG Private Key>"
  }
}


* `fqdn`: the fully qualified domain name of the apt server, used in
  in the Apache vhost template and as the Origin in the distributions
  configuration. Also saved to the node as
  `node['freight']['fqdn']`.
* `hostname`: all other hostnames you'd like to allow access from (ServerAlias)
* `pgp`: hash of options for the pgp setup. the 
* `pgp['email']`: email address of the signing key
* `pgp['fingerprint']`: fingerprint of the PGP key
* `pgp['public_key']`: the public PGP key, should be a single line
  (replace line endings with \n)
* `pgp['private_key']`: the private PGP key, should be a single line
  (replace line endings with \n)

#### freight::default
Just include `freight` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[freight]"
  ]
}
```

If you'd like to use this with apache then you should will need to include both the apache2 cookbook and the freight::apache recipe

License and Authors
-------------------
Authors: Maciej Pasternacki & Mathew Brennan (AFA Insurance pty ltd).
