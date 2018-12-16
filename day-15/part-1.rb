#!/usr/bin/env ruby

require 'pry'
require 'set'

file_path = File.expand_path("../input.txt", __FILE__)
input = File.read(file_path).split("\n")

# size the matrix
height = input.length
width = 0
input.each do |y|
  if y.length > width
    width = y.length
  end
end

MATRIX = Array.new(height) { Array.new(width, nil) }
VALID_MOVES = [[-1,0],[1,0],[0,-1],[0,1]]

# pretty print the matrix
def p
  MATRIX.each_with_index do |y, i|
    print i
    print "\t"
    us = []
    y.each do |x|
      us << x if x.is_a? Unit
      print x.to_s
    end
    us.each { |u| print " #{u.type}(#{u.hp})" }
    print "\n"
  end
  return
end

class Unit
  attr_accessor :type, :coords, :hp, :dead
  def initialize(type, coords)
    @hp = 200
    @type = type
    @coords = coords
    @dead = false
  end

  def killed
    MATRIX[coords.first][coords.last] = "."
    @dead = true
  end

  def enemy
    return 'E' if @type == 'G'
    return 'G' if @type == 'E'
  end

  def combatants
    VALID_MOVES.map { |vm| [coords.first+vm.first, coords.last+vm.last] }
               .select { |m| MATRIX[m.first][m.last].is_a? Unit }
               .select { |m| MATRIX[m.first][m.last].type == self.enemy }
               .map { |m| MATRIX[m.first][m.last] }
  end

  def to_s
    @type
  end

  def pathfinding(enemies)
    e_coords = enemies.map { |e| e.coords }
    possible = []
    queue = [[self.coords, 0]]
    chain = { self.coords => nil }

    loop do
      break if queue.empty?
      coords, steps = queue.shift

      moves = VALID_MOVES.map { |vm| [coords.first+vm.first, coords.last+vm.last] }
      moves.sort.each do |c|
        next if chain.key?(c)

        c_value = MATRIX[c.first][c.last]
        next if c_value == "#"
        if c_value.is_a? Unit
          next unless c_value.type == self.enemy
          queue.select! { |s| s.last < steps }
          possible << [c, steps]
        end

        chain[c] = coords
        queue << [c, steps + 1]
      end
    end

    return false if possible.length == 0
    min = possible.min_by { |c| c.last }.last
    sorted = possible.select { |c| c.last == min }.sort.first.first

    loop do
      return sorted if chain[sorted] == self.coords
      return false if chain[sorted] == nil
      sorted = chain[sorted]
    end
  end
end

units = []

def distance(x,y)
  distance = (x.first - y.first).abs + (x.last - y.last).abs
end

# build the matrix
input.each_with_index do |y,y_i|
  y.chars.each_with_index do |x,x_i|
    if ['G', 'E'].include? x
      unit = Unit.new(x, [y_i,x_i])
      MATRIX[y_i][x_i] = unit
      units << unit
    else
      MATRIX[y_i][x_i] = x
    end
  end
end

round = 0
loop do
  #puts "########### #{round} ############"
  #p
  units.sort_by {|u| u.coords }.each do |unit|
    next if unit.dead
    # select all the enemy units (minus itself)
    combat_units = units.select {|u| u.type == unit.enemy }
                        .reject {|u| u.dead }

    # end game
    if combat_units.length == 0
      hp = units.reject {|u| u.dead }.map {|u| u.hp}.sum
      puts hp
      puts round
      puts hp * round
      exit
    elsif unit.combatants.length == 0
      next_move = unit.pathfinding(combat_units)

      next if next_move == false

      # move the unit
      MATRIX[unit.coords.first][unit.coords.last] = '.'
      MATRIX[next_move.first][next_move.last] = unit
      unit.coords = [next_move.first,next_move.last]
    end

    # combat
    next unless unit.combatants.length > 0
    min = unit.combatants.map { |u| u.hp }.min
    combatant = unit.combatants.select { |u| u.hp == min }
    combatant = combatant.sort_by { |u| u.coords }.first if combatant.is_a? Array
    combatant.hp -= 3
    combatant.killed if combatant.hp < 1
  end
  round += 1
end
