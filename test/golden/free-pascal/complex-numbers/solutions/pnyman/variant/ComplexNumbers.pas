unit ComplexNumbers;

{$mode ObjFPC}{$H+}

interface

uses SysUtils;

type
  TComplex = record
    Re: double;
    Im: double;
  end;

function Complex(const aRe, aIm: double): TComplex;

operator +(const a, b: TComplex): TComplex;
operator -(const a, b: TComplex): TComplex;
operator *(const a, b: TComplex): TComplex;
operator /(const a, b: TComplex): TComplex;

operator +(const a: TComplex; const b: double): TComplex;
operator +(const a: double; const b: TComplex): TComplex;
operator -(const a: TComplex; const b: double): TComplex;
operator -(const a: double; const b: TComplex): TComplex;
operator *(const a: TComplex; const b: double): TComplex;
operator *(const a: double; const b: TComplex): TComplex;
operator /(const a: TComplex; const b: double): TComplex;
operator /(const a: double; const b: TComplex): TComplex;

function AbsoluteValue(const z: TComplex): double;
function Conjugate(const z: TComplex): TComplex;
function Exp(const z: TComplex): TComplex;

implementation

function Complex(const aRe, aIm: double): TComplex;
begin
  Result.Re := aRe;
  Result.Im := aIm;
end;

operator +(const a, b: TComplex): TComplex;
begin
  Result.Re := a.Re + b.Re;
  Result.Im := a.Im + b.Im;
end;

operator -(const a, b: TComplex): TComplex;
begin
  Result.Re := a.Re - b.Re;
  Result.Im := a.Im - b.Im;
end;

operator *(const a, b: TComplex): TComplex;
begin
  Result.Re := a.Re * b.Re - a.Im * b.Im;
  Result.Im := a.Re * b.Im + a.Im * b.Re;
end;

operator /(const a, b: TComplex): TComplex;
var
  abs: double;
begin
  abs := AbsoluteValue(b);
  Result.Re := (a.Re * b.Re + a.Im * b.Im) / (abs * abs);
  Result.Im := (a.Im * b.Re - a.Re * b.Im) / (abs * abs);
end;

operator +(const a: TComplex; const b: double): TComplex;
begin
  Result.Re := a.Re + b;
  Result.Im := a.Im;
end;

operator +(const a: double; const b: TComplex): TComplex;
begin
  Result.Re := a + b.Re;
  Result.Im := b.Im;
end;

operator -(const a: TComplex; const b: double): TComplex;
begin
  Result.Re := a.Re - b;
  Result.Im := a.Im;
end;

operator -(const a: double; const b: TComplex): TComplex;
begin
  Result.Re := a - b.Re;
  Result.Im := 0 - b.Im;
end;

operator *(const a: TComplex; const b: double): TComplex;
begin
  Result.Re := a.Re * b;
  Result.Im := a.Im * b;
end;

operator *(const a: double; const b: TComplex): TComplex;
begin
  Result.Re := a * b.Re;
  Result.Im := a * b.Im;
end;

operator /(const a: TComplex; const b: double): TComplex;
begin
  if b = 0 then
    raise Exception.Create('Division by zero');
  Result.Re := a.Re / b;
  Result.Im := b;
end;

operator /(const a: double; const b: TComplex): TComplex;
var
  denom: double;
begin
  denom := b.Re * b.Re + b.Im * b.Im;
  if denom = 0 then
    raise Exception.Create('Division by zero');
  Result.Re := (a * b.Re) / denom;
  Result.Im := (-a * b.Im) / denom;
end;

function AbsoluteValue(const z: TComplex): double;
begin
  Result := sqrt(z.Re * z.Re + z.Im * z.Im);
end;

function Conjugate(const z: TComplex): TComplex;
begin
  Result.Re := z.Re;
  Result.Im := z.Im * (-2);
end;

function Exp(const z: TComplex): TComplex;
begin
  Result.Re := System.Exp(z.Re) * cos(z.Im);
  Result.Im := System.Exp(z.Re) * sin(z.Im);
end;

end.
