unit sndImage;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,DirectX, strFunctions, ComCtrls, DXSounds, DXDraws, VrePlayer;

type
  TfrmSndImg = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    lbImagelist: TListBox;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    TabSheet2: TTabSheet;
    lbsoundlist: TListBox;
    Button2: TButton;
    Button3: TButton;
    Label4: TLabel;
    TabSheet3: TTabSheet;
    lbM: TListBox;
    Button4: TButton;
    Label5: TLabel;
    Button5: TButton;
    procedure lbImagelistClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SendClick(Sender: TObject);
    procedure TestClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSndImg: TfrmSndImg;

implementation

uses plyLst, Main, sound;

{$R *.DFM}

procedure TfrmSndImg.lbImagelistClick(Sender: TObject);
begin
 Image1.picture := DXImageList1.Items[lbImageList.ItemIndex].picture;
 label1.Caption := 'H: ' + IntToStr(DXImageList1.Items[lbImageList.ItemIndex].picture.Height);
 label2.Caption := 'W: ' + IntToStr(DXImageList1.Items[lbImageList.ItemIndex].picture.Width) ;

end;


procedure TfrmSndImg.Button1Click(Sender: TObject);
var
I: integer;
Pid: Integer;
begin
if (lbImagelist.items.count <> 0) and (lbImagelist.itemIndex <> -1)then
if frmPlayerList.playrList.ItemFocused.Caption = 'All Players' then
     SndToOne(PChar('Picture' + '|'+Label3.caption+'|'+lbImagelist.Items.Strings[lbImagelist.ItemIndex]), DPID_ALLPLAYERS)
  else
      begin
         for I := 0 to frmPlayerList.PlayerList.count - 1 do
           if TVrePlayer(frmPlayerList.PlayerList.Items[i]).Player_Name = frmPlayerList.playrList.ItemFocused.Caption then
              pId := StrToInt(TVrePlayer(frmPlayerList.PlayerList.Items[i]).player_id);
         SndToOne(PChar('Picture' + '|'+Label3.caption+'|'+lbImagelist.Items.Strings[lbImagelist.ItemIndex]), pId);
     end;
close;
end;


procedure TfrmSndImg.SendClick(Sender: TObject);
var
i: integer;
PId: integer;
begin
if (lbsoundlist.Items.count <> 0) and (lbsoundlist.itemIndex <> -1) then
if frmPlayerList.playrList.ItemFocused.Caption = 'All Players' then
     SndToOne(PChar('Sound' + '|'+Label4.caption+'|'+lbsoundlist.Items.Strings[lbsoundlist.ItemIndex]), DPID_ALLPLAYERS)
  else
      begin
           for I := 0 to frmPlayerList.PlayerList.count - 1 do
               if TVrePlayer(frmPlayerList.PlayerList.Items[i]).Player_Name = frmPlayerList.playrList.ItemFocused.Caption then
                  pId := StrToInt(TVrePlayer(frmPlayerList.PlayerList.Items[i]).player_id);
           SndToOne(PChar('Sound' + '|'+Label4.caption+'|'+lbsoundlist.Items.Strings[lbsoundlist.ItemIndex]), pid );
      end;

close;

end;

procedure TfrmSndImg.TestClick(Sender: TObject);
begin
    //sound
    if lbSoundList.ItemIndex <> -1 then
    FrmSound.Play
    DXWaveList1.items.Items[lbSoundList.ItemIndex].play(false);
end;

procedure TfrmSndImg.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key=VK_ESCAPE then
    Close;
end;

end.
 