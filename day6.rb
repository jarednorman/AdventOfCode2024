#!/usr/bin/env ruby

require "debug"

def method_missing(method_name, *args, &block)
  case method_name
  when :input
    @input ||= File.read(File.basename(__FILE__, ".rb") + ".txt").lines.map(&:strip).map(&:chars)
  when :newline
    @x = 0
    @y = (@y || -1) + 1
  when :"."
    nil
    @x += 1
  when :"#"
    @obstacles[[@x, @y]] = true
    @x += 1
  when :^
    @guard_position = [@x, @y, :up]
    @x += 1
  when :guard_on_board?
    @guard_position.first(2).all? { (0..(input.first.length - 1)).cover? _1 }
  when :step
    @guard_positions ||= Set.new

    if @guard_positions.include?(@guard_position)
      @looping = true
    else
      @guard_positions << @guard_position
    end

    case @guard_position.last
    when :up
      new_position = [@guard_position.first, @guard_position[1] - 1]

      @guard_position = if @obstacles[new_position]
        [*@guard_position.first(2), :right]
      else
        [*new_position, :up]
      end
    when :right
      new_position = [@guard_position.first + 1, @guard_position[1]]

      @guard_position = if @obstacles[new_position]
        [*@guard_position.first(2), :down]
      else
        [*new_position, :right]
      end
    when :down
      new_position = [@guard_position.first, @guard_position[1] + 1]

      @guard_position = if @obstacles[new_position]
        [*@guard_position.first(2), :left]
      else
        [*new_position, :down]
      end
    when :left
      new_position = [@guard_position.first - 1, @guard_position[1]]

      @guard_position = if @obstacles[new_position]
        [*@guard_position.first(2), :up]
      else
        [*new_position, :left]
      end
    end
  when :guard_positions
    @guard_positions.map { _1.first(2) }.to_set
  when :guard_positions_count
    guard_positions.size
  when :reset_board
    @obstacles = {}
    @guard_positions = nil
    @looping = false
    @y = nil

    input.each { |line|
      newline

      line.each { send _1 }
    }
  when :looping?
    @looping
  when :part_one
    reset_board

    step while guard_on_board?

    guard_positions_count
  when :part_two
    original_guard_positions = @guard_positions.map { _1.first(2) }.to_set

    reset_board

    (original_guard_positions - [@guard_position.first(2)]).count { |(x, y)|
      reset_board

      @obstacles[[x, y]] = true

      loop do
        step

        if !guard_on_board?
          break false
        elsif looping?
          break true
        end
      end
    }
  else
    super
  end
end

puts "Part One: #{part_one}"
puts "Part Two: #{part_two}"
