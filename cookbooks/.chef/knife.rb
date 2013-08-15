log_level                :info
log_location             STDOUT
node_name                'root'
client_key               '/root/.chef/root.pem'
validation_client_name   'chef-validator'
validation_key           '/root/.chef/chef-validator.pem'
chef_server_url          'https://chefserver.little.blue.com'
syntax_check_cache_path  '/root/.chef/syntax_check_cache'

cookbook_copyright       'Genesys, Angel.com'
cookbook_email           'xinlu.chen@genesyslab.com'
cookbook_license         'apachev2'
cookbook_path            [
                         '/root/Development/chef-repo/cookbooks'
                         ]                        
