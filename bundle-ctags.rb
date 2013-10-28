#! /usr/bin/env ruby

require 'guard/ctags-bundler'

Guard::CtagsBundler.new.send(:generate_bundler_tags)
