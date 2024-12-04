#!/usr/bin/env ruby

require "debug"

input = File.read(File.basename(__FILE__, ".rb") + ".txt")

r = /mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\)/

def mul(a, b)
  return 0 unless @doing

  a * b
end

@doing = true

result = input.scan(r).sum { |a|
  case a
  when "do()"
    @doing = true
    0
  when "don't()"
    @doing = false
    0
  else
    eval a
  end
}

puts result
