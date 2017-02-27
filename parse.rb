#!/usr/bin/ruby

require 'rss'
require 'nokogiri'

def main
  if ARGV.length < 2
    puts "Usage: parse.rb <INPUT_FILE> <OUTPUT_DIR>"
  else
    getData ARGV[0]
  end
end

def getData (xml_file)
  doc = File.open(xml_file) { |f| Nokogiri::XML(f) }
  doc.xpath('//feed').each{ | feed |
    case feed['type']
      when 'rss'
        begin
          parseRSS(feed.text)
        rescue Exception => e
          puts e.message
          puts feed 
          next
        end
    end
  }
end


def parseRSS(url)
  puts url
  rss = RSS::Parser.parse(url, false)
  builder = Nokogiri::XML::Builder.new do |xml|
    xml.news {
      
      case rss.feed_type
        when 'rss'
          puts 'rss'
          rss.items.each { |item| 
            xml.item_ {
              xml.title_  item.title
              xml.link_   item.link
              xml.pubDate_  item.pubDate
              xml.description_  item.description
            }
          }
        when 'atom'
          puts 'atom'
          rss.items.each { |item| puts item.title.content }
        else 
          puts 'other'
          rss.items.each { |item|
            
            puts item.title 
          }
      end
    }
  end
  puts builder.to_xml
end

main
