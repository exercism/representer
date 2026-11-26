class RobotSimulator
  property x : Int32
  property y : Int32
  property direction : Symbol
  @current_idx : Int32
  @@directions = [:north, :east, :south, :west]

  enum Side
    Left
    Right
  end

  def initialize(coord : Tuple(Int32, Int32), @direction : Symbol)
    @x, @y = coord
    @current_idx = @@directions.index!(@direction)
  end

  def move(instr : String)
    instr.chars.each do |c|
      case c
        when 'R'
          turn Side::Right
        when 'L'
          turn Side::Left
        when 'A'
          advance
      end
    end
  end

  def turn(side : Side)
    if side == Side::Right
      @current_idx = @current_idx == 3 ? 0 : @current_idx + 1
    else
      @current_idx = @current_idx == 0 ? 3 : @current_idx - 1
    end

    @direction = @@directions[@current_idx]
  end

  def advance
      case @direction
      when :north
        @y += 1
      when :east
        @x += 1
      when :west
        @x -= 1
      when :south
        @y -= 1
      end
  end
  
end
