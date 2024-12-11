# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.0'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'jbuilder', '~> 2.7'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.5', '>= 5.5.1'
gem 'rails', '~> 7.2.2'
gem 'redis', '~> 4.0'
gem 'sass-rails', '>= 6.0.0'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 5.4', '>= 5.4.0'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'rspec-rails', '>= 5.0.2'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rake', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'web-console', '>= 4.1.0'
end

group :test do
  gem 'capybara', '>= 3.35.3'
  gem 'selenium-webdriver'
  gem 'webdrivers', '>= 4.6.1'
end
