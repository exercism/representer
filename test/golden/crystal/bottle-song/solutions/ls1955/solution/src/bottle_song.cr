module BottleSong
  def self.recite(start_bottles : Int32, take_down : Int32) : Array(String)
    quantities = %w[no one two three four five six seven eight nine ten]
    result = [] of String

    take_down.times do |take_amount|
      curr_bottle = start_bottles - take_amount
      2.times do
        quantity = quantities[curr_bottle].capitalize
        result << "#{quantity} green #{bottle_noun curr_bottle} hanging on the wall,"
      end
      result << "And if one green bottle should accidentally fall,"
      result << "There'll be #{quantities[curr_bottle - 1]} green #{bottle_noun curr_bottle - 1} hanging on the wall."

      result << "" unless take_amount == take_down - 1
    end

    result
  end

  def self.bottle_noun(num)
    num == 1 ? "bottle" : "bottles"
  end
end
