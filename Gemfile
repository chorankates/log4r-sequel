## travis really doesn't like this
#ruby '2.0.0'

source 'https://rubygems.org'

gem 'log4r', '~> 1.1.9', '> 1.1'

gem 'sequel', '~> 4.6', '>= 4.6.0'

group :development do
  gem 'jeweler', '~> 2.0', '>= 2.0.0'
  gem 'test-unit', '~> 2.0', '>= 2.0.0'

  # ugh this is so stupid - jeweler pulls in the latest version of this -
  # through it's own dependency, causing a hard requirement on ruby 2.3.x,
  # locking it down this way
  gem 'rack', '= 1.6.4'

  # making ruby 2.3.0 happy
  gem 'hoe', '~> 3.15', '>= 3.15.1'
end

group :sqlite do
  gem 'sqlite3', '~> 1.3', '>= 1.3.11'
end

group :postgres do
  gem 'pg', '~> 0.18', '>= 0.18.4'
end
