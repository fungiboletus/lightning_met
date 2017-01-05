#!/usr/local/bin/ruby

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'uri'
require 'cgi'
require 'rufus-scheduler'

OUTPUT_FOLDER = ENV["OUTPUT_FOLDER"] ? 
  ENV["OUTPUT_FOLDER"] + (ENV["OUTPUT_FOLDER"].end_with?('/') ? '' : '/' ) : "./output/"
FREQUENCY = ENV["FREQUENCY"] || "4h"

scheduler = Rufus::Scheduler.new


def fetch_data
  puts "Fetching available documents"
  available_docs = Nokogiri::XML(open("https://api.met.no/weatherapi/lightning/1.0/available"))
  available_docs.xpath("//uri").each do |uri|
    datetime = CGI.parse(URI.parse(uri.content).query)["datetime"].first
    next if datetime.nil?
    filename = datetime.gsub(/[\/\\\.]/, '')
    filepath = OUTPUT_FOLDER + filename

    if File.size?(filepath).nil?
      puts "Download #{datetime}"
      download = open(uri.content)
      IO.copy_stream(download, filepath)
    end
  end
end

fetch_data
scheduler.every FREQUENCY do
  fetch_data
end
scheduler.join