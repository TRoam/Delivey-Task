require 'rubygems'

# ENV['NLS_LANG'] = 'AMERICAN_AMERICA.UTF8'
# ENV['NLS_SHOTR']= 'Array.new(10) { iii }'
# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
