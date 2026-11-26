=begin
Write your code for the 'Bob' exercise in this file. Make the tests in
`bob_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/bob` directory.
=end
class Bob
    def self.hey(remark)
        is_question = ->(remark) { remark.tr("\n\s", '') =~ /^.+\?$/ }
        is_address = ->(remark) { !(remark =~ /\w+/) }
        is_yell = ->(remark) { remark.tr('a-z', '').length == remark.length && remark =~ /[a-zA-Z]+/ }
        is_yell_a_question = ->(remark) { is_question.call(remark) && is_yell.call(remark) }

        case remark
        when is_yell_a_question
            'Calm down, I know what I\'m doing!'
        when is_question
            'Sure.'
        when is_yell
            'Whoa, chill out!'
        when is_address
            'Fine. Be that way!'
        else
            'Whatever.'
        end
    end
end