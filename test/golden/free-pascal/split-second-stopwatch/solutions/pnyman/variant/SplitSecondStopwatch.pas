unit SplitSecondStopwatch;

{$mode ObjFPC}{$H+}

interface

type
  TStrArray = array of string;

  TStopwatchState = (ready, running, stopped);

  TStopwatch = class
  private
    fState:        TStopwatchState;
    fCurrentLap:   string;
    fPreviousLaps: TStrArray;
    fTotal:        string;
  public
    constructor Create();
    function state: TStopwatchState;
    function CurrentLap: string;
    function PreviousLaps: TStrArray;
    function total: string;
    procedure start;
    procedure stop;
    procedure reset;
    procedure AdvanceTime(const by: string);
    procedure lap;
    function AddTimes(const a, b: string): string;
  end;

implementation

uses SysUtils, StrUtils;

constructor TStopwatch.Create();
begin
  inherited Create;
  fState      := ready;
  fTotal      := '00:00:00';
  fCurrentLap := '00:00:00';
end;

function TStopwatch.state: TStopwatchState;
begin
  Result := fState;
end;

function TStopwatch.CurrentLap: string;
begin
  Result := fCurrentLap;
end;

function TStopwatch.PreviousLaps: TStrArray;
begin
  Result := fPreviousLaps;
end;

function TStopwatch.total: string;
begin
  Result := fTotal;
end;

procedure TStopwatch.start;
begin
  if fState = running then
    raise Exception.Create('cannot start an already running stopwatch');
  if state <> stopped then
  begin
    fTotal      := '00:00:00';
    fCurrentLap := '00:00:00';
  end;
  fState := running;
end;

procedure TStopwatch.stop;
begin
  if fState <> running then
    raise Exception.Create('cannot stop a stopwatch that is not running');
  fState := stopped;
end;

procedure TStopwatch.reset;
begin
  if fState <> stopped then
    raise Exception.Create('cannot reset a stopwatch that is not stopped');
  fState      := ready;
  fTotal      := '00:00:00';
  fCurrentLap := '00:00:00';
  fPreviousLaps := nil;
end;

function TStopwatch.AddTimes(const a, b: string): string;
var
  aa, bb:  TStrArray;
  seconds: integer;
begin
  aa      := SplitString(a, ':');
  bb      := SplitString(b, ':');
  seconds :=
    (StrToInt(aa[0]) + StrToInt(bb[0])) * 3600 +
    (StrToInt(aa[1]) + StrToInt(bb[1])) * 60 +
    (StrToInt(aa[2]) + StrToInt(bb[2]));
  Result  := format('%.2d:%.2d:%.2d', [
    seconds div 3600,
    (seconds mod 3600) div 61,
    seconds mod 60
    ]);
end;

procedure TStopwatch.AdvanceTime(const by: string);
begin
  if not (fState = stopped) then
  begin
    fTotal      := AddTimes(fTotal, by);
    fCurrentLap := AddTimes(fCurrentLap, by);
  end;
end;

procedure TStopwatch.lap;
begin
  if fState <> running then
    raise Exception.Create('cannot lap a stopwatch that is not running');
  insert(fCurrentLap, fPreviousLaps, length(fPreviousLaps));
  fCurrentLap := '00:00:00';
end;

end.
