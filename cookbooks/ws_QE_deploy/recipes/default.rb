#
# Cookbook Name:: ws_QE_deploy
# Recipe:: default
#
# Copyright 2013, Genesys, Angel.com
#

yum_package "angel-vcc-web-service" do
    action :purge
    flush_cache [:after]
end

execute "clean_yum_cache" do
    command "yum clean all"
    action :nothing
end

yum_package "angel-vcc-web-service" do
    action :install
    flush_cache [:before]
end

template "/usr/local/angel/service/vcc_web_service/app/config/CONFIG.json" do
    source "CONFIG.json.erb"
    owner "root"
    group "root"
    mode "644"
    variables( :central_server_ip => node[:central_server_ip],
               :standby_central_server_ip => node[:standby_central_server_ip],
               :ws_ip => node[:ipaddress]
             )
end

service "angel_vcc_ws" do
    action [:enable, :start ]
end
