#!/usr/bin/ruby
require './lib/scrapp.rb'
require 'json'
require 'pp'


herault = Scrapper.new("https://www.annuaire-des-mairies.com/herault.html")

File.open("./db/email.json", "w") do |node|
    node.write((herault.box).to_json)
end
