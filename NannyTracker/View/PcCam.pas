unit PcCam;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MRVCamera, StdCtrls, MRVCamView, ExtCtrls, MRVType, MRVImg, ComCtrls, System.ImageList, Vcl.ImgList, Vcl.Buttons, VCLTee.TeCanvas, VCLTee.TeeEdiGrad,
  HGM.Button, DamUnit;

type
  TfrmPcCam = class(TForm)
    RVCamView1: TRVCamView;
    RVCamera1: TRVCamera;
    pbSnapShot: TPaintBox;
    GroupBox1: TGroupBox;
    cmbVideoResolution: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    cmbCamera: TComboBox;
    Splitter1: TSplitter;
    StatusBar1: TStatusBar;
    ilOnOff: TImageList;
    bitbtnOnOff: TButtonFlat;
    bitbtnTake: TButtonFlat;
    pnlFoto: TPanel;
    Dam: TDam;
    _ExecutePlan: TDamMsg;
    procedure bitbtnOnOffClick(Sender: TObject);
    procedure bitbtnTakeClick(Sender: TObject);
    procedure cmbVideoResolutionChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmbCameraChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPcCam: TfrmPcCam;

implementation

uses MainPage, System.Threading;

{$R *.dfm}

procedure TfrmPcCam.FormCreate(Sender: TObject);
begin
  // Adding names of available webcams to cmbCamera
  RVCamera1.FillVideoDeviceList(cmbCamera.Items);
  if cmbCamera.Items.Count = 0 then
  begin
    // no webcam found
    StatusBar1.SimpleText := 'No PC CAM detected';

    bitbtnOnOff.Enabled := False;
    bitbtnTake.Enabled := False;
    cmbVideoResolution.Enabled := False;
    cmbCamera.Enabled := False;
    exit;
  end
  else
  begin
    // selecting the active webcam
    cmbCamera.ItemIndex := RVCamera1.VideoDeviceIndex;
    StatusBar1.SimpleText := 'Camera: ' + cmbCamera.Text;

  end;
  ilOnOff.Height := 48;
  ilOnOff.Height := 48;

  bitbtnOnOff.ImageIndex := 0;
  bitbtnTake.ImageIndex := 2;
  bitbtnOnOff.caption := 'OFF';
  bitbtnTake.caption := 'TAKE';
  bitbtnTake.Enabled := False;
end;

procedure TfrmPcCam.FormShow(Sender: TObject);
begin
  if (cmbCamera.Items.Count > -1) then
  begin
    // choice the camera
    cmbCamera.ItemIndex := 0;
    cmbCameraChange(nil);

    // Choice the resolution
    // cmbVideoResolution.ItemIndex := 0;
    //
    //
    // RVCamera1.SetCamVideoMode(cmbVideoResolution.ItemIndex);
    // cmbVideoResolution.ItemIndex := RVCamera1.GetCamVideoModeIndex;
    // cmbVideoResolution.ItemIndex := 0;
  end;

end;

// Starting playing video from the selected webcam
procedure TfrmPcCam.bitbtnOnOffClick(Sender: TObject);
begin
  if (bitbtnOnOff.caption = 'OFF') then
  begin

    bitbtnOnOff.ImageIndex := 1;
    bitbtnOnOff.caption := 'ON';
    bitbtnTake.Enabled := True;
    RVCamera1.PlayVideoStream;
    exit;
  end;

  if (bitbtnOnOff.caption = 'ON') then
  begin

    bitbtnOnOff.ImageIndex := 0;
    bitbtnTake.Enabled := False;
    bitbtnOnOff.caption := 'OFF';
    RVCamera1.Abort;
    exit;
  end;

end;

// Changing webcam
procedure TfrmPcCam.cmbCameraChange(Sender: TObject);
var
  i: Integer;
  CamVideoMode: TRVCamVideoMode;
