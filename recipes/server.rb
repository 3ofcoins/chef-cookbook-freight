include_recipe "freight::default"

node.default['freight']['key_email'] ||= "freight@#{node['fqdn']}"

group "freight"
user "freight" do
  system true
  group "freight"
  home "/srv/freight"
end

directory "/srv/freight" do
  owner "freight"
  group "freight"
  mode "0755"
end

package "gnupg"

file "#{Chef::Config[:file_cache_path]}/freight-key-spec.txt" do
  content <<EOF
Key-Type: 1
Key-Length: 2048
Name-Real: #{node['freight']['key_real_name']}
Name-Email: #{node['freight']['key_email']}
Expire-Date: 0   
EOF
end

execute "generate-freight-gpg-key" do
  command "gpg --gen-key --batch < #{Chef::Config[:file_cache_path]}/freight-key-spec.txt"
  user 'freight'
  group 'freight'
  environment "HOME" => '/srv/freight'
  not_if { File.exist?('/srv/freight/.gnupg') }
end

ruby_block "save-freight-gpg-key" do
  block do
    node.set['freight']['public_gpg_key'] = `sudo -u apt-repo -H gpg --export --armor`
  end
end

execute "freight init" do
  command "freight init --gpg=#{node['freight']['key_email']} --conf=/srv/freight/freight.conf --libdir=/srv/freight/lib --cachedir=/srv/freight/cache #{node['freight']['init_args']}"
  user 'freight'
  group 'freight'
  environment 'HOME' => '/srv/freight'
  creates '/srv/freight/freight.conf'
end
