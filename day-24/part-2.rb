#!/usr/bin/env ruby

file_path = File.expand_path("../input.txt", __FILE__)
input = File.read(file_path).split("\n\n")

ATTR_HASH = {
  "radiation" => 1,
  "bludgeoning" => 1,
  "fire" => 1,
  "slashing" => 1,
  "cold" => 1
}

TYPES_HASH = {
  "immune" => 0,
  "weak" => 2
}

class Group
  attr_accessor :type, :units, :hp, :damage_hash, :attack_type, :initiative, :focus, :target
  def initialize(string, type, boost=0)
    @type = type
    s1 = string.split
    @units = s1[0].to_i
    @hp = s1[4].to_i
    @initiative = s1[-1].to_i
    @attack_damage = s1[-6].to_i + boost
    @attack_type = s1[-5]

    @focus = false
    @target = nil

    @damage_hash = attr_grokker(string[/\((.*)\)/,1])
  end

  def attr_grokker(attributes)
    damage_hash = ATTR_HASH.dup
    return damage_hash if attributes.nil?
    attributes.split(';').map(&:strip).each do |c|
      cs = c.split(" ", 3)
      cs.last.split(',').map(&:strip).each do |a|
        damage_hash[a] = TYPES_HASH[cs[0]]
      end
    end
    damage_hash
  end

  def effective_power
    @units * @attack_damage
  end

  def reset
    @focus = false
    @target = nil
  end

  def enemy
    return "infection" if @type == "immune"
    return "immune"
  end
end

boost = 0
loop do
  immune_groups = input.first.split("\n")[1..-1].map { |g| Group.new(g, "immune", boost) }
  infection_groups = input.last.split("\n")[1..-1].map { |g| Group.new(g, "infection") }
  groups = immune_groups + infection_groups

  loop do
    groups.each { |g| g.reset }

    unit_count = groups.map(&:units).sum

    if immune_groups.map(&:units).sum == 0 || infection_groups.map(&:units).sum == 0
      # part 2
      break if infection_groups.map(&:units).sum > 0
      puts groups.map(&:units).sum
      exit
    end

    # target selection
    groups.sort_by { |g| [g.effective_power, g.initiative] }.reverse.each do |g|
      next unless g.units > 0

      possible = []

      # test attack power against alive enemies who aren't yet the focus of an attack
      groups.select { |e| e.type == g.enemy && !e.focus && e.units > 0 }.each do |e|
        damage = e.damage_hash[g.attack_type] * g.effective_power
        possible << [e, damage]
      end

      # choose attack
      target = possible.select { |a| a.last > 0 }
                       .sort_by { |a| [a.last, a.first.effective_power, a.first.initiative] }
                       .last

      next if target.nil?
      target.first.focus = true
      g.target = target.first.object_id
    end

    # attack phase
    groups.sort_by {|g| g.initiative }.reverse.each do |g|
      next unless g.units > 0
      next unless g.target

      target = groups.select { |e| e.object_id == g.target }.first
      damage = target.damage_hash[g.attack_type] * g.effective_power
      dead = [damage / target.hp, target.units].min

      target.units -= dead
    end

    # prevent stalemate loops
    break if groups.map(&:units).sum == unit_count
  end

  boost += 1
end
