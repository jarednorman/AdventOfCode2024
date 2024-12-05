#!/usr/bin/env ruby

require "debug"

def `(s)
  puts s
end

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
      case other
      when "middle"
        self[length / 2]
      else
        filter! { other.call(_1) }
      end
    end

    def **(other)
      index other
    end

    def <(other)
      delete(other)
    end

    def self.[](operator, array_method)
      define_method(operator) do |other = nil, &block|
        send(array_method) {
          block ? block.call(_1) : other.call(_1)
        }
      end
    end

    self[:>=, :sum]
    self[:>, :map]
    self[:<=, :all?]
    self[:=~, :partition]
    self[:/, :select]
    self[:!~, :find]
    self[:>>, :none?]
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

  def <<(rules)
    applicable_rules = rules / ->(rule) { (@pages**+rule) && (@pages**-rule) }

    old_pages = @pages.dup
    new_pages = []

    until old_pages.empty?
      next_page = old_pages !~ ->(page) {
        applicable_rules >> ->(rule) { page == -rule }
      }

      applicable_rules % ->(rule) { next_page != +rule }

      old_pages < next_page
      new_pages << next_page
    end

    Update[*new_pages]
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

rules = rule_data > ->(r) { eval r }
updates = update_data > ->(u) { eval "Update[#{u}]" }

valid_updates, invalid_updates = updates =~ ->(update) {
  rules <= ->(rule) { update === rule }
}

part_one = valid_updates.>=(&:~@)

part_two = (invalid_updates > ->(update) {
  update << rules
}).>=(&:~@)

`Part One: #{part_one}`
`Part Two: #{part_two}`
