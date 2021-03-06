#!/usr/bin/ruby
# -*- coding: utf-8 -*-
=begin
usage:
  wget http://www.jma.go.jp/jp/amedas_h/index.html
  ruby amedas_h.rb | xargs wget
  ruby amedas_h.rb >> amedasbot.nb
after remove /__END__/...EOF from amedasbot.nb
=end
require 'nkf'
require 'pp'
require 'uri'

uri = URI.parse("http://www.jma.go.jp/jp/amedas_h/index.html")
html = NKF.nkf("-Wwm0", open('index.html'){|f|f.read})
unless File.exist?("map10.html")
  html.scan(/<A href="(\.\/map(\d\d)\.html)">\[(.+?)\]<\/A>/).each do |href, group_code, text|
    puts uri  + href
  end
  exit
end
group_codes = {}
html.scan(/<A href="(\.\/map(\d\d)\.html)">\[(.+?)\]<\/A>/).each do |href, group_code, text|
  group_codes[group_code] = text
end

areas = []
Dir.glob("map??.html").sort.each do |map_html|
  map = NKF.nkf("-Wwm0", open(map_html){|f|f.read})
  map.scan(/<area.*?>/) do |area|
    if /alt='(.+?)'.+href='today-(\d+)\.html\?areaCode=000&groupCode=(\d+)'/ =~ area
      # name, code, group_code
      areas.push $~.captures.reverse
    else
      raise "unexpected area: #{area}"
    end
  end
end
areas.uniq!

seen_area = Hash.new(0)
areas.each do |group_code, code, name|
  seen_area[name] += 1
end

puts "GROUP_CODES = {"
group_codes.keys.sort.each do |key|
  puts "  '#{key}' => '#{group_codes[key]}',"
end
puts "}"
puts "AREAS = ["
areas.sort.each do |group_code, code, name|
  puts "  ['#{name}', '#{code}', '#{group_code}'],"
end
puts "]"
puts "DUPLICATED_AREA = ["
seen_area.keys.sort.each do |key|
  if 2 <= seen_area[key]
    puts "  '#{key}',"
  end
end
puts "]"
