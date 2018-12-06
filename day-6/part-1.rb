#!/usr/bin/env ruby
require 'set'

file_path = File.expand_path("../input.txt", __FILE__)
input = File.read(file_path).split("\n").map(&:chomp).map { |x| x.split(', ').map(&:to_i) }

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
    input.each do |i|
      key = [x,y].join
      matrix[key] ||= {}
      matrix[key][i.join] = distance_from([x,y], i)
    end
  end
end

closest = Hash.new(0)
infinite = Set.new

(y_start..y_end).each do |y|
  (x_start..x_end).each do |x|
    key = [x,y].join
    winners = matrix[key].group_by { |x,v| v }.min
    next if winners.last.count > 1

    if [x_start, x_end].include?(x) or [y_start, y_end].include?(y)
      infinite.add(winners.last.flatten.first)
    end

    closest[winners.last.flatten.first] += 1
  end
end

infinite.each { |v| closest.delete(v) }

puts closest
puts closest.max_by { |k,v| v }.last

