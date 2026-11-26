=begin
Write your code for the 'Transpose' exercise in this file. Make the tests in
`transpose_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/transpose` directory.
=end

# rows to columns, columns to rows
class Transpose
  def self.transpose(input)
    # replace the spaces with blank chars to hang onto them
    # split on newlines
    # convert to a hash map of chars
    strings = input.gsub(" ", "_").split("\n").map(&:chars)

    # find the longest string, this is the number of columns
    max_length = strings.map(&:length).max

    # for each line in strings, pad with spaces to match the length
    # then transpose
    # then join each line, replacing underscore with spaces
    # then join the whole thing on newlines
    strings.map { |line| line + ([" "] * (max_length - line.length))}
            .transpose
            .map { |line| line.join.rstrip.gsub("_", " ")}
            .join("\n")
  end

end