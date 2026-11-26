class Robot
  INCREMENTS = {north: [0,1], east: [1,0], south: [0,-1], west: [-1,0]}
  VALID_BEARINGS = INCREMENTS.keys

  attr_reader :bearing, :coordinates

  def orient(direction)
    raise ArgumentError unless VALID_BEARINGS.include? direction
    @bearing = direction
  end

  def turn_right
    @bearing = VALID_BEARINGS[VALID_BEARINGS.index(@bearing) + 1] || :north
  end

  def turn_left
    @bearing = VALID_BEARINGS[VALID_BEARINGS.index(@bearing) - 1]
  end

  def at(*coordinates)
    @coordinates = coordinates
  end

  def advance
    @coordinates = @coordinates.zip(INCREMENTS[@bearing]).map { |a, b| a + b }
  end
end

class Simulator
  COMMANDS = { 'L' => :turn_left, 'R' => :turn_right, 'A' => :advance }

  def instructions(command_str)
    command_str.chars.map { |cmd| COMMANDS[cmd] }
  end

  def place(robot, x: 0, y: 0, direction: :north)
    robot.at(x, y)
    robot.orient(direction)
  end

  def evaluate(robot, command_str)
    instructions(command_str).each { |cmd| robot.send(cmd) }
  end
end