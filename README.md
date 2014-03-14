# Fucking Shell Scripts

The easiest, most common sense server configuration management tool...because you just use fucking shell scripts.

Completely confused by Chef?  Blowing your brains out over Ansible?  Lost control of your puppets?  Wanna just use **fucking shell scripts** to configure a server? Read on!

# Features

*   Wraps up the fog gem, so it can be used on any cloud service, including AWS, rackspace, etc.
*   We've intentionally designed this tool to be insanely easy to use

### Step 0: Install the gem

```Shell
gem install fucking_shell_scripts
```


### Step 1: Create a project directory

```Shell
mkdir config_management
```

Folder structure:

*   `/servers` _(required)_ - yaml server definitions _(see example below)_

*   `/scripts` _(required)_ - the shell scripts that will configure your servers _(see example below)_

*   `/files` _(optional)_ - files to be transferred to servers _(nginx.conf, ssh keys, database.yml, etc.)_

An example folder structure:

```Shell
./config_management
├── files
│   ├── keys
│   │   └── deploy_key
│   └── rails_config
│       └── database.yml
├── scripts
│   ├── apt.sh
│   ├── deploy_key.sh
│   ├── git.sh
│   ├── redis.sh
│   ├── ruby2.sh
│   ├── rubygems.sh
│   ├── search_service_code.sh
│   └── search_service_env.sh
└── servers
    ├── defaults.yml
    └── search-service.yml
```


### Step 2: Create a server definition file

The server definition file defines how to build a type of server. Server definitions override settings in `defaults.yml`.

```YAML
# servers/search-server.yml
##################################################
# This file defines how to build our search server
##################################################

name: search-server
size: c1.xlarge
availability_zone: us-east-1d
image: ami-90374bf9
key_name: pd-app-server
private_key_path: /Users/yourname/.ssh/pd-app-server
security_groups: search-service  # override the security_groups defined in defaults.yml

############################################
# Files necessary to build the search server
############################################

files:
  - files/keys/deploy_key

###########################################
# Scripts needed to build the search server
###########################################

scripts:
  - scripts/apt.sh
  - scripts/search_service_env.sh
  - scripts/git.sh
  - scripts/ruby2.sh
  - scripts/rubygems.sh
  - scripts/redis.sh
  - scripts/deploy_key.sh
```

`servers/defaults.yml`has the same structure and keys a server definition file, **except**, you cannot define scripts or files.

```YAML
# servers/defaults.yml
################################
# This file defines our defaults
################################

security_groups: simple-group
size: c1.medium
image: ami-e76ac58e
availability_zone: us-east-1d
key_name: global-key
cloud:
  provider: AWS
  aws_access_key_id: <=% ENV[AWS_ACCESS_KEY] %>
  aws_secret_access_key: <%= ENV[AWS_SECRET_ACCESS_KEY] %>
  region: us-east-1

```

#### Cloud options

Anything passed in the 'cloud' key will be directly passed to
`Fog::Compute.new`.  See [the fog website](http://fog.io/compute) for more info.

FSS will consider any values that look like "ENV[VAR_NAME]" to be
environment variables, and will attempt to look up that environment
variable. If FSS does not find that variable, an exception will be
raised.

### Step 3: Add shell scripts that configure the server

Seriously...just write shell scripts.

Want to install Ruby 2? Here's an example:

```Shell
#!/bin/sh
#
# scripts/ruby2.sh
#
sudo apt-get -y install build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev
cd /tmp
wget http://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p247.tar.gz
tar -xzf ruby-2.0.0-p247.tar.gz
cd ruby-2.0.0-p247
./configure --prefix=/usr/local
make
sudo make install
rm -rf /tmp/ruby*
```

### Step 4: Build/configure your server

```Shell
fss search-service
```

This command does 2 things:

1.  Builds the new server
2.  Runs the scripts configuration

**To build only:**

```Shell
fss --build search-service
```

**To configure only:**

```Shell
fss --instance-id i-9ad6d7af --configure search-service
```

_Note: `--instance-id`is required when using the `--configure` option_


### Step 5: Remove your chef repo and all its contents.

```Shell
rm -rf ~/old_config_management/chef
```

**HOLY SHIT! THAT WAS EASY.**

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
