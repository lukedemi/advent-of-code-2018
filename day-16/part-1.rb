#!/usr/bin/env ruby

file_path = File.expand_path("../input.txt", __FILE__)
part1 = File.read(file_path).split("\n\n")[0..-3]
part2 = File.read(file_path).split("\n\n").last.split("\n")

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

  def bonr
    after = @before.dup
    after[@c] = @before[@a] | @before[@b]
    after
  end

  def boni
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

methods = (Sample.instance_methods - Object.methods).map(&:to_s).select { |c| c.length == 4 }

rosetta = {}

samples = 0
part1.each do |sample|
  before = sample.split("\n").first.split(': ').last[1..-2].split(', ').map(&:to_i)
  opcode, a, b, c = sample.split("\n")[1].split(' ').map(&:to_i)
  after = sample.split("\n").last.split(': ').last[2..-2].split(', ').map(&:to_i)

  sample = Sample.new(before, opcode, a, b, c)
  matching = methods.select { |m| sample.send(m) == after }

  matching.each do |value|
    rosetta[sample.opcode] ||= Hash.new(0)
    rosetta[sample.opcode][value] += 1
  end
  samples += 1 if matching.length > 2
end

puts samples
exit

translator = {}
loop do
  break if rosetta.empty?
  solved = rosetta.select {|s| rosetta[s].length == 1 }

  translator[solved.keys.first] = solved.values.first.keys.first
  rosetta.delete(solved.keys.first)

  rosetta.each { |r| r.last.delete_if { |k,v| k == solved.values.first.keys.first } }
end

registers = [0,0,0,0]
part2.each do |p|
  opcode, a, b, c = p.split(' ').map(&:to_i)
  registers = Sample.new(registers, opcode, a, b, c).send(translator[opcode])
end

puts registers.join(' ')
puts registers.first
