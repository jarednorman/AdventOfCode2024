#!/usr/bin/env ruby

require "debug"

def method_missing(method_name, *args, &block)
  case method_name
  when :input
    File.read(File.basename(__FILE__, ".rb") + ".txt")
  when :newline
    @obstacles ||= {}
    @x = 0
    @y = (@y || -1) + 1
  when :"."
    nil
    @x += 1
  when :"#"
    @obstacles[[@x, @y]] = true
    @x += 1
  when :^
    @guard_position = [@x, @y]
    @guard_direction = :up
    @x += 1
  when :guard_on_board?
    @guard_position.first(2).all? { (0..129).cover? _1 }
  when :step
    @guard_positions ||= Set.new
    @guard_positions << @guard_position

    case @guard_direction
    when :up
      new_position = [@guard_position.first, @guard_position[1] - 1]
      if @obstacles[new_position]
        @guard_direction = :right
      else
        @guard_position = [*new_position, @guard_direction]
      end
    when :right
      new_position = [@guard_position.first + 1, @guard_position[1]]
      if @obstacles[new_position]
        @guard_direction = :down
      else
        @guard_position = [*new_position, @guard_direction]
      end
    when :down
      new_position = [@guard_position.first, @guard_position[1] + 1]
      if @obstacles[new_position]
        @guard_direction = :left
      else
        @guard_position = [*new_position, @guard_direction]
      end
    when :left
      new_position = [@guard_position.first - 1, @guard_position[1]]
      if @obstacles[new_position]
        @guard_direction = :up
      else
        @guard_position = [*new_position, @guard_direction]
      end
    end
  when :guard_position_count
    @guard_positions.map { _1.first(2) }.to_set.size
  when :part_one
    input.lines.map(&:strip).each { |line|
      newline

      line.chars.each { |char|
        send(char)
      }
    }

    while guard_on_board?
      step
    end

    guard_position_count
  when :part_two
  else
    super
  end
end

result = part_one
raise "Part one changed to #{result}" unless result == 4656
puts result

puts part_two
