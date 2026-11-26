=begin
Write your code for the 'Bob' exercise in this file. Make the tests in
`bob_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/bob` directory.
=end
class Bob
  def self.is_capitals(remark)
    if remark.match(/[A-Za-z]/) == nil
      return false
    end
    for i in 0..(remark.size-1)
      if remark[i] != remark[i].capitalize
        return false
      end
    end
    return true
  end
  
  def self.hey(remark)
    remark = remark.strip
    if remark[-1] == "?" && is_capitals(remark)
      return "Calm down, I know what I'm doing!"
    elsif remark[-1] == "?"
      return "Sure."
    elsif is_capitals(remark)
      return "Whoa, chill out!"
    elsif remark.downcase == "bob" || remark == ""
      return "Fine. Be that way!"
    else
      return "Whatever."
    end
  end

end
      