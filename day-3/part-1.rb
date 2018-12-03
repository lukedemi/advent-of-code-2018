#!/usr/bin/env ruby

file_path = File.expand_path("../input.txt", __FILE__)

dimension = 1000
matrix = Array.new(dimension) { Array.new(dimension, 0) }

total = 0
File.read(file_path).split("\n").each do |claim|
  left, top = claim.split[2][0..-1].split(',').map(&:to_i)
  wide, tall = claim.split.last.split('x').map(&:to_i)
  claim = claim.split.first[1..-1].strip.to_i

  matrix.each_index do |y|
    next unless y >= top and y < top + tall

    matrix[y].each_index do |x|
      next unless x >= left and x < left + wide

      total += 1 if matrix[y][x] == 1

      matrix[y][x] += 1
    end
  end
end

puts total
