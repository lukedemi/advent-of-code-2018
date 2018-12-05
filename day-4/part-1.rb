#!/usr/bin/env ruby

file_path = File.expand_path("../input.txt", __FILE__)

guard_minutes = Hash.new
sleep_start = 0
guard = 0

input = File.read(file_path).split("\n").sort.each do |log|
  date = log.split(']').first[1..-1]
  hour, minute = date.split(' ').last.split(':').map(&:to_i)
  year, month, day = date.split(' ').first.split('-').map(&:to_i)

  event = log.split(' ')[3]

  if event == 'up'
    asleep = false

    sleep_start.upto(minute - 1).each do |m|
      guard_minutes[guard][m] += 1
    end

  elsif event == 'asleep'
    asleep = true
    sleep_start = minute
  else
    guard = event[1..-1].to_i
    guard_minutes[guard] ||= Hash.new(0)
  end
end

busiest_guard = guard_minutes.map { |g, m| [g, m.map { |m, v| v }.sum] }.max_by { |g, m| m }.first
busiest_minute = guard_minutes[busiest_guard].max_by{|k,v| v }.first
puts busiest_guard * busiest_minute
