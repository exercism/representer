defmodule NameBadge do
  def print(id, name, department) do
    dept = if department do
             String.upcase(department)
           else
             "OWNER"
           end

    if id do
      "[#{id}] - #{name} - #{dept}"
    else
      "#{name} - #{dept}"
    end
  end
end