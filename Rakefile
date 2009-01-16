%w[rubygems rake rake/clean fileutils newgem rubigen].each { |f| require f }
require File.dirname(__FILE__) + '/lib/url_signer'

$hoe = Hoe.new('url_signer', UrlSigner::VERSION) do |p|
  p.developer('Caroo GmbH', 'dev@pkw.de')
  p.changes              = p.paragraphs_of("History.txt", 0..1).join("\n\n")
  p.extra_dev_deps = [
    ['activesupport'],
    ['newgem', ">= #{::Newgem::VERSION}"]
  ]
  p.summary = "UrlSigner is a class to cryptographically sign URLs."
  p.clean_globs |= %w[**/.DS_Store tmp *.log]
end

require 'newgem/tasks'

desc "Run unit tests"
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
  t.warning = true
end

desc 'Generate RDoc'
Rake::RDocTask.new do |task|
  task.main = 'README.rdoc'
  task.title = "UrlSigner #{UrlSigner::VERSION}"
  task.rdoc_dir = 'doc'
  task.rdoc_files.include('README.rdoc', 'COPYING', 'MIT-LICENSE',"lib/**/*.rb")
end