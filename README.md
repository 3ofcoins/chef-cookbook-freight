Description
===========

This cookbook installs Freight, a modern take on the Debian archive.
See https://github.com/rcrowley/freight for more details

This cookbook is maintained at
https://github.com/3ofcoins/chef-cookbook-freight/

Requirements
============

* apt


Recipes
=======

 * `freight` -- adds Apt repository and installs Freight
 * `freight::server` -- configures a system user with GPG key and
   freight config + directories in /srv/freight/
