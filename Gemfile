# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.1'
gem 'bootsnap', '~> 1.10', require: false
gem 'jbuilder', '~> 2.11'
gem 'pg', '~> 1.3'
gem 'puma', '~> 5.6'
gem 'rails', '~> 7.0'
gem 'redis', '~> 4.6'
gem 'sass-rails', '~> 6.0'
gem 'turbolinks', '~> 5.2'
gem 'webpacker', '~> 5.4'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'rspec-rails', '~> 5.1'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rake', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  gem 'listen', '~> 3.7'
  gem 'rack-mini-profiler', '~> 2.3'
  gem 'web-console', '~> 4.2'
end

group :test do
  gem 'capybara', '~> 3.36'
  gem 'selenium-webdriver'
  gem 'webdrivers', '~> 5.0'
end
