#!/usr/bin/env ruby

file_path = File.expand_path("../input.txt", __FILE__)
input = File.read(file_path).split("\n")

input.product(input).each do |box_id, box_id2|
  off_by, index = 0

  box_id.length.times do |i|
    if box_id[i] != box_id2[i]
      off_by += 1
      index = i
    end
  end

  if off_by == 1
    box_id.slice!(index)
    puts box_id
    exit
  end
end
