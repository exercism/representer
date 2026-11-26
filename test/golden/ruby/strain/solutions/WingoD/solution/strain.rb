class Array
  def keep
    kept = []
    each do |e|
      kept << e if yield(e)
    end
    kept
  end

  def discard
    kept = []
    each do |e|
      kept << e unless yield(e)
    end
    kept
  end
end