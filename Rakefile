# encoding: UTF-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

#
# Available Rake tasks:
#
# $ rake -T
# rake clean                    # Clean some generated files
# rake default                  # Run doc, style, unit and integration tests
# rake doc                      # Generate Ruby documentation
# rake integration              # Run Test Kitchen integration tests
# rake integration:cloud        # Run Test Kitchen tests in the cloud
# rake integration:docker       # Run Test Kitchen tests using docker
# rake integration:vagrant      # Run Test Kitchen tests using vagrant
# rake style                    # Run all style checks
# rake style:chef               # Run Chef style checks using foodcritic
# rake style:ruby               # Run Ruby style checks using rubocop
# rake style:ruby:auto_correct  # Auto-correct RuboCop offenses
# rake unit                     # Run ChefSpec unit tests
# rake yard                     # Generate Ruby documentation using yard
#
# More info at https://github.com/ruby/rake/blob/master/doc/rakefile.rdoc
#

require 'bundler/setup'

# Checks if we are inside Travis CI.
#
# @return [Boolean] whether we are inside Travis CI.
# @example
#   travis? #=> false
def travis?
  ENV['TRAVIS'] == 'true'
end

desc 'Clean some generated files'
task :clean do
  %w(
    Berksfile.lock
    .bundle
    .cache
    Gemfile.lock
    .kitchen
    metadata.json
  ).each { |f| FileUtils.rm_rf(Dir.glob(f)) }
end

desc 'Generate Ruby documentation using yard'
task :yard do
  require 'yard'
  YARD::Rake::YardocTask.new do |t|
    t.stats_options = %w(--list-undoc)
  end
end

desc 'Generate Ruby documentation'
task doc: %w(yard)

namespace :style do
  require 'rubocop/rake_task'
  desc 'Run Ruby style checks using rubocop'
  RuboCop::RakeTask.new(:ruby)

  require 'foodcritic'
  desc 'Run Chef style checks using foodcritic'
  FoodCritic::Rake::LintTask.new(:chef)
end

desc 'Run all style checks'
task style: %w(style:chef style:ruby)

desc 'Run ChefSpec unit tests'
task :unit do
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.rspec_opts = '--color --format progress'
    t.pattern = 'test/unit/**{,/*/**}/*_spec.rb'
  end
end

namespace :integration do
  def kitchen_config(loader_config = {})
    {}.tap do |config|
      unless loader_config.empty?
        @loader = Kitchen::Loader::YAML.new(loader_config)
        config[:loader] = @loader
      end
    end
  end

  def run_kitchen(loader_config = {})
    require 'kitchen'
    Kitchen.logger = Kitchen.default_file_logger
    config = kitchen_config(loader_config)
    Kitchen::Config.new(config).instances.each { |i| i.test(:always) }
  end

  desc 'Run Test Kitchen integration tests using vagrant'
  task :vagrant do
    run_kitchen
  end

  desc 'Run Test Kitchen integration tests using docker'
  task :docker do
    run_kitchen(local_config: '.kitchen.docker.yml')
  end

  desc 'Run Test Kitchen integration tests in the cloud'
  task :cloud do
    run_kitchen(local_config: '.kitchen.cloud.yml')
  end
end

desc 'Run Test Kitchen integration tests'
task integration: travis? ? %w(integration:docker) : %w(integration:vagrant)

desc 'Run doc, style, unit and integration tests'
task default: %w(doc style unit integration)
