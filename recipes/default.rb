 # Cookbook Name:: freight
 # Recipe:: default
 #
# Copyright 2012, Maciej Pasternacki
# Copyright 2013, AFA Insurance
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

freight = data_bag_item("freight", "main")

execute "build-freight_cache" do
    command "/usr/bin/freight-cache"
    action :nothing
end

apt_repository "rcrowley_freight" do
    uri "http://packages.rcrowley.org/"
    distribution node['lsb']['codename']
    components ["main"]
    key "http://packages.rcrowley.org/keyring.gpg"
end

execute "apt-get update" do
    action :run
end

package "freight"

execute "import packaging key" do
    command "/bin/echo -e '#{freight["pgp"]["private_key"]}' | gpg --import -"
    user "root"
    cwd "/root"
    not_if "gpg --list-secret-keys --fingerprint #{freight["pgp"]["email"]} | egrep -qx '.*Key fingerprint = #{freight["pgp"]["fingerprint"]}'"
end

template "/etc/freight.conf" do
    source "freight.conf.erb"
    mode "0644"
    user "root"
    group "root"
    variables(
        :email => freight["pgp"]["email"]
    )
    notifies :run, "execute[build-freight_cache]", :immediately
end