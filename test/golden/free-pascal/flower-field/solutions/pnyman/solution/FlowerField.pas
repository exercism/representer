unit FlowerField;

{$mode ObjFPC}{$H+}

interface

function annotate(const garden: string): string;

implementation

uses SysUtils, StrUtils;

function annotate(const garden: string): string;
var
  rows: TStringArray;
  r, c, dr, dc, flowers: integer;
begin
  Result := '';
  rows := SplitString(garden, #10);
  for r := 0 to high(rows) do
  begin
    for c := 1 to length(rows[r]) do
    begin
      if rows[r][c] = '*' then
        Result += '*'
      else
      begin
        flowers := 0;
        for dr := r - 1 to r + 1 do
          for dc := c - 1 to c + 1 do
            if (dr >= 0) and (dr <= high(rows)) and
              (dc >= 1) and (dc <= length(rows[dr])) and
              (rows[dr][dc] = '*') then
              Inc(flowers);
        if flowers = 0 then
          Result += ' '
        else
          Result += IntToStr(flowers);
      end;
    end;
    if r < high(rows) then
      Result += #10;
  end;
end;

end.
