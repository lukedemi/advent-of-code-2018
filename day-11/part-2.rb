#!/usr/bin/env ruby
input = 7347

dimension = 300
matrix = Array.new(dimension) { Array.new(dimension, 0) }

dimension.times do |y|
  dimension.times do |x|
    rack_id = x + 10
    power_level = (rack_id * y) + input
    power_level = power_level * rack_id
    power_level = power_level.to_s.chars[-3].to_i - 5
    matrix[y][x] = power_level
  end
end

highest_coords = [0,0]
highest = 0
(0..dimension).each do |size|
  (0..dimension-size).each do |y|
    (0..dimension-size).each do |x|
      value = 0
      (0..size-1).each do |sy|
        (0..size-1).each do |sx|
          value += matrix[y + sy][x + sx]
        end
      end
      if value > highest
        highest_coords = [x,y,size]
        highest = value
      end
    end
  end
end
puts highest_coords.join(',')
