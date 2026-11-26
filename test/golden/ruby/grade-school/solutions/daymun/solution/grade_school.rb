class School
  def initialize
    @roster = (1..12).each_with_object({}) do |grade, roster|
      roster[grade] = []
    end
  end

  def add(name, grade)
    return false if roster.include?(name)
    
    @roster[grade] << name
    @roster[grade].sort!
    true
  end

  def roster
    @roster.values.flatten
  end

  def grade(grade)
    @roster[grade]
  end
end