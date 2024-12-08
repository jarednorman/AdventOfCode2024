#!/usr/bin/env ruby

require "debug"

input = File.readlines(File.basename(__FILE__, ".rb") + ".txt", chomp: true)

P = Data.define(:x, :y) do
  def -(other)
    P[x - other.x, y - other.y]
  end

  def +(other)
    P[x + other.x, y + other.y]
  end
end

antennas = Hash.new do |k, h|
  k[h] = []
end

bounds = nil

input.each_with_index do |line, y|
  bounds ||= 0..(line.length - 1)

  line.chars.each_with_index do |frequency, x|
    next if frequency == "."

    antennas[frequency] << P[x, y]
  end
end

antinodes = Set.new

antennas.each do |_, antennas|
  antennas.combination(2).each do |(p1, p2)|
    delta = p1 - p2

    antinode1 = p1 + delta
    antinode2 = p2 - delta

    [antinode1, antinode2].each do |antinode|
      if bounds.cover?(antinode.x) && bounds.cover?(antinode.y)
        antinodes << antinode
      end
    end
  end
end

antennas_by_position = antennas.flat_map { |frequency, antennas|
  antennas.map { |p| [p, frequency] }
}.to_h

# bounds.each do |y|
#   puts(bounds.map do |x|
#     p = P[x, y]

#     antennas_by_position[p] ||
#       (antinodes.include?(p) ? "#" : nil) ||
#       "."
#   end.join)
# end

puts "Part One: #{antinodes.length}"
