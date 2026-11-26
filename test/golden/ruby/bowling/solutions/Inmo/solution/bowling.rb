class Game
  class BowlingError < RuntimeError
  end

  def initialize
    @frames = []
    @current = []
    reset_pins
  end

  def roll(pins)
    raise BowlingError if finished?
    raise BowlingError unless pins.between? 0, 10
    raise BowlingError unless pins <= @pins

    @current.push pins
    @pins -= pins
    reset_pins if @pins == 0
    if @current.length == 3 && strike?
      @frames.push @current.sum
      @current = @current[1..]
    end
    if @current.length == 3 && spare?
      @frames.push @current.sum
      @current = @current[2..]
    end
    if !finished? && open? && @current.length == 2
      @frames.push @current.sum
      @current = []
      reset_pins
    end
  end

  def score
    raise BowlingError unless finished?
    @frames.sum
  end

  def reset_pins
    @pins = 10
  end

  def spare?
    @current[0..1].sum == 10
  end

  def strike?
    @current.first == 10
  end

  def open?
    !spare? && !strike?
  end

  def finished?
    @frames.length == 10
  end
end