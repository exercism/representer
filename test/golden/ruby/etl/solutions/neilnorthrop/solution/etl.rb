=begin
Write your code for the 'ETL' exercise in this file. Make the tests in
`etl_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/etl` directory.
=end

class ETL

	def self.transform(input)
		output = {}

		input.each do |k,v|
			v.each { |value| output[value.downcase] = k }
		end

		output
	end

end
