#!/usr/bin/env ruby

file_path = File.expand_path("../input.txt", __FILE__)
input = File.read(file_path).split("\n")

class Constellation
  attr_accessor :points
  def initialize(new=nil)
    @points = []
    @points << new unless new.nil?
  end

  def same?(new)
    @points.each do |point|
      total = 0
      (0..3).each do |i|
        total += (new[i]-point[i]).abs
      end
      return true if total <= 3
    end
    return false
  end

  def add(new)
    @points << new
  end
end

constellations = []
input.each do |i|
  added = []
  new = i.split(',').map(&:to_i)

  constellations.each do |c|
    added << c if c.same?(new)
  end

  if added.length > 0
    const = Constellation.new
    added.each do |c|
      if c.points.first.is_a? Array
        c.points.each do |point|
          const.add(point)
        end
      else
        const.add(c.points)
      end
      constellations.delete(c)
    end
    const.add(new)
    constellations << const
  else
    constellations << Constellation.new(new)
  end
end

puts constellations.length
