#!/usr/bin/env ruby

require "debug"

input = File.readlines(File.basename(__FILE__, ".rb") + ".txt", chomp: true)

class CalibrationCalculator
  include Enumerable

  def initialize(calibration_equation, pipe: false)
    @calibration_equation = calibration_equation
    @pipe = pipe
  end

  def each(&block)
    first_value, *remaining_values = @calibration_equation

    possible_results(first_value, remaining_values).each do |result|
      block.call(result)
    end
  end

  private

  def possible_results(current_value, remaining_values)
    return [current_value] if remaining_values.empty?

    next_value, *new_remaining_values = remaining_values

    [
      possible_results(current_value + next_value, new_remaining_values),
      possible_results(current_value * next_value, new_remaining_values),
      @pipe ? possible_results(pipe(current_value, next_value), new_remaining_values) : nil
    ].compact.flatten
  end

  def pipe(a, b)
    (a.to_s + b.to_s).to_i
  end
end

part_one = input.map { |line|
  test_value, calibration_equation = line.split ": "
  [test_value.to_i, calibration_equation.split(" ").map(&:to_i)]
}.select { |(test_value, calibration_equation)|
  CalibrationCalculator.new(calibration_equation).any? { |possible_result|
    possible_result == test_value
  }
}.sum(&:first)
raise "Part One changed: #{part_one} should equal 2299996598890" unless part_one == 2299996598890
puts part_one

part_two = input.map { |line|
  test_value, calibration_equation = line.split ": "
  [test_value.to_i, calibration_equation.split(" ").map(&:to_i)]
}.select { |(test_value, calibration_equation)|
  CalibrationCalculator.new(calibration_equation, pipe: true).any? { |possible_result|
    possible_result == test_value
  }
}.sum(&:first)

raise "Part Two changed: #{part_two} should equal 362646859298554" unless part_one == 362646859298554
puts part_two
