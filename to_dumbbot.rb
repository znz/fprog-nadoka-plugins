#!/usr/bin/ruby
if ARGV.empty?
  puts "usage: #$0 dumbbot-unixsocket 'some message' 'more messages...'"
  exit
end
require 'socket'
UNIXSocket.open(ARGV.shift){|s|ARGV.each{|x|s.puts x}}
