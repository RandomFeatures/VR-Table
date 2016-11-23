unit ImgSnd;

interface

uses
  Windows, SysUtils, Graphics, Forms,
  Wordcap, Main, ImageView,  ExtCtrls, ComCtrls,
  Controls, Classes, StdCtrls, strFunctions,FMod;

type
  TfrmImgSnd = class(TForm)
    MSOfficeCaption1: TMSOfficeCaption;
    Button1: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    btnView: TButton;
    Panel2: TPanel;
    lbImage: TListBox;
    Panel3: TPanel;
    GroupBox2: TGroupBox;
    btnPlay: TButton;
    Panel4: TPanel;
    lbSFX: TListBox;
    procedure btnPlayClick(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmImgSnd: TfrmImgSnd;


implementation

uses sound;

{$R *.DFM}


procedure TfrmImgSnd.btnPlayClick(Sender: TObject);
begin
     //sound
     if (lbSFX.Items.count <> 0) and (lbSFX.itemindex <> -1) then

     if LowerCase(StrTokenAt(lbSFX.Items.Strings[lbSFX.itemindex],'.',1)) = 'wav' then
        frmSound.PlayWave(MainForm.vreSearchPath(lbSFX.Items.Strings[lbSFX.itemindex]));

     if LowerCase(StrTokenAt(lbSFX.Items.Strings[lbSFX.itemindex],'.',1)) = 'mp3' then
         FrmSound.PlayMp3(MainForm.vreSearchPath(lbSFX.Items.Strings[lbSFX.itemindex]),false, False);// MP3 Music



end;

procedure TfrmImgSnd.btnViewClick(Sender: TObject);
var
viewer : TFrmImageView;
begin
 if (lbImage.Items.count = 0) or (lbImage.itemindex = -1) then exit;
 try
   viewer := TFrmImageView.Create(self);
   viewer.Setup(MainForm.VreSearchPath(lbImage.Items.Strings[lbImage.itemindex]), clBlack);
 finally
   viewer := Nil;
 end;
end;



procedure TfrmImgSnd.Button1Click(Sender: TObject);
begin
     close;
     MainForm.SoundPictureFiles1.checked := false;

end;

procedure TfrmImgSnd.FormClose(Sender: TObject; var Action: TCloseAction);
begin
MainForm.SoundPictureFiles1.checked := false;

end;

procedure TfrmImgSnd.FormShow(Sender: TObject);
begin

     MainForm.SoundPictureFiles1.checked := true;
end;

procedure TfrmImgSnd.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key=VK_ESCAPE then
    frmImgSnd.Close;

end;

end.
 