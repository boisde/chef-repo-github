#
# Cookbook Name:: vcc_QE_deploy
# Recipe:: ws_QE_deploy
#
# Copyright 2013, Genesys, Angel.com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

execute "clean_yum_cache" do
    command "yum clean all"
    action :nothing
end

yum_package "angel-vcc-web-service" do
    action :install
    flush_cache [:before]
end

template "/usr/local/angel/service/vcc_web_service/app/config/CONFIG.json" do
    source "ws_CONFIG.json.erb"
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
