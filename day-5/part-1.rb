#!/usr/bin/env ruby
require 'set'

file_path = File.expand_path("../input.txt", __FILE__)
input = File.read(file_path).chomp

reaction_matches = Set.new

('a'..'z').each do |l|
  reaction_matches.add("#{l}#{l.capitalize}")
  reaction_matches.add("#{l.capitalize}#{l}")
end


def reaction(string, set)
  last_string_length = string.length + 1
  loop do
    string.chars.count.times do |c|
      string.slice! string[c,2] if set.include?(string[c,2])
    end
    if string.length == last_string_length
      return string
    end
    last_string_length = string.length
  end
end

puts reaction(string, reaction_matches).length
