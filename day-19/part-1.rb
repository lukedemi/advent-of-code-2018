#!/usr/bin/env ruby

file_path = File.expand_path("../input.txt", __FILE__)
input = File.read(file_path).split("\n")

def addr(registers, a, b, c)
  registers[c] = registers[a] + registers[b]
  registers
end

def addi(registers, a, b, c)
  registers[c] = registers[a] + b
  registers
end

def mulr(registers, a, b, c)
  registers[c] = registers[a] * registers[b]
  registers
end

def muli(registers, a, b, c)
  registers[c] = registers[a] * b
  registers
end

def banr(registers, a, b, c)
  registers[c] = registers[a] & registers[b]
  registers
end

def bani(registers, a, b, c)
  registers[c] = registers[a] & b
  registers
end

def bonr(registers, a, b, c)
  registers[c] = registers[a] | registers[b]
  registers
end

def boni(registers, a, b, c)
  registers[c] = registers[a] | b
  registers
end

def setr(registers, a, b, c)
  registers[c] = registers[a]
  registers
end

def seti(registers, a, b, c)
  registers[c] = a
  registers
end

def gtir(registers, a, b, c)
  registers[c] = 0
  registers[c] = 1 if a > registers[b]
  registers
end

def gtri(registers, a, b, c)
  registers[c] = 0
  registers[c] = 1 if registers[a] > b
  registers
end

def gtrr(registers, a, b, c)
  registers[c] = 0
  registers[c] = 1 if registers[a] > registers[b]
  registers
end

def eqir(registers, a, b, c)
  registers[c] = 0
  registers[c] = 1 if a == registers[b]
  registers
end

def eqri(registers, a, b, c)
  registers[c] = 0
  registers[c] = 1 if registers[a] == b
  registers
end

def eqrr(registers, a, b, c)
  registers[c] = 0
  registers[c] = 1 if registers[a] == registers[b]
  registers
end

constant = input.first.split(' ').last.to_i
instructions = input[1..-1]

registers = [0,0,0,0,0,0]
loop do
  instruction_pointer = registers[constant]

  current = instructions[instruction_pointer]
  code = current.split(' ').first
  a, b, c = current.split(' ')[1..-1].map(&:to_i)

  registers = send(code, registers, a, b, c)

  registers[constant] += 1
rescue NoMethodError
  puts registers[0]
  exit
end
