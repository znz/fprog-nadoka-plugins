#!/usr/bin/ruby
require 'bitclust'

module BitClust
  class UrlSearcher < Searcher
    def initialize
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
        describe_class cs.first
      else
        cs.sort.each do |c|
          describe_class c
        end
      end
    end

    def show_method(result)
      if result.determined?
        describe_method result.record
      else
        result.records.sort.each do |rec|
          describe_method rec
        end
      end
    end

    def describe_class(c)
      puts [
        @urlmapper.class_url(c.label),
        c.source[/.*/], # first line
      ].join(" ")
    end

    def describe_method(rec)
      puts [
        @urlmapper.method_url(rec.names.to_s),
        #rec.entry.source[/.*/], # first line
        rec.entry.source[/^(?!---)(?=\S).*/], # first line
      ].join(" ")
    end
  end
end

begin
  ENV["BITCLUST_DATADIR"] = ARGV.shift
  refe = BitClust::UrlSearcher.new
  refe.exec(nil, ARGV)
rescue Exception
  puts $!
end
