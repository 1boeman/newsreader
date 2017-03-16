#!/usr/bin/ruby

require 'rss'
require 'mechanize'
require 'nokogiri'
require 'htmlentities'
require 'sanitize'
load 'parse_util.rb'

def main
  if ARGV.length < 2
    puts "Usage: parse.rb <INPUT_FILE_OR_DIR> <OUTPUT_DIR>"
  else
    getData ARGV[0], ARGV[1]
    makeMenu ARGV[0]
  end
end

def makeMenu(xml_dir_input)
  if File.directory?(xml_dir_input)  
    puts "===> Input directory:" + xml_dir_input
    files = Dir[xml_dir_input+"/*.xml"]
    puts files
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.ul(:class => 'nav nav-pills nav-justified') {
        files.each { |f|
          read_doc = File.open(f) { |read_file| Nokogiri::XML(read_file) }
          title = read_doc.xpath('//title')[0].text
          xml.li {
            xml.a(:href => '/' + File.basename(f).gsub(/\.xml$/i,'.html')) { xml.text title } 
          }   
        }
      }
    end
    output_path =  xml_dir_input + '/menu.html'
    File.write(output_path,builder.to_xml)
  end
end

def getData (xml_file_input, output_dir)
  files = []
  if File.directory?(xml_file_input)  
    puts "===> Input directory:" + xml_file_input
    files = Dir[xml_file_input+"/*.xml"]
  else
    puts "===> Input file: " + xml_file_input
    files.push(xml_file_input)
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
  agent = Mechanize.new { |agent|
    agent.user_agent_alias = "Mac Firefox"
    agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  }
  response = agent.get(url)
  i=0
  max_items = 10
  rss = RSS::Parser.parse(response.content,false)
  builder = Nokogiri::XML::Builder.new do |xml|
    xml.news {
      case rss.feed_type
        when 'rss'
          puts 'rss'
          xml.feed_title_ rss.channel.title      
          rss.items.each { |item| 
            i+=1
            xml.item_ {
              xml.title_  item.title
              xml.link_   item.link
              xml.description_  Sanitize.clean(item.description)
            }
            break if i > max_items
          }
        when 'atom'
          puts 'atom'
          xml.feed_title_ rss.title.content
          rss.items.each { |item|
            i+=1
            xml.item_ { 
              xml.title_  item.title.content 
              xml.link_   item.link.href
              xml.description_ Sanitize.clean(item.summary.content)
            }
            break if i > max_items
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
