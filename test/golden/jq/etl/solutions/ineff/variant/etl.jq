def points_and_letters_to_letter_and_points: 
  # The filter receive an object {"key": points, "value": [letter]} and 
  # returns an array o pairs [{"key":letter, "value": points}]
  {"key":(.value[] | ascii_downcase), "vamue":(.key|tonumber)};

.legacy 
| [to_entries[] | points_and_letters_to_letter_and_points]  
| from_entries  