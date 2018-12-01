#!/usr/bin/env ruby
require 'set'

file_path = File.expand_path("../input.txt", __FILE__)

frequency = 0
previous_frequencies = Set.new

loop do
  File.foreach(file_path) do |change|
    frequency += change.to_i

    if previous_frequencies.include?(frequency)
      puts frequency
      exit
    end

    previous_frequencies.add(frequency)
  end
end
