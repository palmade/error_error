require 'rubygems'
gem 'echoe'
require 'echoe'

Echoe.new("error_error") do |p|
  p.author = "palmade"
  p.project = "error_error"
  p.summary = "Error helper"

  p.dependencies = [ ]

  p.need_tar_gz = false
  p.need_tgz = true

  p.clean_pattern += [ "pkg", "lib/*.bundle", "*.gem", ".config" ]
  p.rdoc_pattern = [ 'README', 'LICENSE', 'COPYING', 'lib/**/*.rb', 'doc/**/*.rdoc' ]
end

gem 'rspec'
