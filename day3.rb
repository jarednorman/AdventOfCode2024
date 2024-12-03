#!/usr/bin/env ruby

require "debug"

input = File.read(File.basename(__FILE__, ".rb") + ".txt")

r = /mul\((\d{1,3}),(\d{1,3})\)/

result = input.scan(r).sum { |a|
  a.map(&:to_i).inject(:*)
}

puts result
