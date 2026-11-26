# https://discourse.julialang.org/t/proper-way-to-overload-operators/19872

# T<:Int means that our struct receive only Int values
# mutable means that we can modify the struct variables
mutable struct Clock
    h::Int
    m::Int

    # Constructor
    Clock(h, m) = begin

        # Convert all to minutes
        allmin = h * 60 + m

        # Get the right minutes using the remainder
        m = allmin % 60

        # Get hours from minutes and 
        # get right hours using the remainder
        h = trunc(Int, (allmin / 60) % 24)

        # If our time is negative we need to add
        # 
        allmin < 0 && begin
            m += 60 
            h += 23

            m == 60 && begin
                h += 1
                m = 0
            end
        end

        new(h,m)
    end
end

# digits() convert a number into an array of numbers
pretify(x) = length(digits(x)) == 2 ? "$x" : "0$x"

showtime(clock::Clock) = begin
    
    h = pretify(clock.h); m = pretify(clock.m)
    
    "\"$h:$m\""
end

# Overload equality verifing if 2 clocks are equal
# comparing their string representation
Base.:(==)(clk1::Clock, clk2::Clock) = showtime(clk1) == showtime(clk2)

# Overload sum
Base.:(+)(clk::Clock, min::Minute) = Clock(clk.h, clk.m + min.value)

# Overload difference
Base.:(-)(clk::Clock, min::Minute) = Clock(clk.h, clk.m - min.value)

Base.show(io::IO, clock::Clock) = print(io, showtime(clock))