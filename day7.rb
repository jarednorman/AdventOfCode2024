#!/usr/bin/env ruby

require "debug"

input = File.readlines(File.basename(__FILE__, ".rb") + ".txt", chomp: true)

class CalibrationCalculator
  include Enumerable

  def initialize(calibration_equation)
    @calibration_equation = calibration_equation
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
      possible_results(current_value * next_value, new_remaining_values)
    ].flatten
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

puts part_one
