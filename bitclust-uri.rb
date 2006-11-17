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
      super
    end

    def show_method(result)
      @mode = :method_url
      super
    end

    def puts(name)
      super(@urlmapper.__send__(@mode, name))
    end
  end
end

begin
  refe = BitClust::UrlSearcher.new(ARGV.shift)
  refe.exec(nil, ARGV)
rescue
  puts $!
end
