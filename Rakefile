# frozen_string_literal: true

require "bundler/gem_tasks"

Bundler.setup
require 'rspec/core/rake_task'
 
desc "run spec"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ["--color", "--format documentation"]
end