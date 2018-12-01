#!/usr/bin/env ruby

file_path = File.expand_path("../input.txt", __FILE__)

frequency = 0
File.foreach(file_path) { |change| frequency += change.to_i }

puts frequency
