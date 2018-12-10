#!/usr/bin/env ruby

file_path = File.expand_path("../input.txt", __FILE__)
input = File.read(file_path).split("\n").map(&:chomp)

class Point
  attr_accessor :pos, :vol
  def initialize(input)
    @pos = input.split('>').first.split('<').last.split(',').map(&:strip).map(&:to_i)
    @vol = input.split('=').last[1..-2].split(',').map(&:strip).map(&:to_i)
  end

  def bump
    @pos = [@pos.first + @vol.first, @pos.last + @vol.last]
  end

  def unbump
    @pos = [@pos.first - @vol.first, @pos.last - @vol.last]
  end
end

points = input.map {|i| Point.new(i)}

seconds = 0
last_x = Float::INFINITY
loop do
  seconds += 1

  points.each { |p| p.bump}

  maxx = points.max_by { |p| p.pos.first }.pos.first
  minx = points.min_by { |p| p.pos.first }.pos.first

  if maxx - minx > last_x
    points.each { |p| p.unbump}
    break
  end

  last_x = maxx - minx
end

puts seconds
