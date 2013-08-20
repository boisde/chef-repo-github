#
# Cookbook Name:: angel_vcc2.0
# Recipe:: kani_QE_deploy
#
# Copyright 2013, Genesys, Angel.com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

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
    variables( :central_server_ip => node[:kani_central_server_ip],
               :standby_central_server_ip => node[:kani_standby_central_server_ip],
               :kani_sip_stack_ip => node[:ipaddress],
               :kani_sip_gateway_ip => node[:kani_sip_gateway_ip],
               :kani_holly_ip => node[:kani_holly_ip]
             )
    notifies :restart, "service[angel_kani]"
end

service "angel_kani" do
    action [:restart]
end
