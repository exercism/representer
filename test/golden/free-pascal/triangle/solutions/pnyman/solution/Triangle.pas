unit Triangle;

{$mode ObjFPC}{$H+}

interface

function equilateral(const a, b, c: double): boolean;
function isosceles(const a, b, c: double): boolean;
function scalene(const a, b, c: double): boolean;
function IsTriangle(const a, b, c: double): boolean;

implementation

uses SysUtils;

function IsTriangle(const a, b, c: double): boolean;
begin
  Result := (a <> 0) and (b <> 0) and (c <> 0) and
    (a + b >= c) and (a + c >= b) and (b + c >= a);
end;

function equilateral(const a, b, c: double): boolean;
begin
  Result := False;
  if IsTriangle(a, b, c) then
    Result := (a = b) and (b = c);
end;

function isosceles(const a, b, c: double): boolean;
begin
  Result := False;
  if IsTriangle(a, b, c) then
    Result := (a = b) or (a = c) or (b = c);
end;

function scalene(const a, b, c: double): boolean;
begin
  Result := False;
  if IsTriangle(a, b, c) then
    Result := (a <> b) and (a <> c) and (b <> c);
end;

end.
