#!/usr/bin/env ruby

require "debug"

module Hacks
  refine Integer do
    def |(other)
      Rule.new(self, other)
    end
  end

  refine String do
    def -@
      split("\n\n").map { _1.lines.map(&:strip) }
    end
  end

  refine Array do
    def %(other)
      self[length / 2]
    end

    def **(other)
      index other
    end
  end
end

using Hacks

class Rule
  def initialize(first, last)
    @first = first
    @last = last
  end

  def +@
    @first
  end

  def -@
    @last
  end
end

class Update
  def self.[](...)
    new(...)
  end

  def initialize(*pages)
    @pages = pages
  end

  def ~
    @pages % "middle"
  end

  def ===(rule)
    !(@pages**+rule) || !(@pages**-rule) || @pages**+rule < @pages**-rule
  end
end

input = File.read(File.basename(__FILE__, ".rb") + ".txt")

rule_data, update_data = *-input

rules = rule_data.map { eval _1 }
updates = update_data.map { eval "Update[#{_1}]" }

result = updates.sum { |update|
  if rules.all? { |rule| update === rule }
    ~update
  else
    0
  end
}

puts result
