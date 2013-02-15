freight = data_bag_item("freight", "main")

template "#{node[:apache][:dir]}/sites-available/apt_repo.conf" do
    source "apt_repo.conf.erb"
    mode 0644
    owner "root"
    group "root"
    variables(
        :email => freight["pgp"]["email"],
        :fqdn => freight["fqdn"],
        :hostname => freight["hostname"]
    )
end

apache_site "apt_repo.conf"

apache_site "000-default" do
  enable false
end