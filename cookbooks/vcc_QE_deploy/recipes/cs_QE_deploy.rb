#
# Cookbook Name:: angel_vcc2.0
# Recipe:: cs_QE_deploy
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

yum_package "angel-vcc-cs" do
    action :install
    flush_cache [:before]
end

template "/usr/local/angel/service/cs/vcc/WEB-INF/classes/conf/env.properties" do
    source "cs_env.properties.erb"
    owner "root"
    group "root"
    mode "644"
    variables( :central_server_ip => node[:ipaddress],
               :standby_central_server_ip => node[:cs_standby_central_server_ip],
               :sb_hessian_ip => node[:sb_hessian_ip],
               :reporting_hessian_ip => node[:reporting_hessian_ip],
               :angel_call_ip => node[:angel_call_ip],
               :holly_ip => node[:holly_ip],
               :sound_file_host_ip => node[:sound_file_host_ip],
               :mail_smtp_ip => node[:mail_smtp_ip],
               :reporting_enabled => node[:reporting_enabled]
             )
    notifies :restart, "service[angel_cs]"
end

template "/usr/local/angel/service/cs/vcc/WEB-INF/classes/ehcache.xml" do
    source "cs_ehcache.xml.erb"
    owner "root"
    group "root"
    mode "644"
    variables( :central_server_ip => node[:ipaddress],
               :standby_central_server_ip => node[:cs_standby_central_server_ip]
             )
    notifies :restart, "service[angel_cs]"
end

service "angel_cs" do
    action [:restart]
end
