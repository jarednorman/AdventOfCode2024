#!/usr/bin/env ruby

require "debug"
require "matrix"

module Hacks
  refine Matrix do
    def [](x, y)
      return nil if x < 0 || y < 0

      super
    end

    def inspect
      row_vectors.map { |row|
        row.map { |value|
          (value || ".").to_s.ljust(2, " ")
        }.to_a.join(" ") + "\n"
      }.join
    end
  end
end

using Hacks

input = File.readlines(File.basename(__FILE__, ".rb") + ".txt", chomp: true).map { |line|
  line.chars.map(&:to_i)
}

map = Matrix[*input]
path_map = Matrix.build(map.row_count, map.column_count) { |x, y|
  (map[x, y] == 9) ? 1 : nil
}

8.downto(0).each do |n|
  map.each_with_index.select { |c, x, y| c == n }.each do |c, x, y|
    path_map[x, y] = [
      [x + 1, y],
      [x - 1, y],
      [x, y - 1],
      [x, y + 1]
    ].sum { |(x2, y2)|
      if map[x2, y2] == c + 1
        path_map[x2, y2]
      else
        0
      end
    }
  end
end

part_one = map.each_with_index.select { |c, x, y| c == 0 }.sum { |_, x, y|
  path_map[x, y]
}

puts part_one
