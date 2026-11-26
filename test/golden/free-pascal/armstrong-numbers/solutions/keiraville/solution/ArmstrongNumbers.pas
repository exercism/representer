unit ArmstrongNumbers;

{$mode ObjFPC}{$H+}

interface

function IsArmstrongNumber(const number: qword) : boolean;

implementation

function IsArmstrongNumber(const number: qword) : boolean;
var
  dividend: qword;
  count: qword;
  total: qword;
  multiplier: qword;
  base: qword;
  exponent: qword;
begin
  count := 0;
  dividend := number;
  repeat
    dividend := dividend div 10;
    count += 1;
  until dividend = 0;

  total := 0;
  dividend := number;
  repeat
    multiplier := 1;
    base := dividend mod 10;
    exponent := count;
    repeat
      if exponent mod 2 = 1 then
        multiplier *= base;
      base *= base;
      exponent := exponent div 2;
    until exponent = 0;
    total += multiplier;
    dividend := dividend div 10;
  until dividend = 0;

  result := (total = number);
end;

end.
