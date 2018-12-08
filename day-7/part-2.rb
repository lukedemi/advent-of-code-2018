#!/usr/bin/env ruby

file_path = File.expand_path("../input.txt", __FILE__)
input = File.read(file_path).split("\n").map(&:chomp)

tree = Hash.new

input.each do |i|
  split = i.gsub('must be finished before step', '').split(' ')
  first = split[1]
  after = split[2]

  tree[after] ||= Array.new
  tree[first] ||= Array.new
  tree[after] << first
end

class Worker
  def initialize
    @seconds = 0
  end

  def current_task
    return false if @seconds == 0
    return @letter
  end

  def begin(letter, modifier)
    @letter = letter
    @seconds = letter.ord - 64 + modifier
  end

  def ready?
    return true unless @seconds > 0
  end

  def tick
    return false if @seconds == 0
    @seconds -= 1
    return @letter if @seconds == 0
  end
end

modifier = 60

workers = []
5.times { workers << Worker.new }

in_progress = []
seconds = 0
loop do
  tree.sort.to_h.each do |step, dependencies|
    next if in_progress.include?(step) || !dependencies.empty?

    worker = workers.select { |w| w.ready? }.first
    next unless worker

    worker.begin(step, modifier)
    in_progress << step
  end

  workers.each do |w|
    output = w.tick
    next unless output

    in_progress.delete(output)
    tree.delete(output)
    tree.each do |k, v|
      tree[k].delete(output) if v.include?(output)
    end
  end

  seconds += 1
  if tree.keys.length == 0
    puts seconds
    exit
  end
end
