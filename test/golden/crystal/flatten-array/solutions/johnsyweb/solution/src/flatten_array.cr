module FlattenArray
  def self.flatten(input : Array) : Array
    output = [] of Int32
    input.each do |e|
      case e
      when Nil   then next
      when Array then flatten(e).each { |i| output << i }
      else            output << e
      end
    end
    output
  end
end
