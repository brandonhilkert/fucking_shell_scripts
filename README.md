# FuckingShellScripts

The easiest, most common sense configuration management tool... because you just use fucking shell scripts.

## Installation

    $ gem install fucking_shell_scripts

## Development

During development of a script, use vagrant:

    vagrant up
    cd /vagrant

`cd /vagrant` will put you in the root folder of the project so that you can run a script such as `./search-service.sh`.

## Servers

### Defaults

Server defaults are defined by creating the following file:

`./servers/defaults.yml`

```yaml
name: ppd instance
security_groups: pd-app-server
instance_type: c1.xlarge
image_id: ami-e76ac58e
availability_zone: us-east-1d
region: us-east-1
key_name: pd-app-server
private_key_path: /Users/bhilkert/.ssh/pd-app-server
```

To define a server, create a yaml file in the `./servers` directory with the following format:

`./servers/search-service.yml`

```yaml
name: search-service
security_groups: search-service
instance_type: c1.medium
image_id: ami-90374bf9

scripts:
  - scripts/apt.sh
  - scripts/env.sh
  - scripts/git.sh
  - scripts/ruby.sh
  - scripts/rubygems.sh
  - scripts/redis.sh
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
