#!/usr/bin/env ruby

input = "702831"
final = "000000"

board = []
board << 3
board << 7
final = final[-5..-1] + 3.to_s
final = final[-5..-1] + 7.to_s

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
    final = final[-5..-1] + new_recipe

    if input == final
      answer = board.length - input.length
      puts answer
      exit
    end
  end
end
