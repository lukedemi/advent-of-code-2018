#!/usr/bin/env ruby
require 'set'

file_path = File.expand_path("../input.txt", __FILE__)

dimension = 1000
matrix = Array.new(dimension) { Array.new(dimension, 0) }
total = 0

untouched = Set.new

File.read(file_path).split("\n").each do |claim|
  left, top = claim.split[2][0..-1].split(',').map(&:to_i)
  wide, tall = claim.split.last.split('x').map(&:to_i)
  claim = claim.split.first[1..-1].strip.to_i

  untouched << claim

  matrix.each_index do |y|
    next unless y >= top and y < top + tall

    matrix[y].each_index do |x|
      next unless x >= left and x < left + wide

      if matrix[y][x] > 0
        untouched.delete(matrix[y][x])
        untouched.delete(claim)
        next
      end

      matrix[y][x] = claim
    end
  end

end

puts untouched.first
