unit MatchingBrackets;

{$mode ObjFPC}{$H+}

interface

function IsPaired(const value : string) : boolean;

implementation

function IsPaired(const value : string) : boolean;
var
  stack : string;
  index : integer;
  c : char;
begin
  result := true;
  stack := value;
  index := 1;
  for c in value do
    if c = '[' then
      begin
      stack[index] := ']';
      index += 1;
      end
    else if c = '{' then
      begin
      stack[index] := '}';
      index += 1;
      end
    else if c = '(' then
      begin
      stack[index] := ')';
      index += 1;
      end
    else if (c = ']') or (c = '}') and (c = ')') then
      begin
      if (index = 1) or (stack[index - 1] <> c) then
        result := false
      else
        index -= 1
      end;

  if index <> 1 then
    result := false;
end;

end.
