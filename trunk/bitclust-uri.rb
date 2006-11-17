#!/usr/bin/ruby
require 'bitclust'

module BitClust
  class UrlSearcher < Searcher
    def initialize(dbpath)
      @dbpath = dbpath
      @view = UrlView.new
    end
  end

  class UrlView < TerminalView
    def initialize
      @urlmapper = BitClust::URLMapper.new({
          :cgi_url => 'http://doc.loveruby.net/refm/api/view',
        })
      @line = true
    end

    def show_class(cs)
      @mode = :class_url
      if cs.size == 1
        print_class(cs.first)
      else
        cs.map {|c| print_class(c) }
      end
    end

    def show_method(result)
      if result.determined?
        print_method result.record
      else
        result.records.sort.each do |rec|
          print_method rec
        end
      end
    end

    def print_class(c)
      puts [
        @urlmapper.class_url(c.label),
        c.source[/.*/], # first line
      ].join(" ")
    end

    def print_method(rec)
      puts [
        @urlmapper.method_url(rec.names.to_s),
        #rec.entry.source[/.*/], # first line
        rec.entry.source[/^(?!---)(?=\S).*/], # first line
      ].join(" ")
    end
  end
end

begin
  refe = BitClust::UrlSearcher.new(ARGV.shift)
  refe.exec(nil, ARGV)
rescue
  puts $!
end
