# log4r-sequel
Log4r outputter to a Sequel database handle

## usage

### pre-built gem installation (stable)

[![Gem Version](https://badge.fury.io/rb/log4r-sequel.png)](https://rubygems.org/gems/log4r-sequel)

```sh
gem install log4r-sequel
irb
...
irb(main):001:0> require 'log4r/outputter/sequeloutputter'
=> true
irb(main):002:0> logger = Log4r::Logger.new('foo')
=> #<Log4r::Logger:0x007f889b056df8 @fullname="foo" ...>
```


### from-source installation (latest)

[![build status](https://travis-ci.org/chorankates/log4r-sequel.svg)](https://travis-ci.org/chorankates/log4r-sequel)

```sh
git clone https://github.com/chorankates/log4r-sequel.git
cd log4r-sequel
rake clean build
gem install --local pkg/log4r-sequel*.gem
irb
...
irb(main):001:0> require 'log4r/outputter/sequeloutputter'
=> true
```

## supported databases
  * sqlite3
  * Postgres
  
## TODO
  * allow database name to be semi-dynamically generated - via YAML config, not just by passing the hash directly
  * tests
    * unit tests
  * marketing
    * screencast / sample output in README.md