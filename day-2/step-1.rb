#!/usr/bin/env ruby

file_path = File.expand_path("../input.txt", __FILE__)

two = 0
three = 0

File.read(file_path).split("\n").each do |box_id|
  combos = Hash.new(0)
  box_id.chars.each { |c| combos[c] += 1 }

  three += 1 if combos.values.include?(3)
  two += 1 if combos.values.include?(2)
end

puts three * two
