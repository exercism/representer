# Please implement your solution to proverb in this file
module Proverb
  extend self

  def recite(str_array)
    count = 1
    proverb_array = [] of String
    if str_array.size > 0
    	if str_array.size > 1
    		while count < str_array.size
      		proverb_array << "For want of a #{str_array[count+1]} the #{str_array[count]} was lost."
    			count += 1
  			end
			end
      proverb_array << "And all for the want of a #{str_array[0]}."
  	end
    return proverb_array
  end
end
