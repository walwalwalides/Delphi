{ ============================================
  Software Name : 	MySQL_StoreProc
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight � 2019                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit Module;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.UI,Udaten,Ulog, FireDAC.Phys.Oracle, FireDAC.Phys.OracleDef;

type
  TDMModule = class(TDataModule)
    ConnectionMain: TFDConnection;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    MySQLWaitCursor: TFDGUIxWaitCursor;
    ProcGetName: TFDStoredProc;
    ProcCounter: TFDStoredProc;
    FDErrLogConn: TFDConnection;
    FDErrLogQuery: TFDQuery;
    FDTestConn: TFDConnection;
    FDOutConn: TFDConnection;
    FDOutQuery: TFDQuery;
    FDTestQuery: TFDQuery;
    FDStreamConn: TFDConnection;
    FDStreamQuery: TFDQuery;

    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure FDTestConnAfterConnect(Sender: TObject);
    procedure FDTestConnAfterDisconnect(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Log : TMySQLLog;
  end;

  type
  IServer = interface
    procedure Execute(ABuffer :  TStatesHash);
    procedure Merge(const isTruncateTable : Boolean);
  end;

   TDBMySQL = class (TInterfacedObject, IMySQLDataBase)
  private
    FFDConn : TFDConnection;
    FFDQuery: TFDQuery;
    procedure Connect;
    procedure Disconnect;
    procedure Insert(const AppID : Integer; const EventMsg : string; EventType : Byte = 0);
  public
    constructor Create;
  end;



var
  DMModule: TDMModule;

implementation
var
  DBMySQL : TDBMySQL;



{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}


//before u have to define your connectionMain in  FDConnectionDefs.ini
//Add This lines in Inifile

//[MYWALID_MYSQL]                        MYWALID_MYSQL  -> choose as name of parametre  ConnectionDefName
//DriverID=MySQL
//Database=
//User_Name=
//Password=
//Server=127.0.0.1

//finally
//choose the right function in StoredProcName parametre in(ProcGetName and ProcCounter)

procedure TDMModule.DataModuleCreate(Sender: TObject);
begin
  //link connection to StoredProc
  ConnectionMain.LoginPrompt:=False;
  ConnectionMain.ConnectionDefName:='MYWALID_MYSQL';
  ConnectionMain.Connected:=True;
  ProcGetName.Connection:=DMModule.ConnectionMain;
  ProcCounter.Connection:=DMModule.ConnectionMain;
  DBMySQL  := TDBMySQL.Create;
  Log    := TMySQLLog.Create(12,DBMySQL);




end;


procedure TDBMySQL.Connect;
begin
  try
    FFDConn.Connected := True;
  except
    raise Exception.Create('ErrLog :: Erorr DataBase');
  end;
end;

constructor TDBMySQL.Create;
begin
  FFDConn := DMModule.FDErrLogConn;
  FFDQuery:= DMModule.FDErrLogQuery;
end;

procedure TDBMySQL.Disconnect;
begin
  if FFDConn.Connected then FFDConn.Connected := False;
end;

procedure TDBMySQL.Insert(const AppID: Integer; const EventMsg: string;
  EventType: Byte);
begin
  Connect;
  FFDQuery.ParamByName('APPID').AsInteger := AppID;
  FFDQuery.ParamByName('EVN_TYPE').AsInteger := EventType;
  FFDQuery.ParamByName('EMSG').AsString := EventMsg;
  FFDQuery.ExecSQL;
  FFDQuery.Close;
  Disconnect;
end;




procedure TDMModule.DataModuleDestroy(Sender: TObject);
begin
 FreeAndNil(Log);
end;

// 3 : EvtType (Test)

procedure TDMModule.FDTestConnAfterConnect(Sender: TObject);
begin
DBMySQL.Insert(10,'Connected at '+DateToStr(Now)+' '+formatdatetime('hh:nn:ss.zzz',now),3);
end;

procedure TDMModule.FDTestConnAfterDisconnect(Sender: TObject);
begin
DBMySQL.Insert(10,'Disconnected at '+DateToStr(Now)+' '+formatdatetime('hh:nn:ss.zzz',now),3);
end;

end.
