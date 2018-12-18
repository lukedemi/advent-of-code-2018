#!/usr/bin/env ruby

require 'pry'
require 'set'

file_path = File.expand_path("../input.txt", __FILE__)
input = File.read(file_path).split("\n")

grid = Hash.new
input.each_with_index do |y, y_i|
  y.chars.each_with_index do |x, x_i|
    grid[[x_i,y_i]] = x
  end
end

MAX_X = grid.keys.map(&:first).max + 1
MAX_Y = grid.keys.map(&:last).max + 1

pattern = {}
minutes = 0

def simulate(grid)
  new_grid = Hash.new
  MAX_Y.times do |y|
    MAX_X.times do |x|
      sub = Hash.new(0)
      [-1,0,1].each do |y_m|
        [-1,0,1].each do |x_m|
          next if x_m == 0 && y_m == 0
          next if sub[grid[[x+x_m,y+y_m]]].nil?
          sub[grid[[x+x_m,y+y_m]]] += 1
        end
      end

      new_grid[[x,y]] = grid[[x,y]]
      if grid[[x,y]] == '.'
        new_grid[[x,y]] = '|' if sub['|'] > 2
      elsif grid[[x,y]] == '|'
        new_grid[[x,y]] = '#' if sub['#'] > 2
      elsif grid[[x,y]] == '#'
        new_grid[[x,y]] = '.' if sub['#'] == 0 || sub['|'] == 0
      end
    end
  end
  new_grid
end

loop do
  minutes += 1
  grid = simulate(grid)

  next unless minutes == 10
  counts = grid.values.uniq.map { |x| [x, grid.values.count(x)] }.to_h
  puts counts['#'] * counts["|"]
  exit
end
