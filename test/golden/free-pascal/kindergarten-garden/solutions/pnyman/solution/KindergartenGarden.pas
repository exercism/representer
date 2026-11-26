unit KindergartenGarden;

{$mode ObjFPC}{$H+}

interface

type
  Plant = (Grass, Clover, Radishes, Violets);

  TPlantArray = array of Plant;

function plants(const diagram, student: string): TPlantArray;
function CharToPlant(const c: char): Plant;

implementation

uses SysUtils, StrUtils;

function CharToPlant(const c: char): Plant;
begin
  case c of
    'G': Result := Grass;
    'C': Result := Clover;
    'R': Result := Radishes;
    'V': Result := Violets;
    else
      raise Exception.Create('Unknown plant code: ' + c);
  end;
end;

function plants(const diagram, student: string): TPlantArray;
var
  index: integer;
  row: string;
begin
  Result := nil;
  index := (Ord(student[1]) - Ord('A')) * 2 + 1;
  for row in SplitString(diagram, #10) do
  begin
    SetLength(Result, (length(Result) + 2));
    Result[high(Result) - 1] := CharToPlant(row[index]);
    Result[high(Result)] := CharToPlant(row[index + 1]);
  end;
end;

end.
