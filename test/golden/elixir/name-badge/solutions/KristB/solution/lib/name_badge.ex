defmodule NameBadge do
  def print(id, name, department) do

    uppercase_depertment =
      (department || "OWNER")
      |> String.upcase()
      
    if(id != nil) do
      integer_id = Integer.to_string(id)
      
    "[" <> integer_id <> "]" <> " - " <>name <> " - " <> uppercase_depertment
    
    else 
      name <> " - " <> uppercase_depertment
    end
  end
end
