#!/usr/bin/env ruby

require "debug"

input = File.read(File.basename(__FILE__, ".rb") + ".txt")

puts(
  input
    .lines
    .map(&:strip)
    .map { |line|
      line.split.map { |n| n.to_i }
    }
    .transpose
    .map(&:sort)
    .transpose
    .map { |(a, b)| (a - b).abs }
    .sum
)
