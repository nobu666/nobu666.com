# -*- coding: utf-8 -*-
# $ ruby wp-xml-hugo-import.rb ***.wordpress.yyyy-mm-dd.xml

require 'fileutils'
require 'time'
require 'rexml/document'
include REXML

class Time 
  def timezone(timezone = 'UTC')
    old = ENV['TZ']
    utc = self.dup.utc
    ENV['TZ'] = timezone
    output = utc.localtime
    ENV['TZ'] = old
    output
  end
end

doc = Document.new File.new(ARGV[0])
FileUtils.mkdir_p 'post'
FileUtils.mkdir_p 'page'

doc.elements.each("rss/channel/item[wp:status = 'publish' and (wp:post_type = 'post' or wp:post_type = 'page')]") do |e|
  post = e.elements

  post_id   = post['wp:post_id'].text
  post_name = post['wp:post_name'].text
  post_type = post['wp:post_type'].text

  post_date = Time.parse(post['wp:post_date'].text)
  post_date.timezone('Asia/Tokyo')

  title     = post['title'].text.gsub(/"/, '\"');
  content   = post['content:encoded'].text
  category  = ''

  # Replace absolute path to relative path
  content = content.gsub(/src="http:\/\/nobu666.com\/wp-content\/uploads\/(\d+)\/(\d+)\/(.+?)"/, 'src="/images/\1/\2/\3"')
  content = content.gsub(/\[\/?sourcecode\]/, '```')

  # Page not have category tag
  if defined?(post['category'].text)
    # My blog post have single category
    category = post['category'].text
  end

  filename = "%02d/%02d/%02d/%d.md" % [post_date.year, post_date.month, post_date.day, post_id.to_i]
  `mkdir -p #{"content/%02d/%02d/%02d" % [post_date.year, post_date.month, post_date.day]}`
  puts "Converting: #{filename}"

  File.open("content/#{filename}", 'w') do |f|
    f.puts '+++'
    f.puts "date = \"#{post_date.strftime("%Y-%m-%dT%H:%M:%S%:z")}\""
    f.puts 'draft = false'
    f.puts "title = \"#{title}\""
    if !category.empty?
      f.puts "categories = [\"#{category}\"]"
    end
    f.puts '+++'
    f.puts "\n"
    f.puts content
  end

end
