#!/usr/bin/env ruby

require "debug"

input = File.read(File.basename(__FILE__, ".rb") + ".txt")

class Map
  def method_missing(method_name)
    case method_name
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
      @guard_position.all? { (0..129).cover? _1 }
    when :step
      @guard_positions ||= Set.new
      @guard_positions << @guard_position

      case @guard_direction
      when :up
        new_position = [@guard_position.first, @guard_position.last - 1]
        if @obstacles[new_position]
          @guard_direction = :right
        else
          @guard_position = new_position
        end
      when :right
        new_position = [@guard_position.first + 1, @guard_position.last]
        if @obstacles[new_position]
          @guard_direction = :down
        else
          @guard_position = new_position
        end
      when :down
        new_position = [@guard_position.first, @guard_position.last + 1]
        if @obstacles[new_position]
          @guard_direction = :left
        else
          @guard_position = new_position
        end
      when :left
        new_position = [@guard_position.first - 1, @guard_position.last]
        if @obstacles[new_position]
          @guard_direction = :up
        else
          @guard_position = new_position
        end
      else
        raise "We didn't implement #{@guard_direction.inspect}"
      end
    when :guard_position_count
      @guard_positions.size
    else
      raise "we forgot something #{method_name.inspect}"
    end
  end
end

map = Map.new

input.lines.map(&:strip).each { |line|
  map.newline

  line.chars.each { |char|
    map.send(char)
  }
}

while map.guard_on_board?
  map.step
end

puts map.guard_position_count
