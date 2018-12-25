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

  def distance(bot2)
    (@x - bot2.x).abs + (@y - bot2.y).abs + (@z - bot2.z).abs
  end
end

bots = []
max_bot = nil
max_radius = 0

input.each do |bot|
  p, r = bot.split('>, r=')
  radius = r.to_i
  pos = p.split('<').last.split(',').map(&:to_i)

  bot = Bot.new(pos,radius)
  max_bot = bot if radius > max_radius
  max_radius = radius if radius > max_radius
  bots << bot
end

puts bots.select { |b| b.distance(max_bot) <= max_radius }.length
