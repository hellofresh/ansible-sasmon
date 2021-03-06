# Ansible samson Role

`ansible-samson` is an ansible role to install and manage samson .


## Overview
This role installs and manages [Zendesk samson](https://github.com/zendesk/samson)

Requirements
------------

 - Ansible 2.X 
 
Dependencies
-----------
* Ubuntu 12.04 or 14.04 ( Can work with other distros with minor adjustments)
* ruby 2.1 and bundler. We suggest [offical rvm role](https://github.com/rvm/rvm1-ansible)
* npm. We suggest [stouts node](https://github.com/Stouts/Stouts.nodejs)


Role Variables
--------------
```yaml
## By default will use master, but its a good idea to pin a version
samson_version              : "master" 
## Database configuration (default will use sqlite you can configure mysql or postgresql)
samson_database             :
                                development :
                                  adapter   : sqlite3
                                  database  : db/development.sqlite3
                                  pool      : 5
                                  timeout   : 5000
                                production  :
                                  adapter   : sqlite3
                                  database  : db/production.sqlite3
                                  pool      : 5
                                  timeout   : 5000
## Samson plugins to install
samson_plugins              : "all,-slack"

## Samson github auth setting
# USED FOR DEMONSTRATION MUST BE OVERWRITEN
samson_secret_token         : "e3711c777b49a9ba6f4cd44539f4c677e76f7c08c346875e50b11119c61839d385b2709f1fd8ac2d899b32dc818d1459b265cff91f6dcc635406a473cd903f4a"
samson_github_client_id     : "875f73cad3b230a8bf94"
samson_github_secret        : "ab5aa3d6f86e04a8026d36f03d8c0742f9f948d8"
samson_github_token         : "f8a52fb5411511fb7b93b9729794dc753e6bafae"
samsoin_auth_ldap           : 0

## Samson URL,bind and ports
samson_url                  : "http://localhost:{{ samson_puma_port }}"
samson_puma_bind            : "0.0.0.0"
samson_puma_port            : 3000

## dependecies to install git, mysql and postgres stuff 
samson_apt_dependecies      :
                                - git
                                - libgmp3-dev
                                - libmysqlclient-dev
                                - libpq-dev
samson_environment_name     : "production"

## Samson Directory
samson_home_dir             : "/opt/samson"
samson_deploy_dir           : "{{ samson_home_dir }}/{{ samson_version }}"
samson_log_dir              : "/var/log/samson"
samson_log_file             : "/var/log/samson/samson.log"

## Samson user
samson_user                 : "samson"
samson_group                : "samson"
```

License
-------
MIT


Contributors (sorted alphabetically on the first name)
------------------
* [Adham Helal](https://github.com/ahelal)

