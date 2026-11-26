=begin
Write your code for the 'Bob' exercise in this file. Make the tests in
`bob_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/bob` directory.
=end
class Bob
    def self.hey(x)
        @x = x.strip
        if (@x == @x.upcase) && @x[-1] == '?' && x.count("a-zA-Z") > 0
            return "Calm down, I know what I'm doing!"
        elsif @x == @x.upcase && x.count("a-zA-Z") > 0
            return "Whoa, chill out!"
        elsif @x[-1] == '?'
            return "Sure."
        elsif @x =~ /\A\s*\Z/
            return "Fine. Be that way!"
        else
            return "Whatever."
        end
    end
end