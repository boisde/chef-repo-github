#
# Cookbook Name:: vcc_QE_deploy
# Recipe:: rs_QE_deploy
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

yum_package "angel-vcc-reporting-service" do
    action :install
    flush_cache [:before]
end

template "/usr/local/angel/service/rs/vcc.reporting.service/WEB-INF/classes/ehcache.xml" do
    source "rs_ehcache.xml.erb"
    owner "root"
    group "root"
    mode "644"
    notifies :restart, "service[angel_vcc_reporting_service]"
end

template "/usr/local/angel/service/rs/vcc.reporting.service/WEB-INF/classes/hibernate.cfg.xml" do
    source "rs_hibernate.cfg.xml.erb"
    owner "root"
    group "root"
    mode "644"
    notifies :restart, "service[angel_vcc_reporting_service]"
end

service "angel_vcc_reporting_service" do
    action [:restart]
end
