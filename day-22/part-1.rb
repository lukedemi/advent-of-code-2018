#!/usr/bin/env ruby

require 'algorithms'

DEPTH = 5355
TARGET = [14,796]
START = [0,0]

RIGHT = [-1,0]
DOWN = [0,-1]

def p
  (0..TARGET.last).each do |y|
    print "#{y}\t"
    (0..TARGET.first).each_with_index do |x|
      print MAP[[x,y]].type
    end
    print "\n"
  end
end

def dir_me(direction, coords)
  [coords.first + direction.first, coords.last + direction.last]
end

class Point
  attr_accessor :coords, :erosion, :risk_level
  def initialize(coords)
    @coords = coords

    if coords == START || coords == TARGET
      index = 0
    elsif coords.last == 0
      index = coords.first * 16807
    elsif coords.first == 0
      index = coords.last * 48271
    else
      index = MAP[dir_me(DOWN, coords)].erosion * MAP[dir_me(RIGHT, coords)].erosion
    end

    @erosion = (index + DEPTH) % 20183
    @risk_level = @erosion % 3
    @type = type
  end

  def type
    if @risk_level == 0
      return '.'
    elsif @risk_level == 1
      return '='
    else
      return "|"
    end
  end

  def valid_gear(gear)
    if type == "."
      return ["C","T"].include? gear
    elsif type == "="
      return ["C","N"].include? gear
    else
      return ["N","T"].include? gear
    end
  end
end

MAP = Hash.new

def fill_er_up(coords)
  ((0..coords.first).to_a.product((0..coords.last).to_a) - MAP.keys).each do |x,y|
    next unless MAP[[x,y]].nil?
    MAP[[x,y]] = Point.new([x,y])
  end
end

fill_er_up([TARGET.first*1,TARGET.last*1])

puts MAP.map { |k,v| v.risk_level }.sum
