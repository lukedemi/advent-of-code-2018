#!/usr/bin/env ruby

file_path = File.expand_path("../input.txt", __FILE__)
input = File.read(file_path).split("\n")

class Bot
  attr_accessor :x, :y, :z, :radius
  def initialize(position, radius)
    @x = position[0]
    @y = position[1]
    @z = position[2]
    @radius = radius
  end

  def distance(x, y, z, fudge)
    (@x/fudge - x).abs + (@y/fudge - y).abs + (@z/fudge - z).abs
  end
end

def final(x,y,z)
  (0 - x).abs + (0 - y).abs + (0 - z).abs
end

bots = []
input.each do |bot|
  p, r = bot.split('>, r=')
  radius = r.to_i
  pos = p.split('<').last.split(',').map(&:to_i)

  bots << Bot.new(pos,radius)
end

best = 0
fudge = 100000000

min_x = bots.map(&:x).min
min_y = bots.map(&:y).min
min_z = bots.map(&:z).min

max_x = bots.map(&:x).max
max_y = bots.map(&:y).max
max_z = bots.map(&:z).max

loop do
  possible = []
  (min_x/fudge..max_x/fudge).each do |x|
    (min_y/fudge..max_y/fudge).each do |y|
      (min_z/fudge..max_z/fudge).each do |z|
        bots_in_range = 0
        bots.each do |bot|
          bots_in_range += 1 if bot.distance(x,y,z,fudge) <= bot.radius/fudge
        end

        if bots_in_range >= best
          best = bots_in_range
          possible << [final(x,y,z), bots_in_range, [x, y, z]]
        end
      end
    end
  end

  max = possible.max_by { |p| p[1] }
  most_and_closest = possible.select { |p| p[1] == max[1] }.sort_by { |p| p.first }.first
  x,y,z = most_and_closest.last

  min_x = x * fudge - fudge
  min_y = y * fudge - fudge
  min_z = z * fudge - fudge

  max_x = x * fudge + fudge
  max_y = y * fudge + fudge
  max_z = z * fudge + fudge

  fudge = fudge/10
  if fudge == 0
    puts most_and_closest.first
    exit
  end
end
