#!/usr/bin/env ruby

require "debug"

input = File.read(File.basename(__FILE__, ".rb") + ".txt")

class WordSearch
  def initialize(text)
    @word_search = text.lines.map { _1.strip.split("") }.transpose
  end

  def count_word(word)
    letters = word.split("")

    @word_search.each_with_index.sum do |column, x|
      column.each_with_index.sum do |char, y|
        next 0 unless char == letters.first

        [
          [1, 0],
          [1, 1],
          [0, 1],
          [-1, 1],
          [-1, 0],
          [-1, -1],
          [0, -1],
          [1, -1]
        ].count { |(dx, dy)|
          word_in_direction?(letters, x, y, dx, dy)
        }
      end
    end
  end

  def count_x_mases
    @word_search.each_with_index.sum do |column, x|
      column.each_with_index.count do |char, y|
        next false unless char == "A"

        (self[x - 1, y - 1] == "M" && self[x + 1, y + 1] == "S" || self[x - 1, y - 1] == "S" && self[x + 1, y + 1] == "M") &&
          (self[x + 1, y - 1] == "M" && self[x - 1, y + 1] == "S" || self[x + 1, y - 1] == "S" && self[x - 1, y + 1] == "M")
      end
    end
  end

  private

  def word_in_direction?(letters, x, y, dx, dy)
    letters.each_with_index.all? { |letter, index|
      self[x + dx * index, y + dy * index] == letter
    }
  end

  def [](x, y)
    return if x.negative? || y.negative?

    @word_search.dig(x, y)
  end
end

puts WordSearch.new(input).count_x_mases
