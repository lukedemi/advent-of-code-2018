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

string = ''
loop do
  tree.sort.to_h.each do |step, dependencies|
    next unless dependencies.empty?
    string += step
    tree.delete(step)
    tree.each do |k, v|
      tree[k].delete(step) if v.include?(step)
    end
    break
  end

  if tree.keys.length == 0
    puts string
    exit
  end
end
