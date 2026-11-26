unit DifferenceOfSquares;

{$mode ObjFPC}{$H+}

interface

function SquareOfSum(number : longint) : longint;
function SumOfSquares(number : longint) : longint;
function DifferenceOfSquares(number : longint) : longint;

implementation

uses SysUtils;

function SquareOfSum(number : longint) : longint;
var s, i : longint;
begin
  s := 0;
  for i := 0 to number do s := s + i;
  Result := s * s;
end;

function SumOfSquares(number : longint) : longint;
var s, i : longint;
begin
  s := 0;
  for i := 0 to number do s := s + i * i;
  Result := s;
end;

function DifferenceOfSquares(number : longint) : longint;
begin
  Result := SquareOfSum(number) - SumOfSquares(number);
end;

end.
