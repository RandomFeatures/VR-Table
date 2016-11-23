unit splash;
interface

uses
   SysUtils, Forms, ExtCtrls, Classes, Controls, Graphics, ComCtrls,
  StdCtrls;

type
  TfrmSplash = class(TForm)
    Timer1: TTimer;
    Animate1: TAnimate;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSplash: TfrmSplash;

implementation

{$R *.DFM}

uses
  Windows,Main, macros, plyLst, chat;

procedure TfrmSplash.FormCreate(Sender: TObject);
//var
//DLLHandle : THandle;
begin
 //   include(GIFImageDefaultDrawOptions, goDirectDraw);
 if fileExists(path+'vrtable.avi') then
    Animate1.FileName := path+'vrtable.avi'
 else
      begin
          label1.Visible := true;
          Animate1.visible := false;
          timer1.Interval := 1000;
      end;


end;

procedure TfrmSplash.Timer1Timer(Sender: TObject);
begin

     MainForm.Left := 0;
     MainForm.Top := 0;
   //  MainForm.Height := screen.height;
     MainForm.Height := 102;
     MainForm.Width := Screen.width;
     MainForm.show;
     frmMacro.setup('chat');
     frmPlayerList.Setup;
     frmChat.Setup;
     Timer1.Enabled := False;
     Animate1.Active := false;
     Animate1.open := false;
end;

procedure TfrmSplash.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
CanClose := Not Timer1.Enabled;
end;

procedure TfrmSplash.FormShow(Sender: TObject);
begin
if fileExists(path+'vrtable.avi') then
   begin
        Animate1.Active := true;
        height := Animate1.FrameHeight;
        width := Animate1.FrameWidth;
   end;


end;

end.


 