unit LyoutHeader;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts;

type
  TFlyoutHeader = class(TFrame)
    RHeader: TRectangle;
    LContent: TLayout;
    LEmail: TLabel;
    CImage: TCircle;
    LName: TLabel;
    procedure Loead();
  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }

  end;

implementation
uses uUser,REST.Json,system.iOUtils;

{$R *.fmx}
procedure TFlyoutHeader.Loead();
const
 pathback=   '..\Images';
var
  User : TUser;
  text : string;
  path : string;
begin
   text :='{"userId":1,"firstName":"Zekiri","lastName":"Abdelali","emailAddress":"zekiriabd@gmail.com" ,"image":"zekiri.jpg"}';
   User := TUser.Create();
   User := TJson.JsonToObject<Tuser>(text);
   LEmail.Text:=User.emailAddress;
   LName.Text:=User.firstName + ' ' + User.lastName;
   path := TPath.GetLibraryPath + pathback+PathDelim + User.image;
   CImage.Fill.Bitmap.Bitmap.LoadFromFile(path);


end;


end.
