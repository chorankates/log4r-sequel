# log4r-sequel
Log4r outputter to a Sequel database handle

## usage

### from-source installation (latest)

[![build status](https://travis-ci.org/chorankates/log4r-sequel.svg)](https://travis-ci.org/chorankates/log4r-sequel)

```sh
git clone https://github.com/chorankates/log4r-sequel.git
cd log4r-sequel
rake clean build
gem install pkg/log4r-sequel*.gem
irb
...
irb(main):001:0> require 'log4r-sequel'
=> true
```

## supported databases
  * sqlite3
  * Postgres
  
## TODO
  * allow database name to be semi-dynamically generated - via YAML config, not just by passing the hash directly
  * tests
    * unit tests
  * rubygems.org release
    * MVP implementation and `rake version:bump:patch`
    * badge
  * marketing
    * screencast / sample output in README.md