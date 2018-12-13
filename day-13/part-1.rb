#!/usr/bin/env ruby

file_path = File.expand_path("../input.txt", __FILE__)
input = File.read(file_path).split("\n")

height = input.length
width = 0
input.each  do |y|
  if y.length > width
    width = y.length
  end
end

def p(matrix)
  matrix.each_with_index do |y, i|
    print i
    print "\t"
    y.each do |x|
      print x.to_s
    end
    print "\n"
  end
end

class Train
  attr_accessor :coords, :train, :current_track, :last_track, :crashed
  def initialize(coords,train)
    @coords = coords
    @train = train
    @current_track = nil
    @last_track = nil
    @next_direction = 0
    @crashed = false
  end

  def crash
    @crashed = true
  end

  def to_s
    @train
  end

  def corner
    if @current_track=="\\" && @train==">"
      @train = turn_right
    elsif @current_track=="\\" && @train=="<"
      @train = turn_right
    elsif @current_track=="\\" && @train=="^"
      @train = turn_left
    elsif @current_track=="\\" && @train=="v"
      @train = turn_left
    elsif @current_track=="/" && @train=="^"
      @train = turn_right
    elsif @current_track=="/" && @train=="<"
      @train = turn_left
    elsif @current_track=="/" && @train==">"
      @train = turn_left
    elsif @current_track=="/" && @train=="v"
      @train = turn_right
    else
      raise
    end
  end

  def intersection
    if @next_direction % 3 == 0
      @train = turn_left
    elsif @next_direction % 3 == 2
      @train = turn_right
    end
    @next_direction +=1
  end

  def turn_left
    return 'v' if @train == '<'
    return '>' if @train == 'v'
    return '<' if @train == '^'
    return '^' if @train == '>'
  end

  def turn_right
    return '<' if @train == 'v'
    return '>' if @train == '^'
    return '^' if @train == '<'
    return 'v' if @train == '>'
  end

  def direction
    return [1,0] if @train == 'v'
    return [-1,0] if @train == '^'
    return [0,-1] if @train == '<'
    return [0,1] if @train == '>'
    raise
  end

  def original
    return '|' if @train == 'v'
    return '|' if @train == '^'
    return '-' if @train == '<'
    return '-'  if @train == '>'
    raise
  end

  def next
    [direction.first + @coords.first, direction.last + @coords.last]
  end
end

matrix = Array.new(height) { Array.new(width, nil) }

trains = []
input.each_with_index do |row,y|
  row.chars.each.with_index do |v,x|
    if v =~ /(v|>|<|\^)/
      train = Train.new([y,x],v)
      trains << train
      matrix[y][x] = train
    else
      matrix[y][x] = v
    end
  end
end

# set the initial "current track"
trains.each do |train|
  train.current_track = train.original
end

loop do
  trains.sort_by {|t| t.coords}.each do |train|
    next if train.crashed

    current_coords = [train.coords.first, train.coords.last]
    new_track = matrix[train.next.first][train.next.last]

    # crash handling
    if new_track.is_a? Train
      puts new_track.coords.reverse.join(',')
      exit
      matrix[new_track.coords.first][new_track.coords.last] = new_track.current_track
      new_track.crash

      matrix[train.coords.first][train.coords.last] = train.current_track
      train.crash
      next
    end

    # update train current_track with the new track
    train.last_track = train.current_track
    train.current_track = new_track

    # move the train forward
    matrix[train.next.first][train.next.last] = train
    train.coords = train.next

    # set the old track back to normal
    matrix[current_coords.first][current_coords.last] = train.last_track

    if new_track == '+'
      train.intersection
    elsif new_track == "\\" || new_track == "/"
      train.corner
    end

    if trains.select {|t| !t.crashed }.length == 1
      puts train.coords.reverse.join(',')
      exit
    end

  end
end

