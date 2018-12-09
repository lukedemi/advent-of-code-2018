#!/usr/bin/env ruby

score = {}
current = nil
player_count = 468
highest_marble = 71010

marble = 0

class LukedList
  attr_accessor :value, :before, :after

  def initialize(value, before, after)
     @value = value
     @before = before || self
     @after = after || self
  end

  def insert_after(value)
    new = LukedList.new(value, self.before, self)
    self.before.after = new
    self.before = new
    new
  end

  def delete
    self.before.after = self.after
    self.after.before = self.before
    self.before
  end

  def print
    puts "#{@before.value}|#{@value}|#{@after.value}"
  end
end

score = {}
loop do
  player_count.times do |player|
    if marble == 0
      current = LukedList.new(marble, nil, nil)
    elsif marble % 23 == 0
      current = current.after.after.after.after.after.after.after
      score[player] ||= 0
      score[player] += marble
      score[player] += current.value
      current = current.delete
    else
      current = current.before.insert_after(marble)
    end

    if marble == highest_marble
      puts score.max_by {|k,v| v}
      exit
    end
    marble += 1
  end
end
