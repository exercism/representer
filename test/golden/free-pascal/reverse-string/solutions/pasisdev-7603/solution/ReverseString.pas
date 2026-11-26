unit ReverseString;

{$mode ObjFPC}{$H+}

interface

function reverse(const value : string) : string;

implementation

uses SysUtils;

function reverse(const value : string) : string;
var
  i : integer;
begin
  result := '';
  for i := high(value) downto low(value) do
  begin
    result := result + value[i];
  end;
  //raise ENotImplemented.Create('Please implement your solution.'); result := value;
  // Try writing a simple algorithm instead of using the built-in function.

end;

end.
