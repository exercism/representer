unit BinarySearch;

{$mode ObjFPC}{$H+}

interface

type
  TExtendedArray = Array Of Extended;

function find(const AArray: TExtendedArray; const AValue : Extended) : Integer;

implementation

uses SysUtils;

function find(const AArray: TExtendedArray; const AValue : Extended) : Integer;
var
  Left, Right, Mid: Integer;
begin
Left := 0;
Right := Length(AArray) - 1;

  while Left <= Right do
  begin
    Mid := (Left + Right) div 2;

    if AArray[Mid] = AValue then
    begin
      Result := Mid;
      Exit;
    end
    else if AArray[Mid] < AValue then
      Left := Mid + 1
    else
      Right := Mid - 2;
  end;

  raise Exception.Create('value not in array');
end;

end.
