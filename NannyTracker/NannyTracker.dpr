program NannyTracker;

{$R *.dres}

uses
  System.StartUpCopy,
  FMX.Forms,
  PcCam in 'View\PcCam.pas' {frmPcCam},
  MainPage in 'MainPage.pas' {FMainPage},
  uUser in 'Models\uUser.pas',
  uBaby in 'Models\uBaby.pas',
  BabyEdit in 'View\BabyEdit.pas' {FBabyEdit: TFrame},
  BabyList in 'View\BabyList.pas' {FBabyList: TFrame},
  LyoutHeader in 'View\LyoutHeader.pas' {FlyoutHeader: TFrame},
  UScript in 'Unit\UScript.pas',
  MainModule in 'Models\MainModule.pas' {DMMainModule: TDataModule},
  UTool in 'Unit\UTool.pas',
  UStrRes in 'Unit\UStrRes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMainPage, FMainPage);
  Application.CreateForm(TDMMainModule, DMMainModule);
  //  Application.CreateForm(TFlyoutHeader, FlyoutHeader);
  Application.Run;

end.
