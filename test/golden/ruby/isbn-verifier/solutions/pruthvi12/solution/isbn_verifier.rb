=begin
Write your code for the 'ISBN Verifier' exercise in this file. Make the tests in
`isbn_verifier_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/isbn-verifier` directory.
=end
class IsbnVerifier
  def self.valid?(digit)
    digit.gsub!("-", "")
    return false unless digit =~ /^\d{9}[\d|X]$/

    digit.chars().each_with_index.map do |e, i|
        e = "10" if e == "X"
       e.to_i * (10 - i)
    end.sum % 11 == 0
  end
end