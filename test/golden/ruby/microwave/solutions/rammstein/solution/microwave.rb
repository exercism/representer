class Microwave
	attr_reader :timer

	def initialize(input)
		@min = input / 100
		@sec = input % 100
		@min, @sec = [@min+1, @sec-60] if @sec > 59
		@timer = "%02d:%02d" % [@min, @sec]
	end
end