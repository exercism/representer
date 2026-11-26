class HighSchoolSweetheart
  def self.clean_up_name(name)
    name.chomp.gsub("-", " ").strip
  end

  def self.first_letter(name)
    clean_up_name(name)[0]
  end

  def self.initial(name)
    first_letter(name).upcase.to_s+"."
  end

  def self.pair(name1, name2)
    "\u2764 #{initial(name1)}  +  #{initial(name2)} \u2764"
  end
end
