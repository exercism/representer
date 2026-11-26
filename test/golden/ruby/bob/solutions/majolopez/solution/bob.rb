=begin
Write your code for the 'Bob' exercise in this file. Make the tests in
`bob_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/bob` directory.
=end
class Bob 
  def self.hey(remark)
    response = "Whatever."
    response = "Sure." if remark.strip.slice(-1) == "?"
    response = "Fine. Be that way!" if remark.strip == ""
    
    if(remark.count("a-zA-Z") > 0)
        response = "Whoa, chill out!" if  remark == remark.upcase
        response = "Calm down, I know what I'm doing!" if remark.slice(-1) == "?" && remark == remark.upcase
    end
  response
  end
end