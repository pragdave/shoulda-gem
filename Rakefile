# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/shoulda.rb'

Hoe.new('shoulda', Thoughtbot::Shoulda::VERSION) do |p|
  p.rubyforge_name = 'shoulda'
  p.author = 'Tammer Saleh'
  p.email = 'tsaleh@thoughtbot.com'
  p.summary = 'Testing library built on top of Test::Unit'
  p.description = p.paragraphs_of('README.txt', 2..5).join("\n\n")
  p.url = p.paragraphs_of('README.txt', 0).first.split(/\n/)[1..-1]
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
end

# vim: syntax=Ruby
