#!/usr/bin/env ruby
require 'set'

file_path = File.expand_path("../input.txt", __FILE__)
input = File.read(file_path).split("\n").map(&:chomp).map { |x| x.split(', ').map(&:to_i) }

distance = 10000

x_start = input.min_by { |coords| coords.first }.first
x_end = input.max_by { |coords| coords.first }.first

y_start = input.min_by { |coords| coords.last }.last
y_end = input.max_by { |coords| coords.last }.last

def distance_from(coord1, coord2)
  (coord1.first - coord2.first).abs + (coord1.last - coord2.last).abs
end

matrix = Hash.new

(y_start..y_end).each do |y|
  (x_start..x_end).each do |x|
    key = [x,y].join
    total_d = 0

    input.each do |i|
      total_d += distance_from([x,y], i)
    end

    matrix[key] = total_d if total_d < distance
  end
end

puts matrix.keys.length
