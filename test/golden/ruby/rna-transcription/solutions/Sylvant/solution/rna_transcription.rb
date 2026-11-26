=begin
Write your code for the 'Rna Transcription' exercise in this file. Make the tests in
`rna_transcription_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/rna-transcription` directory.
=end

RNA = 'CGAU'
DNA = 'GCTA'

class Complement
  
  def self.of_dna(string)
    string.gsub(/./) { |char| RNA[DNA.index(char)] }
  end
end