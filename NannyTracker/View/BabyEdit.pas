unit BabyEdit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.MediaLibrary.Actions, System.Actions, FMX.ActnList, FMX.StdActns,
  FMX.Effects, FMX.Objects, FMX.Controls.Presentation, FMX.Layouts, FMX.Edit,
  FMX.ListBox, FMX.Ani, DamUnit;

type
  TFBabyEdit = class(TFrame)
    Layout1: TLayout;
    MasterLayout: TLayout;
    btnActionSheet: TCircle;
    Layout4: TLayout;
    Rectangle3: TRectangle;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Rectangle4: TRectangle;
    SpeedButton1: TSpeedButton;
    Save: TLabel;
    edtFirstname: TEdit;
    Rectangle5: TRectangle;
    Rectangle6: TRectangle;
    Edit2: TEdit;
    Rectangle7: TRectangle;
    Edit3: TEdit;
    Rectangle8: TRectangle;
    edtAge: TEdit;
    Rectangle9: TRectangle;
    edtLastname: TEdit;
    Rectangle10: TRectangle;
    edtID: TEdit;
    Rectangle11: TRectangle;
    Edit7: TEdit;
    Rectangle12: TRectangle;
    Edit8: TEdit;
    Rectangle13: TRectangle;
    Edit9: TEdit;
    VertScrollBox1: TVertScrollBox;
    AniIndi: TAniIndicator;
    StyleBook1: TStyleBook;
    procedure SaveClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure CondEnableSavBtn(Sender: TObject);
  private
    FProgressDialogThread: TThread;
    procedure sthread(const AID: integer; const ALastname, AFirstname: string; const AAge: integer; const iType: integer);
    procedure ThreadTerminated(Sender: TObject);

    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

implementation

uses
  ubaby, MainModule, BabyList, Utool;

{$R *.fmx}
{
  procedure TFMainPage.TakePhotoFromCameraAction1DidFinishTaking(Image: TBitmap);
  begin
  FBabyEdit1.btnActionSheet.Fill.Bitmap.Bitmap.Assign(Image);
  ActionSheetClose();
  end;

  procedure TFMainPage.TakePhotoFromLibraryAction1DidFinishTaking(Image: TBitmap);
  begin
  FBabyEdit1.btnActionSheet.Fill.Bitmap.Bitmap.Assign(Image);
  ActionSheetClose();
  end; }

procedure TFBabyEdit.CondEnableSavBtn(Sender: TObject);
begin
  Save.Enabled := ((edtID.text <> '') and (edtLastname.text <> '') and (edtFirstname.text <> '') and (edtAge.text <> ''));
  SpeedButton1.Enabled := ((edtID.text <> '') and (edtLastname.text <> '') and (edtFirstname.text <> '') and (edtAge.text <> ''));

end;

procedure TFBabyEdit.SaveClick(Sender: TObject);

begin

  // BindSourceAdapterReload();

end;

var
  Loading: Boolean = False;
  zLThread: TLoadThread = nil;

procedure TFBabyEdit.sthread(const AID: integer; const ALastname, AFirstname: string; const AAge: integer; const iType: integer);
begin
  zLThread := TLoadThread.Create(AID, ALastname, AFirstname, AAge);
  zLThread.OnTerminate := ThreadTerminated;

  Loading := True;

  FProgressDialogThread := TThread.CreateAnonymousThread(
    procedure
    begin
      try
        TThread.Synchronize(nil,
          procedure
          begin
            AniIndi.Visible := True;
            AniIndi.Enabled := True;
          end);
        case iType of
          0:
            MessageDlg('Registration Successful. ', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], 0);
          1:
            begin
              MessageDlg('U have to choose another ID. ', TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);
              edtID.SetFocus;
            end;
        end;

        if TThread.CheckTerminated then
          Exit;

      finally
        if not TThread.CheckTerminated then
          TThread.Synchronize(nil,
            procedure
            begin
              zLThread.Start;
            end);
      end;
    end);

  FProgressDialogThread.FreeOnTerminate := False;
  FProgressDialogThread.Start;
end;

// UpdateAll;

procedure TFBabyEdit.ThreadTerminated(Sender: TObject);
begin
  zLThread := nil;
  Loading := False;
  AniIndi.Enabled := False;
  AniIndi.Visible := False;
  // UpdateAll;
end;

procedure TFBabyEdit.SpeedButton1Click(Sender: TObject);

var

  baby: TBaby;
  bmpProfile: Tbitmap;
  iType: integer;
begin
  iType := 0;
  bmpProfile := Tbitmap.Create;
  bmpProfile.Assign(btnActionSheet.Fill.Bitmap.Bitmap);
  try

    baby := TBaby.Create(StrToInt(edtID.text), edtLastname.text, edtFirstname.text, StrToInt(edtAge.text), bmpProfile, True);

    try
      DMMainModule.Addbaby(baby);
    except
      on e: exception do
      begin
        ShowMessage('ID already exist !');
        iType := 1;
        Exit;
      end;

    end;
  finally
    sthread(StrToInt(edtID.text), edtLastname.text, edtFirstname.text, StrToInt(edtAge.text), iType);
    SpeedButton1.Enabled := False;
    Save.Enabled := False;
  end;

end;

end.
