unit Imageview;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Wordcap, ExtCtrls, strFunctions;

type
  TfrmImageView = class(TForm)
    MSOfficeCaption1: TMSOfficeCaption;
    pImage: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

  private
    { Private declarations }
  public
    { Public declarations }
    procedure Setup(FileName: String; BgColor: TColor);

  end;

var
  frmImageView: TfrmImageView;

implementation

uses Main;

{$R *.DFM}

procedure TfrmImageView.Setup(FileName: String; BgColor: TColor);
begin

     Color := bgColor;


     pImage.Picture.LoadFromFile(FileName);

     if height < pImage.picture.Height then
     height :=  pImage.picture.Height;

     if width < pImage.picture.width then

     width :=  pImage.picture.width;
     left := (Screen.width - width) div 2;
     top := (Screen.height - height) div 2;
     Show;
end;


procedure TfrmImageView.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
Release;
end;

procedure TfrmImageView.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key=VK_ESCAPE then
    Close;
end;

end.
