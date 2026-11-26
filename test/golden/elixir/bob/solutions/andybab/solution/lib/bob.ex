defmodule Bob do
  @spec hey(String.t()) :: String.t()
  def hey(input) do
    any_letter = IO.inspect((input =~ ~r/[[:alpha:]]/), label: "any_letter")
    empty = IO.inspect(input =~ ~r/^\s*$/, label: "empty")
    upcase_only = IO.inspect( not (input =~ ~r/[a-z]/) and any_letter and not empty, label: "upcase_only") #Any downcase?
    qmark = IO.inspect(input =~ ~r/\?\s*$/, label: "qmark")
    
    cond do
      upcase_only and qmark -> "Calm down, I know what I'm doing!"
      upcase_only -> "Whoa, chill out!"
      qmark -> "Sure."
      empty -> "Fine. Be that way!"
      true -> "Whatever."
    end 
  end
end
