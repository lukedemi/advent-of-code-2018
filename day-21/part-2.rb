#!/usr/bin/env ruby

require 'set'

file_path = File.expand_path("../input.txt", __FILE__)
input = File.read(file_path).split("\n")

class Sample
  attr_reader :opcode, :after

  def initialize(before, opcode, a, b, c)
    @before = before
    @opcode = opcode
    @a = a
    @b = b
    @c = c
  end

  def addr
    after = @before.dup
    after[@c] = @before[@a] + @before[@b]
    after
  end

  def addi
    after = @before.dup
    after[@c] = @before[@a] + @b
    after
  end

  def mulr
    after = @before.dup
    after[@c] = @before[@a] * @before[@b]
    after
  end

  def muli
    after = @before.dup
    after[@c] = @before[@a] * @b
    after
  end

  def banr
    after = @before.dup
    after[@c] = @before[@a] & @before[@b]
    after
  end

  def bani
    after = @before.dup
    after[@c] = @before[@a] & @b
    after
  end

  def borr
    after = @before.dup
    after[@c] = @before[@a] | @before[@b]
    after
  end

  def bori
    after = @before.dup
    after[@c] = @before[@a] | @b
    after
  end

  def setr
    after = @before.dup
    after[@c] = @before[@a]
    after
  end

  def seti
    after = @before.dup
    after[@c] = @a
    after
  end

  def gtir
    after = @before.dup
    after[@c] = 0
    after[@c] = 1 if @a > @before[@b]
    after
  end

  def gtri
    after = @before.dup
    after[@c] = 0
    after[@c] = 1 if @before[@a] > @b
    after
  end

  def gtrr
    after = @before.dup
    after[@c] = 0
    after[@c] = 1 if @before[@a] > @before[@b]
    after
  end

  def eqir
    after = @before.dup
    after[@c] = 0
    after[@c] = 1 if @a == @before[@b]
    after
  end

  def eqri
    after = @before.dup
    after[@c] = 0
    after[@c] = 1 if @before[@a] == @b
    after
  end

  def eqrr
    after = @before.dup
    after[@c] = 0
    after[@c] = 1 if @before[@a] == @before[@b]
    after
  end
end

constant = input.first.split(' ').last.to_i
instructions = input[1..-1]

set = Set.new
count = 0
registers = [0,0,0,0,0,0]
loop do
  registers = [count,0,0,0,0,0]
  puts registers[0]
  loop do
    instruction_pointer = registers[constant]

    if instruction_pointer >= instructions.length
      puts 'halted'
      break
    end

    current = instructions[instruction_pointer]
    code = current.split(' ').first

    if instruction_pointer == 28
      # still running on 3
      if set.include?(registers[3])
        puts registers[3]
        exit
      end
      set << registers[3]
    end
    a, b, c = current.split(' ')[1..-1].map(&:to_i)

    registers = Sample.new(registers, code, a, b, c).send(code)
    registers[constant] += 1
  end
  count +=1
end
