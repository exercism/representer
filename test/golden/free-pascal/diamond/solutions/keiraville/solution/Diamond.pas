unit Diamond;

{$mode ObjFPC}{$H+}

interface

function rows(const letter : char) : string;

implementation

uses SysUtils;

function rows(const letter : char) : string;
var
  side : integer;
  i : integer;
  j : integer;

  function cell : string;
  var
    i2 : integer;
    j2 : integer;
  begin
    i2 := side + 1 - i;
    if i < i2 then
      i2 := i;

    j2 := side + 1 - j;
    if j < j2 then
      j2 := j;

    if i2 + j2 = (ord(letter) - ord('A')) + 2 then
      result := chr(ord('A') + i2 - 1)
    else
      result := ' ';
  end;

begin
  side := 2 * (ord(letter) - ord('A')) + 1;
  result := '';
  for i := 1 to side do
    begin
      for j := 1 to side do
        result := result + cell;

      if i < side then
        result := result + #10;
    end;
end;

end.
