




class IsbnVerifier
  def self.valid?(number)
    number.gsub!("-", "")
    return false unless number =~ /^\d{9}[\d|X]$/
    number
    .chars()
    .each_with_index
    .map do |num, ind|
        num = "10" if num == "X"
       num.to_i * (10 - ind)
    end.sum % 11 == 0
  end
end






# class IsbnVerifier

#   def self.valid?(number)
  
#     number.gsub("-","")
#     return false unless number =~ /^\d{9}[\d|X]$/
  
#     array = number.gsub("-","").split("")
#     count = 10
#     sum = 0
#     array.each do |i|
#       # sum = 0
#       if i == 'X'
#         i = 10
#       else 
#         i=i
        
#       # print i
#       sum = sum + (i.to_i * count)  
#       count = count-1
#     end
#      sum% 11 == 0
#     end

#   end 

# end