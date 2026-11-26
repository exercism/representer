unit Darts;

{$mode ObjFPC}{$H+}

interface

function score(const x : single; const y : single) : uint8;

implementation

uses SysUtils;

function score(const x : single; const y : single) : uint8;
var
  distance : single;
begin
  distance := Sqrt(x*x + y*y);
  
  if distance > 10 then
    score := 0
  else if distance > 5 then
    score := 1
  else if distance > 1 then
    score := 5
  else
    score := 10;
    
    
end;

end.
