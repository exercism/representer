unit PerfectNumbers;

{$mode ObjFPC}{$H+}

interface

function classify(const number : integer) : string;

implementation

uses SysUtils;

function classify(const number : integer) : string;
var
  i,sum,divisor : integer;
  d : array of integer;
begin
  if number <= 0 then
  begin
    raise exception.Create('Classification is only possible for positive integers.');
  end;
  sum := 0;
  d := nil;
  divisor := 1;

  while divisor < number do
  begin
    if number mod divisor = 0 then
    begin
      setlength(d,length(d)+1);
      d[high(d)] := divisor;
    end;
    divisor := divisor + 1;
  end; 

  for i := low(d) to high(d) do
  begin
    sum := sum + d[i];
  end;

  if sum = number then
    result := 'perfect'
  else if sum > number then
    result := 'abundant'
  else if sum < number  then
    result := 'deficient';
  //raise ENotImplemented.Create('Please implement your solution.'); result := IntToStr(number);

end;

end.
