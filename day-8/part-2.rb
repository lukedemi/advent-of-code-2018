#!/usr/bin/env ruby

file_path = File.expand_path("../input.txt", __FILE__)
input = File.read(file_path).chomp.split(' ').map(&:to_i)

def recursive(tree, progress)
  child_nodes = tree[progress]
  metadata_entries = tree[progress + 1]

  progress += 2
  cna = {}
  child_nodes.to_i.times.each do |i|
    progress, value = recursive(tree, progress)
    cna[i + 1] = value
  end

  entries = tree[progress, metadata_entries]

  value = 0
  if child_nodes == 0
    value = entries.sum
  else
    entries.each {|i| value += cna[i].to_i }
  end

  progress += entries.length
  return progress, value
end

_, value = recursive(input, 0)
puts value
