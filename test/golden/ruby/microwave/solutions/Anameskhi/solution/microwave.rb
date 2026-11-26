class Microwave
    def initialize(total_seconds)
      seconds = total_seconds % 100
      @minutes = (total_seconds/100) + (seconds/60)
      @seconds = seconds % 60
    end
  def timer
   format('%02d:%02d',@minutes,@seconds)
    
    end
  end
