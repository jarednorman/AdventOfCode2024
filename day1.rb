#!/usr/bin/env ruby

require "debug"

input = File.read(File.basename(__FILE__, ".rb") + ".txt")

# puts(
#   input
#     .lines
#     .map(&:strip)
#     .map { |line|
#       line.split.map { |n| n.to_i }
#     }
#     .transpose
#     .map(&:sort)
#     .transpose
#     .map { |(a, b)| (a - b).abs }
#     .sum
# )

list_one, list_two = input.lines.map(&:strip).map { |line| line.split.map { |n| n.to_i } }.transpose

counts = list_two.tally
counts.default = 0

puts(list_one.sum { |n|
  n * counts[n]
})
