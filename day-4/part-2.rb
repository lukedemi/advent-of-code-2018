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

guard_id, minute = guard_minutes.map { |g, m| [g, m.max_by { |m, v| v }] }.max_by { |x| x.last }
puts guard_id * minute.first
