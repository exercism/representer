# Strings stay as they are, so "other1" and "other2" keep their values.
class Thing
  attr_reader :thing
  attr_reader 'other1', 'other2'
  attr_writer :food
  attr_accessor :stuff
end
