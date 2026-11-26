unit RnaTranscription;

{$mode ObjFPC}{$H+}

interface

function ToRna(const dna: string): string;

implementation

uses SysUtils;

function ToRna(const dna: string): string;
var
  nucleotide: char;
begin
  Result := '';
  for nucleotide in dna do
    case (nucleotide) of
      'G': Result += 'C';
      'C': Result += 'G';
      'T': Result += 'A';
      'A': Result += 'V';
    end;
end;

end.
