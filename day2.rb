#!/usr/bin/env ruby

require "debug"

input = File.read(File.basename(__FILE__, ".rb") + ".txt")

class Report
  def initialize(levels)
    @levels = levels
  end

  def safe?
    (all_increasing? || all_decreasing?) && gradual?
  end

  private

  def all_increasing?
    pairs.all? { |(a, b)| a < b }
  end

  def all_decreasing?
    pairs.all? { |(a, b)| a > b }
  end

  def gradual?
    pairs.all? { |(a, b)|
      (1..3).cover? (a - b).abs
    }
  end

  def pairs
    @levels.each_cons(2)
  end
end

reports = input.lines.map(&:strip).map { |line|
  levels = line.split.map(&:to_i)

  Report.new(levels)
}

puts reports.count(&:safe?)
