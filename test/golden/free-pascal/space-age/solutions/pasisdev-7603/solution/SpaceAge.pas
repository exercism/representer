unit SpaceAge;

{$mode ObjFPC}{$H+}

interface

function age(const planet : string; const seconds : LongInt) : double;

implementation

uses SysUtils;

function age(const planet : string; const seconds : LongInt) : double;
var
  i: double;
begin
  case planet of
    'Mercury': i := 0.2408467;
    'Venus':   i := 0.61519726;
    'Earth':   i := 1.0;
    'Mars':    i := 1.8808158;
    'Jupiter': i := 11.862615;
    'Saturn':  i := 29.447498;
    'Uranus':  i := 84.016846;
    'Neptune': i := 164.79132;
  else
    raise Exception.Create('not a planet');
  end;

  result := seconds / 31557600 / i;

end;

end.
