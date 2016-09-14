# log4r-sequel
Log4r outputter to a Sequel database handle

- [usage](#usage)
  - [pre-built gem installation (stable)](#pre-built-gem-installation-stable)
  - [from-source installation (latest)](#from-source-installation-latest)
  - [demo](#demo)
- [supported databases](#supported-databases)
- [TODO](#todo)

the de-facto standard library for logging in Ruby, [log4r](https://github.com/colbygk/log4r) works very well for a wide array of logging targets:
  * STDOUT / STDERR
  * file
  * email
  * syslog

and so on, but didn't have a way to output directly to a database - enter `log4r-sequel`

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

### demo

```
$ ruby example/log2postgres.rb
2016/08/27 17:08.1472342938 | bar | DEBUG | this is a debug message
2016/08/27 17:08.1472342938 | bar | INFO | this is an info message
2016/08/27 17:08.1472342938 | bar | WARN | this is a warning
2016/08/27 17:08.1472342938 | bar | ERROR | this is an error
2016/08/27 17:08.1472342938 | bar | FATAL | this is a fatal
$ sqlite3 example/log.sqlite
SQLite version 3.8.10.2 2015-05-20 18:17:19
Enter ".help" for usage hints.
sqlite> select * from logs;
1|2016/08/27 17:10.1472343022|foo|DEBUG|this is a debug message
2|2016/08/27 17:10.1472343022|foo|INFO|this is an info message
3|2016/08/27 17:10.1472343022|foo|WARN|this is a warning
4|2016/08/27 17:10.1472343022|foo|ERROR|this is an error
5|2016/08/27 17:10.1472343022|foo|FATAL|this is a fatal
sqlite>
```

## supported databases
  * sqlite3
  * Postgres

## TODO
  * tests
    * unit tests


## notes
  * `:database`, `:table`, and `:file` options are passed through `Time.now.strftime(%s)`