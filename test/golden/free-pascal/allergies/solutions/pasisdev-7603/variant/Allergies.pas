unit Allergies;

{$mode ObjFPC}{$H+}

interface

type
  TStrArray = Array Of String;

function list(const score : integer) : TStrArray;
function AllergicTo(const item : string; const score : integer) : boolean;

implementation

uses SysUtils,math;

function getpower(var arg : integer) : integer;
var i : integer;
begin
  for i := 0 to 8 do
  begin
    if power(2,i) > arg then
    begin
      result := i - 2;
      exit;
    end;
  end;
end;

function list(const score : integer) : TStrArray;
const
t : array[0..7] of string = ('eggs','peanuts','shellfish','strawberries','tomatoes','chocolate','pollen','cats');
var
me : array of string;
x,p : integer;
begin
x := score;
me := nil;

while x > 256 do
begin
  x := x - 256
end;

while not(x = 0) do
begin
p := getpower(x);
x := x - round(power(2,p));
insert(t[p],me,0);
end;
result := me;
  //raise ENotImplemented.Create('Please implement your solution.'); result := [IntToStr(score)];

end;

function AllergicTo(const item : string; const score : integer) : boolean;
var
checkarray : array of string;
i : integer;
begin
checkarray := list(score);
  //raise ENotImplemented.Create('Please implement your solution.'); result := length(item) > score;

result := false;

for i := low(checkarray) to high(checkarray) do
begin
  if sametext(checkarray[i], item) then
  begin
    result := true;
    exit;
  end;
end;

end;


end.
