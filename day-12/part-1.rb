#!/usr/bin/env ruby
file_path = File.expand_path("../input.txt", __FILE__)

state = File.read(file_path).split("\n").first.split(':').last.strip.chars

valid = File.read(file_path)
            .split("\n")[2..-1]
            .map { |x| x.split('=>') }
            .map {|x| x.map(&:strip) }
            .select { |x| x.last == "#" }
            .map {|x| x.first }

off_from_zero = 0
alive_plants = []
(1..20).each do |i|
  # keep at least four dots on each side
  if state[-4..-1].join != "...."
    state = state.insert(-1, ".", ".", ".", ".")
  elsif state[0..3].join != "...."
    state = state.insert(0, ".", ".", ".", ".")
    off_from_zero -= 3
  end

  alive_plants = []
  plant_pot = off_from_zero
  state.each_cons(5).each do |x|
    if valid.include?(x.join)
      alive_plants << plant_pot
    end
    plant_pot +=1
  end

  # wipe the state
  state = state.map { |x| x = "." }

  plant_pot = off_from_zero
  state.each do |x|
    state[plant_pot+off_from_zero.abs+2] = "#" if alive_plants.include?(plant_pot)
    plant_pot +=1
  end
end

puts alive_plants.sum
