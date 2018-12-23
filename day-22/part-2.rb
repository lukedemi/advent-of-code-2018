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

fill_er_up([TARGET.first*2,TARGET.last*2])

#puts MAP.map { |k,v| v.risk_level }.sum

VALID_MOVES = [[-1,0],[1,0],[0,-1],[0,1]]

queue = Containers::PriorityQueue.new
queue.push([START, 0, "T"], 0)

best = Hash.new(Float::INFINITY)
best[[START, "T"]] = Float::INFINITY

other_gear = {
  "N" => ["C","T"],
  "T" => ["C","N"],
  "C" => ["N","T"]
}

possible = []

loop do
  break if queue.empty?
  coords, minutes, current_gear = queue.pop

  moves = VALID_MOVES.map { |vm| [coords.first+vm.first, coords.last+vm.last] }
  moves.each do |c|
    next if c.first < 0 || c.last < 0 || MAP[c].nil?

    new_minutes = minutes.dup
    new_minutes += 1

    if c == TARGET && current_gear == "T"
      puts new_minutes
      exit
    end

    if MAP[c].valid_gear(current_gear)
      next if best[[c, current_gear]] <= new_minutes
      best[[c,current_gear]] = new_minutes
      queue.push([c, new_minutes, current_gear], -new_minutes)
    else
      other_gear[current_gear].each do |gear|
        next unless MAP[coords].valid_gear(gear)
        new_minutes = new_minutes.dup
        new_minutes += 7

        next if best[[c, gear]] <= new_minutes
        best[[c,gear]] = new_minutes
        queue.push([c, new_minutes, gear], -new_minutes)
      end
    end
  end
end