begin
  RVCamera1.VideoDeviceIndex := cmbCamera.ItemIndex;
  StatusBar1.SimpleText := 'Camera: ' + cmbCamera.Text;
  // adding available webcam modes in cmbVideoResolution
  for i := 0 to RVCamera1.GetCamVideoModeCount - 1 do
  begin
    RVCamera1.GetCamVideoMode(i, CamVideoMode);
    cmbVideoResolution.Items.Append(IntToStr(CamVideoMode.Width) + 'x' + IntToStr(CamVideoMode.Height) + ' ' + IntToStr(CamVideoMode.ColorDepth) + 'bits');
  end;
  // Selecting the current mode
  cmbVideoResolution.ItemIndex := RVCamera1.GetCamVideoModeIndex;
end;

// Changing video mode for the current webcam
procedure TfrmPcCam.cmbVideoResolutionChange(Sender: TObject);
begin
  pbSnapShot.Refresh;
  RVCamera1.SetCamVideoMode(cmbVideoResolution.ItemIndex);
  cmbVideoResolution.ItemIndex := RVCamera1.GetCamVideoModeIndex;
end;

// Drawing a snapshot in pbSnapShot

procedure PaintToCanvas(Canvas: TCanvas);
begin
  with Canvas do
  begin
    MoveTo(0, 0);
    LineTo(42, 666);
    // and so on.
  end;
end;

procedure PaintToFile(APaintBox: TPaintBox; const FileName: string);
var
  Bitmap: TBitmap;
begin
  Bitmap := TBitmap.Create;
  try
    Bitmap.SetSize(APaintBox.Width, APaintBox.Height);
    // PaintToCanvas(Bitmap.Canvas);
    Bitmap.SaveToFile(FileName);
  finally
    Bitmap.Free;
  end;
end;

procedure TfrmPcCam.bitbtnTakeClick(Sender: TObject);
const
  MinRandomValue = 100000;
  FolderPic = 'Profile';
var
  Img: TRVImageWrapper;
  pathPic: string;
  Bitmap: TBitmap;
  r: TRect;
  test: Integer;
begin
  test := random(MaxInt - MinRandomValue) + MinRandomValue;

  pathPic := ExtractFilePath(Application.ExeName) + FolderPic + PathDelim;
  if not directoryexists(pathPic) then
    ForceDirectories(pathPic);
  Bitmap := TBitmap.Create;
  Img := RVCamera1.GetSnapShot;
  try

    pbSnapShot.Canvas.Draw(0, 0, Img.Bitmap.GetBitmap);
    Bitmap.Width := pbSnapShot.Width;
    Bitmap.Height := pbSnapShot.Height;
    r := rect(0, 0, Bitmap.Width, Bitmap.Height);
    Bitmap.Canvas.CopyRect(r, pbSnapShot.Canvas, r);

    TTask.Run(
      procedure
      begin
        TThread.Synchronize(nil,
          procedure
          begin
            frmPcCam.caption := 'wait...';
            Screen.Cursor := crHourGlass;
          end);
        Sleep(500);
        TThread.Synchronize(nil,
          procedure
          begin
            Screen.Cursor := crDefault;
            frmPcCam.caption := 'PC CAM';

            // if (MessageDlgPos('Do you choice this picture ?', mtConfirmation, mbYesNo, 0, frmPcCam.left + frmPcCam.Width - 380, frmPcCam.top + 40) = mrYes) then
            if _ExecutePlan.RunPos(frmPcCam.left + frmPcCam.Width - 420, frmPcCam.top) = TDamMsgRes(1) then
            begin

              try
                { Draw thumbnail as control }
                Self.Canvas.Draw(100, 10, bitmap);
                Bitmap.SaveToFile(pathPic + 'PicProf_' + IntToStr(test) + '.jpg');
                FMainPage.choicePic := pathPic + 'PicProf_' + IntToStr(test) + '.jpg';
              finally
                Img.Free;
                Bitmap.Free;
                bitbtnOnOffClick(nil);
                Close;
              end;
            end
            else
            begin
              Img.Free;
              Bitmap.Free;
            end;

          end);
      end);

  finally
    //
    frmPcCam.caption := '';
  end;
end;

end.
