=begin
Write your code for the 'Phone Number' exercise in this file. Make the tests in
`phone_number_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/phone-number` directory.
=end
class PhoneNumber
    VALID_PHONE_NUMBER= /^([2-9]\d\d){2}\d{4}$/
    def self.clean(number)
        cleaned_number = number.gsub(/\D/, "").sub(/^1/, "")
        cleaned_number[VALID_PHONE_NUMBER]
    end
end