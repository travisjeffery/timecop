# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/timecop.rb'
require './lib/timecop/version.rb'

PKG_NAME      = "timecop"
PKG_BUILD     = ENV['PKG_BUILD'] ? '.' + ENV['PKG_BUILD'] : ''
version = Timecop::Version::STRING.dup
if ENV['SNAPSHOT'].to_i == 1
  version << "." << Time.now.utc.strftime("%Y%m%d%H%M%S")
end
PKG_VERSION   = version
PKG_FILE_NAME = "#{PKG_NAME}-#{PKG_VERSION}"

Hoe.new(PKG_NAME, PKG_VERSION) do |p|
  p.rubyforge_name = 'johntrupiano' # if different than lowercase project name
  p.developer('John Trupiano', 'jtrupiano@gmail.com')
  p.name = PKG_NAME
  p.version = PKG_VERSION
  #p.platform = Gem::Platform::RUBY
  p.author = "John Trupiano"
  p.email = "jtrupiano@gmail.com"
  p.description = %q(A gem providing simple ways to temporarily override Time.now, Date.today, and DateTime.now.  It provides "time travel" capabilities, making it dead simple to write test time-dependent code.)
  p.summary = p.description # More details later??
  p.remote_rdoc_dir = PKG_NAME # Release to /PKG_NAME
  #  p.changes = p.paragraphs_of('CHANGELOG', 0..1).join("\n\n")
  p.need_zip = true
  p.need_tar = false
end

# vim: syntax=Ruby
