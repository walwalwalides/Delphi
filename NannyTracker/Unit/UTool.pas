unit UTool;

interface

uses system.Classes, system.Threading,System.StrUtils,System.Types,System.SysUtils;

type
  TLoadThread = class(TThread)
  private
    FProgressDialogThread: TThread;
    procedure DoProcessing;
  public
    ID: integer;
    Lastname: string;
    Firstname: string;
    Age: integer;

    constructor Create(const aID: integer; const aLastname, aFirstname: string; const aAge: integer); reintroduce;
  protected
    procedure Execute; override;
  end;

implementation

procedure CreateLogfile;
var
  F: TextFile;
  FN: String;
begin
  FN := ChangeFileExt(ParamStr(0), '.log');
  AssignFile(F, FN);
  Rewrite(F);
  Append(F);
  WriteLn(F,sLineBreak);
  WriteLn(F, 'This Logfile was created on ' + DateTimeToStr(Now));
  WriteLn(F, sLineBreak);
  WriteLn(F, '');
  CloseFile(F);
end;

// Procedure for appending a Message to an existing logfile with current Date and Time **
procedure WriteToLog(aLogMessage: String);
var
  F: TextFile;
  FN: String;
begin
  FN := ChangeFileExt(ParamStr(0), '.log');

  if (not FileExists(FN)) then
  begin
    CreateLogfile;
  end;

  AssignFile(F, FN);
  Append(F);
  WriteLn(F, DateTimeToStr(Now) + ': ' + aLogMessage);
  CloseFile(F)
end;

constructor TLoadThread.Create(const aID: integer; const aLastname, aFirstname: string; const aAge: integer);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  ID := aID;
  Lastname := aLastname;
  Firstname := aFirstname;
  Age := aAge;
end;

procedure TLoadThread.DoProcessing;
 var
 slog:string;
begin
  // do processing adding log
   slog:='(ID) '+'" '+ID.tostring+' "'+char(9)+'- Lastname : '+Lastname+char(9)
   +'- Firstname : '+firstname+char(9)+'- Age : '+Age.ToString+char(9)+'.';

   WriteToLog(slog);

  // Create separated thread for long operations
end;

procedure TLoadThread.Execute;
begin
  // do processing

  // Synchronize(  procedure
  // update main form
  // end);

  // do processing

  // FreeOnTerminate:= true;
  Synchronize(DoProcessing);
end;

end.
