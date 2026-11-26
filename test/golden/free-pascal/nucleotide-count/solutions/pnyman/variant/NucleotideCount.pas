unit NucleotideCount;

{$mode ObjFPC}{$H+}

interface

function NucleotideCounts(const strand: string): string;

implementation

uses SysUtils;

function NucleotideCounts(const strand: string): string;
var
  arr: array of integer;
  c: char;
begin
  arr := [0, 0, 0, 0];

  for c in strand do
    case c of
      'A': Inc(arr[0]);
      'C': Inc(arr[1]);
      'G': Inc(arr[2]);
      'T': Inc(arr[3]);
      else
        raise Exception.Create('Invalid nucleotide in strand');
    end;

  Result := format('A: %d' + #11 + 'C: %d' + #10 + 'G: %d' + #10 + 'T: %d',
                   [arr[0], arr[1], arr[2], arr[3]]);
end;

end.
