#!/usr/bin/env ruby

require 'pry'
require 'set'

file_path = File.expand_path("../input.txt", __FILE__)
input = File.read(file_path).split("\n")

MAP = {
  '#' => Set.new,
  '~' => Set.new,
  '|' => Set.new,
  '+' => Set.new
}

input.each do |i|
  if i.split(', ').first.split('=').first == "x"
    x = i.split(', ').first.split('=').last
    y = i.split(', ').last.split('=').last
  else
    y = i.split(', ').first.split('=').last
    x = i.split(', ').last.split('=').last
  end

  xr = [x.to_i]
  yr = [y.to_i]
  if x.split("..").length > 1
    xr = Range.new(*x.split("..").map(&:to_i))
  end
  if y.split("..").length > 1
    yr = Range.new(*y.split("..").map(&:to_i))
  end

  xr.each do |xp|
    yr.each do |yp|
      MAP['#'] << [xp,yp]
    end
  end
end

MAX_Y = MAP['#'].max_by { |c| c.last }.last
MIN_Y = MAP['#'].min_by { |c| c.last }.last

MAX_X = MAP['#'].max_by { |c| c.first }.first + 2
MIN_X = MAP['#'].min_by { |c| c.first }.first - 2

def p(min=MIN_Y, max=MAX_Y)
  water = 0
  (MIN_Y..MAX_Y).each do |y|
    next unless y >= min && y <= max
    print "#{y}\t"
    (MIN_X..MAX_X).each_with_index do |x|
      if MAP['#'].include?([x,y])
        print "#"
      elsif MAP['~'].include?([x,y])
        print "~"
      elsif MAP['|'].include?([x,y])
        print "|"
        water += 1
      elsif MAP['+'].include?([x,y])
        print "+"
      else
        print '.'
      end
    end
    print "\n"
  end
  water
end

DOWN = [0,1]
UP = [0,-1]
LEFT = [-1,0]
RIGHT = [1,0]

def dir_me(direction, coords)
  [coords.first + direction.first, coords.last + direction.last]
end

class Element
  attr_accessor :type, :last, :coords, :wall
  def initialize(type, last, coords)
    @coords = coords
    @type = type
    @last = last
    @wall = false
    MAP[@type] << coords if coords.last >= MIN_Y && coords.last <= MAX_Y
  end

  def clay?(direction)
    MAP['#'].include?(dir_me(direction,coords))
  end

  def walled
    @wall = true
  end

  def spawn?(direction)
    current = self
    loop do
      return true if current.coords == direction
      break if current.last == nil
      current = current.last
    end
    false
  end
end

def blocked(coords, direction)
  new_coords = coords
  loop do
    break unless water?(dir_me(direction, new_coords))
    new_coords = dir_me(direction, new_coords)
  end
  return MAP['#'].include?(dir_me(direction, new_coords))
end

def stillify(coords, direction)
  new_coords = coords
  loop do
    break unless water?(new_coords)
    MAP['|'] << new_coords
    MAP['~'].delete(new_coords)
    new_coords = dir_me(direction, new_coords)
  end
end

def water?(coords)
  return true if MAP['|'].include?(coords)
  return true if MAP['~'].include?(coords)
  false
end

def clay?(coords)
  return true if MAP['#'].include?(coords)
  false
end

def all_water
  (MAP['|'] - MAP['~']).length + MAP['~'].length
end

def still_water
  MAP['~'].length
end

CLEANUP = []
def fill_er_up(current, coords, direction)
  loop do
    if current.coords.last > MAX_Y || current.coords.first > MAX_X
      return current.last
    elsif (clay?(dir_me(DOWN, coords)) || water?(dir_me(DOWN, coords))) && direction == DOWN
      if water?(dir_me(DOWN, coords))
        unless blocked(dir_me(DOWN, coords), LEFT) && blocked(dir_me(DOWN, coords), RIGHT)
          current = Element.new('|', current, coords)
          return current
        end
      end

      current = Element.new('~', current, coords)
      current = fill_er_up(current, coords, LEFT)
      left_wall = current.wall
      current = fill_er_up(current, coords, RIGHT)
      right_wall = current.wall
      return current unless left_wall && right_wall

      # bump back up
      coords = dir_me(UP, coords)
    elsif direction == LEFT || direction == RIGHT
      if clay?(dir_me(direction, coords))
        # if we hit a wall,save that for later
        current.walled
        return current
      elsif !clay?(dir_me(DOWN, coords)) && !current.spawn?(dir_me(DOWN, coords))
        # save these coords to stillify
        CLEANUP << coords

        # if there isn't clay to the diagonal, and one of our past selves isn't below us, turn down
        direction = DOWN
        coords = dir_me(direction, coords)
        current = Element.new('|', current, coords)
      else
        # keep going left/right
        coords = dir_me(direction, coords)
        current = Element.new('~', current, coords)
      end
    else
      current = Element.new('|', current, coords)
      coords = dir_me(direction, coords)
    end
  end
end

spring = Element.new('+', nil, [500,0])
direction = DOWN

final = fill_er_up(spring, spring.coords, direction)
CLEANUP.each do |coords|
  next if blocked(coords, LEFT) && blocked(coords, RIGHT)
  stillify(coords, LEFT)
  stillify(coords, RIGHT)
end

puts all_water
