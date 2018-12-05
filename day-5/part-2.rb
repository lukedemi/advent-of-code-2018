#!/usr/bin/env ruby
require 'set'

file_path = File.expand_path("../input.txt", __FILE__)
input = File.read(file_path).chomp

reaction_matches = Set.new
('a'..'z').each do |l|
  reaction_matches.add("#{l}#{l.capitalize}")
  reaction_matches.add("#{l.capitalize}#{l}")
end

def reaction(string, set, length=2)
  last_string_length = string.length + 1
  loop do
    string.chars.count.times do |c|
      string.slice! string[c,length] if set.include?(string[c,length])
    end
    if string.length == last_string_length
      return string
    end
    last_string_length = string.length
  end
end

smallest = Float::INFINITY
letter = ''
('a'..'z').each do |l|
  string = input.dup
  unit_matches = Set["#{l}", "#{l.capitalize}"]
  unit_removed = reaction(string, unit_matches, 1)

  fully_reacted = reaction(unit_removed, reaction_matches)

  if fully_reacted.length < smallest
    smallest = fully_reacted.length
    letter = l
  end
end

puts smallest
puts letter
