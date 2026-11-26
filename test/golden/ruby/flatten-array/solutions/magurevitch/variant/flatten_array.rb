module FlattenArray
    def self.flatten(list)
        output = Array.new
        list.each do |element|
            if element.is_a? Array
                output.concat(self.flatten(element))
            elsif !element.nil?
                output.unshift(element)
            end
        end
        output
    end
end