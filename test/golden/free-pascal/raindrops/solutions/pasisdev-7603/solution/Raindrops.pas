unit Raindrops;

{$mode ObjFPC}{$H+}

interface

function convert(const number : integer) : string;

implementation

uses SysUtils;

function convert(const number : integer) : string;
begin
  result := '';

  if number mod 3 = 0 then
    result := 'Pling';

  if number mod 5 = 0 then
    result := result + 'Plang';

  if number mod 7 = 0 then
    result := result + 'Plong';

  if result = '' then
    result := inttostr(number);
  //raise ENotImplemented.Create('Please implement your solution.'); result := format('"%.5d"', [number]);

end;

end.
