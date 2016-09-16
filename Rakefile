require 'jeweler'
require 'rake'
require 'rake/clean'
require 'rake/testtask'

CLEAN.include('**/*.sqlite')
CLEAN.include('pkg/*')

Jeweler::Tasks.new do |gem|
  gem.name        = 'log4r-sequel'
  gem.summary     = 'Log4r::Outputter::Sequel'
  gem.description = 'Log4r::Outputter that writes to a Sequel database'
  gem.email       = ['conor.code@gmail.com']
  gem.homepage    = 'http://github.com/chorankates/log4r-sequel'
  gem.authors     = ['Conor Horan-Kates']
  gem.licenses    =  'MIT'

  gem.files.exclude 'example/*'
  gem.files.exclude 'pkg/*'
end
Jeweler::RubygemsDotOrgTasks.new

namespace :test do

  Rake::TestTask.new do |t|
    t.name = 'functional'
    t.libs << 'lib'
    t.test_files = FileList['test/functional/**/test_*.rb']
    t.verbose = false
  end

  Rake::TestTask.new do |t|
    t.name = 'unit'
    t.libs << 'lib'
    t.test_files = FileList['test/unit/**/test_*.rb']
    t.verbose = false
  end

end
desc 'run all tests'
task :test => ['clean', 'test:functional', 'test:unit'] do; end