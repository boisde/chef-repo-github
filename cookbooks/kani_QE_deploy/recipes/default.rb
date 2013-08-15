#
# Cookbook Name:: kani_QE_deploy
# Recipe:: default
#
# Copyright 2013, Genesys, Angel.com
#

yum_package "angel-kani" do
    action :purge
    flush_cache [:after]
end

execute "clean_yum_cache" do
    command "yum clean all"
    action :nothing
end

yum_package "angel-kani" do
    action :install
    flush_cache [:before]
end

template "/usr/local/angel/service/kani/conf/kani_config.json" do
    source "kani_config.json.erb"
    owner "root"
    group "root"
    mode "644"
    variables( :central_server_ip => node[:central_server_ip],
               :standby_central_server_ip => node[:standby_central_server_ip],
               :kani_sip_stack_ip => node[:ipaddress],
               :kani_sip_gateway_ip => node[:kani_sip_gateway_ip],
               :kani_holly_ip => node[:kani_holly_ip]
             )
    notifies :restart, "service[angel_kani]"
end

service "angel_kani" do
    action [:start, :stop, :restart]
end
