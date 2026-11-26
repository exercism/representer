class Grains
    def self.square(square_num)
        if square_num < 1 || square_num > 64
            raise ArgumentError
        end

        2**(square_num - 1)
    end

    def self.total
        2**64 - 1
    end
end
