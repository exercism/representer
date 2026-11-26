=begin
Write your code for the 'Bob' exercise in this file. Make the tests in
`bob_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/bob` directory.
=end
class Bob
  def self.hey(remark)
      remark.strip!
      if(remark == "")
        return "Fine. Be that way!"
      elsif ((remark.match(/[a-zA-Z]/) != nil) and (remark == remark.upcase) and (remark.chars.last == '?'))
          return "Calm down, I know what I'm doing!"  
      elsif(remark.chars.last == '?')
          return "Sure."
      elsif ((remark.match(/[a-zA-Z]/) != nil) and (remark == remark.upcase))
          return "Whoa, chill out!"
      else
          return "Whatever."  
      end  
  end  
end