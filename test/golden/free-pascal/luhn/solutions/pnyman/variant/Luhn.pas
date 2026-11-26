unit Luhn;

{$mode ObjFPC}{$H+}

interface

function valid(const Value: string): boolean;

implementation

uses SysUtils;

function valid(const Value: string): boolean;
var
  i, k, v, sum: integer;
  normalized: string;
  c: char;
begin
  normalized := '';
  for c in Value do
  begin
    if c = ' ' then continue;
    if not (c in ['0'..'9']) then exit(False);
    normalized += c;
  end;
  if length(normalized) < 2 then exit(False);

  sum := 0;
  k := 0;
  for i := length(normalized) downto 1 do
  begin
    Inc(k);
    v := StrToInt(normalized[i]);
    Inc(sum, v);
    if (k mod 2 = 1) then
    begin
      Inc(sum, v);
      if 2 * v > 9 then Dec(sum, 9);
    end;
  end;

  Result := sum mod 10 = 0;
end;

end.
