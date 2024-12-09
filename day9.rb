#!/usr/bin/env ruby

require "debug"

input = File.read(File.basename(__FILE__, ".rb") + ".txt").strip

class Disk
  def initialize
    @mode = :file
    @blocks = []
    @id = 0
  end

  def <<(n)
    case @mode
    when :file
      n.times do
        @blocks << @id
      end
      @id += 1
      @mode = :free_space
    when :free_space
      n.times do
        @blocks << nil
      end
      @mode = :file
    end
  end

  def compact!
    file_pointer = @blocks.length - 1
    free_pointer = @blocks.index nil

    loop do
      @blocks[free_pointer] = @blocks[file_pointer]
      @blocks[file_pointer] = nil

      loop do
        file_pointer -= 1

        break if @blocks[file_pointer]
      end

      loop do
        free_pointer += 1

        break if @blocks[free_pointer].nil?
      end

      break if free_pointer >= file_pointer
    end
  end

  def checksum
    @blocks.each_with_index.sum { _1&.*(_2) || 0 }
  end
end

disk = Disk.new

input.chars.map(&:to_i).each do |n|
  disk << n
end

disk.compact!

puts disk.checksum
