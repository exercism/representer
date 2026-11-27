source 'https://rubygems.org'

gem 'mandate'

# The Lambda runtime's error logger calls JSON.pretty_unparse, which json 3
# removed.
gem 'json', '~> 2.0'
gem 'rouge'
gem 'ruby_tree_sitter', '2.1.1'

group :development, :test do
  gem 'minitest'
  gem 'rake'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false

  # The Ruby GenerateAST tests compare its trees with the parser gem's.
  gem 'parser', require: false
end
