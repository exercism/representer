class KindergartenGarden
  @@children = [
    "Alice",
    "Bob",
    "Charlie",
    "David",
    "Eve",
    "Fred",
    "Ginny",
    "Harriet",
    "Ileana",
    "Joseph",
    "Kincaid",
    "Larry"
  ]

  @@plant_map = {
    'R' => "radishes",
    'C' => "clover",
    'G' => "grass",
    'V' => "violets",
  }

  def initialize(@diagram : String)
  end

  def plants(student : String) : Array(String)
    students_plants = [] of String
    name_idx = @@children.index(student)
    raise ArgumentError.new if name_idx.nil?
    student_loc = name_idx * 2
    @diagram.each_line do |row|
      students_plants << @@plant_map[row[student_loc]]
      students_plants << @@plant_map[row[student_loc + 1]]
    end
    students_plants
  end
end
