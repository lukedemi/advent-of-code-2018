#!/usr/bin/env ruby

input = 702831

board = []
board << 3
board << 7

class Elf
  attr_accessor :current_recipe, :recipe_index
  def initialize(name)
    @current_recipe = nil
    @recipe_index = nil
    @name = name
  end
end

elves = []
elves << Elf.new('fred')
elves << Elf.new('alice')

output = []
count = 2
loop do
  #first the elves select their recipes
  recipe = 0
  elves.each do |elf|
    if elf.current_recipe != nil
      jump = elf.current_recipe + 1
      elf.current_recipe = board[(elf.recipe_index+jump) % board.length]
      elf.recipe_index = (elf.recipe_index+jump) % board.length
    else
      elf.current_recipe = board[recipe]
      elf.recipe_index = recipe
      recipe +=1
    end
  end

  # then the combine their recipes
  total = elves.map(&:current_recipe).sum

  total.to_s.chars.each do |new_recipe|
    board << new_recipe.to_i
    count += 1
    if count >= (input + 10)
      puts board[-10..-1].join
      exit
    end
  end
end
