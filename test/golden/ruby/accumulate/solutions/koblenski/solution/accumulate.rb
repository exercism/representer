class Array
  def accumulate
    acc = []
    each { |elem| acc << yield(elem) }
    acc
  end
end