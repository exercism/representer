unit Isogram;

{$mode ObjFPC}{$H+}

interface

function IsIsogram(const phrase : string) : boolean;

implementation

function IsIsogram(const phrase : string) : boolean;
var
  seen : integer;
  c : char;
  current : integer;
begin
  result := true;
  seen := 0;
  for c in phrase do
    begin
    current := ord(c) or 32;
    if (current >= 97) and (current <= 122) then
      begin
      current := 1 shl (current - 97);
      if (seen or current) = seen then
        begin
        result := false;
        break;
        end;
      seen := seen or current;
      end;
    end;
end;

end.
