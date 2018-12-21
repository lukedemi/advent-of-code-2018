#!/usr/bin/env ruby

file_path = File.expand_path("../input.txt", __FILE__)
INPUT = File.read(file_path).chomp
MAP = Hash.new

D = {
  'E' => [1,0],
  'W' => [-1,0],
  'S' => [0,1],
  'N' => [0,-1]
}

def p
  max_y = MAP.keys.max_by { |c| c.last }.last + 1
  min_y = MAP.keys.min_by { |c| c.last }.last - 1

  max_x = MAP.keys.max_by { |c| c.first }.first + 1
  min_x = MAP.keys.min_by { |c| c.first }.first - 1
  (min_y..max_y).each do |y|
    print "#{y}\t"
    (min_x..max_x).each_with_index do |x|
      if MAP[[x,y]].nil?
        print "#"
      else
        print MAP[[x,y]]
      end
    end
    print "\n"
  end
end

def dir_me(direction, coords)
  [coords.first + direction.first, coords.last + direction.last]
end

start = []
coords = [0,0]
left_off = []
INPUT.chars.each do |i|
  if i =~ /(N|S|E|W)/
    coords = dir_me(coords, D[i])
    MAP[coords] = "|" if i =~ /(E|W)/
    MAP[coords] = "-" if i =~ /(N|S)/
    coords = dir_me(coords, D[i])
    MAP[coords] = "."
  elsif i == "^"
    start = coords
    MAP[coords] = "X"
  elsif i == "("
    left_off << coords
  elsif i == "|"
    coords = left_off.last
  elsif i == ")"
    coords = left_off.pop
  end
rescue
  binding.pry
end

possible = []
max = 0
queue = [[start, 0]]
chain = { start => nil }

loop do
  break if queue.empty?
  coords, rooms = queue.shift

  moves = D.values.map { |vm| [coords.first+vm.first, coords.last+vm.last] }
  moves.each do |c|
    next if chain.key?(c) || MAP[c].nil?

    chain[c] = coords
    max = rooms + 1
    possible << coords if (max/2) >= 1000
    queue << [c, rooms + 1]
  end
end
puts possible.uniq.select { |p| MAP[p] =~ /(\||\-)/ }.length
puts max/2
