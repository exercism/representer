unit Grep;

{$mode ObjFPC}{$H+}
{$WARN 6058 OFF}

interface

type
  TStrArray = array of string;

function grep(const pattern: string; const flags: TStrArray; const files: TStrArray): TStrArray;

implementation

uses SysUtils, StrUtils;

procedure SetFlags(const flags: TStrArray; var flagN, flagL, flagI, flagV, flagX: boolean);
var
  flag: string;
begin
  for flag in flags do
    case flag of
      '-n': flagN := True;
      '-l': flagL := True;
      '-i': flagI := True;
      '-v': flagV := True;
      '-x': flagX := True;
    end;
end;

function grep(const pattern: string; const flags: TStrArray; const files: TStrArray): TStrArray;
var
  tfIn: TextFile;
  filename, s: string;
  line: integer;
  flagN, flagL, flagI, flagV, flagX: boolean;
  match, multifiles: boolean;
begin
  Result := nil;
  flagN  := False;
  flagL  := False;
  flagI  := False;
  flagV  := False;
  flagX  := False;
  SetFlags(flags, flagN, flagL, flagI, flagV, flagX);

  if length(files) > 1 then
    multifiles := True
  else
    multifiles := False;

  for filename in files do
  begin
    line := 0;
    AssignFile(tfIn, filename);
    try
      reset(tfIn);
      while not EOF(tfIn) do
      begin
        ReadLn(tfIn, s);
        Inc(line);
        match := False;

        if flagX then
          if flagI then
            match := MatchText(pattern, [s])
          else
            match := MatchStr(pattern, [s])
        else if flagI then
          match := ContainsText(s, pattern)
        else
          match := ContainsStr(s, pattern);

        if flagV then
          match := not match;

        if match then
        begin

          if flagL then
          begin
            if not (filename in Result) then
            begin
              SetLength(Result, length(Result) + 1);
              Result[high(Result)] += format('%s', [filename]);
            end;
            continue;
          end;

          SetLength(Result, length(Result) + 1);

          if multifiles and not flagN then
            Result[high(Result)] += format('%s:%s', [filename, s])

          else if flagN then
          begin
            if multifiles then
              Result[high(Result)] += format('%s:', [filename]);
            Result[high(Result)]   += format('%d:%s', [line, s]);
          end

          else
            Result[high(Result)] += format('%s', [s]);

        end;
      end;
      closeFile(tfIn);
    except
      on E: EInOutError do
        WriteLn('An error occured: ', E.MEssage);
    end;
  end;

end;

end.
