# A call to attr_reader, attr_writer or attr_accessor defines no name for
# the representer, so its symbols keep their names. Strings keep their
# values, so "other1" and "other2" stay as they are.
class Thing
  attr_reader :foobar
  attr_reader 'other1', 'other2'
  attr_writer :barfood
  attr_accessor :misc
end
