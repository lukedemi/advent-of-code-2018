#!/usr/bin/env ruby

file_path = File.expand_path("../input.txt", __FILE__)
input = File.read(file_path).chomp.split(' ').map(&:to_i)

metadata = []
def recursive(tree, progress, metadata)
  child_nodes = tree[progress]
  metadata_entries = tree[progress + 1]

  progress += 2
  child_nodes.to_i.times.each do
    progress = recursive(tree, progress, metadata)
  end

  entries = tree[progress,metadata_entries]
  metadata << entries
  progress += entries.length
  return progress
end

recursive(input, 0, metadata)
puts metadata.flatten.sum
