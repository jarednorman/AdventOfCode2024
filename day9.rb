#!/usr/bin/env ruby

require "debug"

input = File.read(File.basename(__FILE__, ".rb") + ".txt").strip

Chunk = Data.define(:id, :size) do
  def free_space?
    id.nil?
  end

  def insert(chunk)
    raise "wtf" unless free_space?

    return chunk if size == chunk.size

    [
      chunk,
      Chunk[nil, size - chunk.size]
    ]
  end

  def to_a
    Array.new(size, id)
  end
end

class Disk
  def initialize
    @mode = :file
    @chunks = []
    @id = 0
  end

  def <<(n)
    case @mode
    when :file
      @chunks << Chunk[@id, n]
      @id += 1
      @mode = :free_space
    when :free_space
      @chunks << Chunk[nil, n]
      @mode = :file
    end
  end

  def compact!
    file_pointer = @chunks.length - 1

    loop do
      chunk = @chunks[file_pointer]

      free_space_pointer = @chunks.index { _1.free_space? && _1.size >= chunk.size }

      if free_space_pointer && free_space_pointer < file_pointer
        @chunks[free_space_pointer] = @chunks[free_space_pointer].insert(chunk)

        @chunks[file_pointer] = Chunk[nil, chunk.size]
        @chunks.flatten!
      end

      break if @chunks.slice(0...file_pointer).none?(&:free_space?)

      loop do
        file_pointer -= 1

        break unless @chunks[file_pointer].free_space?
      end
    end
  end

  def checksum
    @chunks.flat_map(&:to_a).each_with_index.sum { _1&.*(_2) || 0 }
  end

  def to_s
    @chunks.flat_map(&:to_a).map { _1.nil? ? "." : _1.to_s }.join
  end
end

disk = Disk.new

input.chars.map(&:to_i).each do |n|
  disk << n
end

disk.compact!

# part_one = disk.checksum
# raise part_one.to_s unless part_one == 6398252054886
# puts "Part One: #{part_one}"

part_two = disk.checksum
puts "Part Two: #{part_two}"
