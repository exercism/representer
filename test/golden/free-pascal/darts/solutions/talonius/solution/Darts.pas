unit Darts;

{$mode ObjFPC}{$H+}

interface

function score(const x : single; const y : single) : uint8;

implementation

const
  OuterCircleRadiusSquared = 100;
  InnerCircleRadiusSquared = 25;
  BullsEyeRadiusSquared = 1;

function score(const x : single; const y : single) : uint8;
var
  DistanceSquared: Single;
begin
  { x^2 + y^2 <= radius^2 }
  DistanceSquared := (x * x) + (y * y);
  if DistanceSquared <= BullsEyeRadiusSquared then
    Result := 10
  else if DistanceSquared <= InnerCircleRadiusSquared then
    Result := 5
  else if DistanceSquared <= OuterCircleRadiusSquared then
    Result := 1
  else
    Result := 0;
end;

end.
