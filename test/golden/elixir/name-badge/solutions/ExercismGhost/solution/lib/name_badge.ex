defmodule NameBadge do
  def print(id, name, department) do
    department_name = if department, do: String.upcase(department), else: "OWNER" 
    if id do
      "[#{id}] - #{name} - #{department_name}"
    else
      "#{name} - #{department_name}"
    end
  end
end
