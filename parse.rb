#!/usr/bin/ruby

require 'rss'
require 'nokogiri'
require 'sanitize'
load 'parse_util.rb'

def main
  if ARGV.length < 2
    puts "Usage: parse.rb <INPUT_FILE_OR_DIR> <OUTPUT_DIR>"
  else
    getData ARGV[0], ARGV[1]

  end
end

def getData (xml_file_input, output_dir)
  files = []
  if File.directory?(xml_file_input)  
    puts "===> Input directory:" + xml_file_input
    files = Dir[xml_file_input+"/*.xml"]
  else
    puts "===> Input file: " + xml_file_input
    files.push(xml_input_fil)
  end
  puts "===> Output directory: "+output_dir
 
  files.each { |file_path|
    doc = File.open(file_path) { |f| Nokogiri::XML(f) }
    doc.xpath('//feed').each{ | feed |
      case feed['type']
        when 'rss'
          begin
            xml = parseRSS(feed.text)
            output_path =  output_dir + '/' + Putil.url_name_to_file(feed.text)
            File.write(output_path,xml)
            puts "** Written to: " +output_path
          rescue Exception => e
            puts e.message
            puts feed 
            next
          end
      end
    }
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
              xml.description_  Sanitize.clean(item.description)
            }
          }
        when 'atom'
          puts 'atom'
          rss.items.each { |item|
            xml.item_ { 
              xml.title_  item.title.content 
              xml.link_   item.link.href
              xml.pubDate_  item.updated.content
              xml.description_ Sanitize.clean(item.summary.content)
            }
          }
        else 
          puts 'other'
          rss.items.each { |item|
            
            puts "feed_type not found: " + item.title 
          }
      end
    }
  end
  builder.to_xml
end

main
