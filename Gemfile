# -*- mode: ruby -*-
# vi: set ft=ruby :

source 'https://rubygems.org'

gem 'berkshelf', '~> 2.0'

group :lint do
  gem 'foodcritic', '~> 3.0'
end

group :kitchen_common do
  gem 'test-kitchen', '~> 1.2'
end

group :kitchen_vagrant do
  gem 'vagrant' , :git => 'git://github.com/mitchellh/vagrant.git', :branch => 'v1.3.5'
  gem 'kitchen-vagrant', '~> 0.10'
end
