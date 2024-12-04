#!/usr/bin/env ruby

require "debug"

input = File.read(File.basename(__FILE__, ".rb") + ".txt")

class Pattern
  def initialize(letter_positions)
    @letter_positions = letter_positions
  end

  attr_reader :letter_positions
end

class WordSearch
  def initialize(text)
    @word_search = text.lines.map { _1.strip.split("") }.transpose
  end

  def count(patterns)
    patterns.sum do |pattern|
      @word_search.each_with_index.sum do |column, x|
        column.each_with_index.count do |char, y|
          pattern.letter_positions.all? { |(c, dx, dy)|
            self[x + dx, y + dy] == c
          }
        end
      end
    end
  end

  private

  def [](x, y)
    return if x.negative? || y.negative?

    @word_search.dig(x, y)
  end
end

part_one = WordSearch.new(input).count([
  [1, 0],
  [1, 1],
  [0, 1],
  [-1, 1],
  [-1, 0],
  [-1, -1],
  [0, -1],
  [1, -1]
].map { |(dx, dy)|
  Pattern.new(
    "XMAS".chars.each_with_index.map { |c, i|
      [c, dx * i, dy * i]
    }
  )
})

part_two = WordSearch.new(input).count([
  Pattern.new([
    ["A", 0, 0],
    ["M", -1, -1],
    ["S", 1, 1],
    ["M", 1, -1],
    ["S", -1, 1]
  ]),
  Pattern.new([
    ["A", 0, 0],
    ["M", -1, 1],
    ["S", 1, -1],
    ["M", 1, 1],
    ["S", -1, -1]
  ]),
  Pattern.new([
    ["A", 0, 0],
    ["M", -1, -1],
    ["S", 1, 1],
    ["M", -1, 1],
    ["S", 1, -1]
  ]),
  Pattern.new([
    ["A", 0, 0],
    ["M", 1, -1],
    ["S", -1, 1],
    ["M", 1, 1],
    ["S", -1, -1]
  ]),
])

raise "#{part_one} should equal 2543" unless part_one == 2543
raise "#{part_two} should equal 1930" unless part_two == 1930

puts "Part One: #{part_one}"
puts "Part Two: #{part_two}"
