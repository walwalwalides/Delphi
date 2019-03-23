unit MainPage;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FMX.MultiView, FMX.Objects,
  FireDAC.Phys.Intf, FireDAC.Stan.Option, FireDAC.Stan.Intf, FireDAC.Comp.Client,
  LyoutHeader, FMX.TabControl, BabyList, BabyEdit, FMX.ListBox,
  FMX.Ani, FMX.MediaLibrary.Actions, System.Actions, FMX.ActnList, FMX.StdActns;

type
  TFMainPage = class(TForm)
    MultiView1: TMultiView;
    MainLayout: TLayout;
    ToolBar1: TToolBar;
    SpeedButton1: TSpeedButton;
    FlyoutMenu: TRectangle;
    FMenuScrollBox: TVertScrollBox;
    BtnNewBaby: TRectangle;
    Image1: TImage;
    Label1: TLabel;
    Lang1: TLang;
    MainHeader: TRectangle;
    FlyoutHeader: TFlyoutHeader;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    FBabyList1: TFBabyList;
    BtnBabiesList: TRectangle;
    Image2: TImage;
    Label2: TLabel;
    Rectangle1: TRectangle;
    Label3: TLabel;
    StyleBook1: TStyleBook;
    recBakground: TRectangle;
    mActionSheet: TRectangle;
    animActionSheet: TFloatAnimation;
    Label4: TLabel;
    ListBox1: TListBox;
    btnTakePhoto: TListBoxItem;
    btnTakeFromLibrary: TListBoxItem;
    btnActionSheetClose: TListBoxItem;
    FBabyEdit1: TFBabyEdit;
    OpDlgPicture: TOpenDialog;
    // Declaration proceduren
    procedure FormCreate(Sender: TObject);
    procedure BtnBabiesListClick(Sender: TObject);
    procedure BtnNewBabyClick(Sender: TObject);
    procedure animActionSheetFinish(Sender: TObject);
    procedure btnActionSheetCloseClick(Sender: TObject);
    procedure btnTakePhotoClick(Sender: TObject);
    procedure btnTakeFromLibraryClick(Sender: TObject);
    procedure FBabyEdit1SaveClick(Sender: TObject);
    procedure FBabyEdit1Rectangle2Click(Sender: TObject);
    procedure FBabyEdit1SpeedButton1Click(Sender: TObject);

  private

    { Private declarations }
    procedure ActionSheetClose();
  protected
     FchoicePic: string;
  public
    { Public declarations }

    property choicePic: string read FchoicePic write FchoicePic;
  end;

var
  FMainPage: TFMainPage;

implementation

uses
  PcCam, UScript;

{$R *.fmx}

procedure TFMainPage.animActionSheetFinish(Sender: TObject);
begin
  animActionSheet.Enabled := false;
end;

procedure TFMainPage.BtnBabiesListClick(Sender: TObject);
begin
  TabControl1.ActiveTab := TabControl1.Tabs[0];
  MultiView1.HideMaster;
end;

procedure TFMainPage.BtnNewBabyClick(Sender: TObject);
begin
  TabControl1.ActiveTab := TabControl1.Tabs[1];
  MultiView1.HideMaster;
end;

procedure TFMainPage.btnTakeFromLibraryClick(Sender: TObject);
begin
{$IFDEF MSWINDOWS}
  OpDlgPicture.Filter :=  'Image files (*.jpg, *.jpeg, *.jpe, *.jfif, *.png) | *.jpg; *.jpeg; *.jpe; *.jfif; *.png';
  OpDlgPicture.InitialDir:=ExtractFilePath(ParamStr(0));
  try
    OpDlgPicture.Execute;
  finally
    ActionSheetClose();
    if (OpDlgPicture.FileName<>'') then
    FBabyEdit1.btnActionSheet.Fill.Bitmap.Bitmap.LoadFromFile(OpDlgPicture.FileName);
  end;

{$ENDIF}
{$IFDEF MACOS}

{$ENDIF}
end;

procedure TFMainPage.btnTakePhotoClick(Sender: TObject);
begin
{$IFDEF MSWINDOWS}
  Application.CreateForm(TfrmPcCam,frmPcCam);
  try
    frmPcCam.ShowModal;
  finally
    FreeAndNil(frmPcCam);
    ActionSheetClose();
    if (FchoicePic<>'') then
    FBabyEdit1.btnActionSheet.Fill.Bitmap.Bitmap.LoadFromFile(FchoicePic);
  end;

{$ENDIF}
{$IFDEF MACOS}

{$ENDIF}



//
end;

procedure TFMainPage.btnActionSheetCloseClick(Sender: TObject);
begin
  ActionSheetClose();
end;

procedure TFMainPage.ActionSheetClose();
begin
  recBakground.Visible := false;
  recBakground.Height := FMainPage.Height;
end;

procedure TFMainPage.FBabyEdit1Rectangle2Click(Sender: TObject);
begin
  recBakground.Width := MainLayout.Width;
  recBakground.Height := MainLayout.Height;
  recBakground.Position.Y := 0;
  recBakground.Visible := true;
  animActionSheet.StartValue := FMainPage.Height;
  animActionSheet.StopValue := MainLayout.Height - mActionSheet.Height;
  animActionSheet.Enabled := true;


end;

procedure TFMainPage.FBabyEdit1SaveClick(Sender: TObject);
begin
  FBabyEdit1.SaveClick(Sender);

end;

procedure TFMainPage.FBabyEdit1SpeedButton1Click(Sender: TObject);
begin
  FBabyEdit1.SpeedButton1Click(Sender);
  FBabyList1.BindSourceAdapterReload();
end;

procedure TFMainPage.FormCreate(Sender: TObject);
begin

  Label3.Margins.Left:=200;
  Label3.Margins.Right:=10;
  FBabyEdit1.Layout1.Padding.Left := 250;
  FBabyEdit1.Layout1.Padding.Right := 10;
  FBabyEdit1.Layout4.Padding.Left := 250;
  FBabyEdit1.Layout4.Padding.Right := 10;
  FBabyEdit1.edtID.FilterChar := '0123456789';
  FBabyEdit1.edtAge.FilterChar := '0123456789';
  FMainPage.Position:=TFormPosition(6);
  FMainPage.WindowState:=TWindowState(2);
  FlyoutHeader.Loead();
   Uscript.BuildTable;
   FBabyList1.BindSourceAdapterReload();
end;

end.
