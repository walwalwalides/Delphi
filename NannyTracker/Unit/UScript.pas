unit UScript;

interface

uses FireDAC.Comp.Script;

procedure CreateTableBaby;
procedure BuildTable;
procedure CreateTableLog;

implementation

uses
  MainModule;



procedure CreateData_Table;
var
  tmpScript: TFDScript;
begin
  tmpScript := TFDScript.Create(nil);
  tmpScript.Connection := DMMainModule.SqlitConnection();
  with tmpScript.SQLScripts do
  begin
    Clear;

    with Add do
    begin
      Name := 'Data_Table';
      SQL.Add('DROP TABLE IF EXISTS Data_Table ;');
      SQL.Add('create table Data_Table(');
      SQL.Add('Id INT NOT NULL AUTO_INCREMENT,');
      SQL.Add('VTYPE INT,');
      SQL.Add('KIND_ID INT,');
      SQL.Add('PRIMARY KEY ( Id )');
      SQL.Add(');');
    end;
  end;

  try
    tmpScript.ValidateAll;
    tmpScript.ExecuteAll;
  finally
    tmpScript.free;

  end;

end;

procedure CreateTableLog;
var
  tmpScript: TFDScript;
begin
  tmpScript := TFDScript.Create(nil);
  tmpScript.Connection := DMMainModule.SqlitConnection();
  with tmpScript.SQLScripts do
  begin
    Clear;

    with Add do
    begin
      Name := 'LogConnec';
      SQL.Add('CREATE TABLE IF NOT EXISTS LogConnec(');
      SQL.Add('Id INT NOT NULL AUTO_INCREMENT,');
      SQL.Add('APPID INT,');
      SQL.Add('EVN_TYPE INT,');
      SQL.Add('EMSG VARCHAR(255),');
      SQL.Add('PRIMARY KEY ( Id )');
      SQL.Add(');');
    end;
  end;

  try
    tmpScript.ValidateAll;
    tmpScript.ExecuteAll;
  finally
    tmpScript.free;

  end;

end;

procedure CreateTableBaby;
var
  tmpScript: TFDScript;
begin
  tmpScript := TFDScript.Create(nil);
  tmpScript.Connection := DMMainModule.SqlitConnection();
  with tmpScript.SQLScripts do
  begin
    Clear;

    with Add do
    begin
      Name := 'Babys';
      SQL.Add('CREATE TABLE IF NOT EXISTS Babys(');
      SQL.Add('Id INTEGER NOT NULL PRIMARY KEY,');
      SQL.Add('FirstName VARCHAR(255) NOT NULL,');
      SQL.Add('LastName VARCHAR(255) NOT NULL,');
      SQL.Add('Age INTERGER NOT NULL,');
      SQL.Add('Present Boolean DEFAULT 1,');
      SQl.Add('ProfileImage blob');
      SQL.Add(');');
    end;
  end;

  try
    tmpScript.ValidateAll;
    tmpScript.ExecuteAll;
  finally
    tmpScript.free;

  end;

end;

procedure InsertTable;
var
  tmpScript: TFDScript;
begin
  tmpScript := TFDScript.Create(nil);
  tmpScript.Connection := DMMainModule.SqlitConnection();
  with tmpScript.SQLScripts do
  begin
    Clear;
    with Add do
    begin
      SQL.Add('INSERT INTO customers (Id,Name)');
      SQL.Add('VALUES');
      SQL.Add('(1,"Alex");');
      SQL.Add('INSERT INTO customers (Id,Name)');
      SQL.Add('VALUES');
      SQL.Add('(2,"Jack");');
      SQL.Add('INSERT INTO customers (Id,Name)');
      SQL.Add('VALUES');
      SQL.Add('(3,"Patrick");');
    end;
  end;
  try
    tmpScript.ValidateAll;
    tmpScript.ExecuteAll;
  finally
    tmpScript.free;

  end;

end;




procedure BuildTable;
begin
  CreateTableBaby;
//  InsertTable;
//  CreateData_Table;
end;

end.
