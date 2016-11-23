unit preferences;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Wordcap, StdCtrls, ComCtrls, ExtCtrls, Buttons, BigIni, anifile,
  BrowseFolder, Sound;

type
  TfrmPref = class(TForm)
    MSOfficeCaption1: TMSOfficeCaption;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    cbStartup: TCheckBox;
    cbmessage: TCheckBox;
    cbConnect: TCheckBox;
    cbKick: TCheckBox;
    cbdice: TCheckBox;
    cblock: TCheckBox;
    cbunlock: TCheckBox;
    TabSheet2: TTabSheet;
    RadioButton1: TRadioButton;
    Image1: TImage;
    Image3: TImage;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    Edit1: TEdit;
    RadioButton8: TRadioButton;
    SpeedButton1: TSpeedButton;
    OpenDialog1: TOpenDialog;
    AniIcon1: TAniIcon;
    AniIcon2: TAniIcon;
    AniIcon3: TAniIcon;
    AniIcon4: TAniIcon;
    RadioButton7: TRadioButton;
    AniIcon5: TAniIcon;
    cbMusic: TCheckBox;
    cbDisconnect: TCheckBox;
    TabSheet3: TTabSheet;
    Edit5: TEdit;
    mmoSearch: TMemo;
    Label1: TLabel;
    TabSheet4: TTabSheet;
    GroupBox2: TGroupBox;
    cbMLock: TCheckBox;
    cbMUnlock: TCheckBox;
    cbMKick: TCheckBox;
    cbMBlind: TCheckBox;
    cbMDeaf: TCheckBox;
    cbMMute: TCheckBox;
    cbMGroup: TCheckBox;
    BrowseFolder1: TBrowseFolder;
    SpeedButton2: TSpeedButton;
    button1: TButton;
    button2: TButton;
    button3: TButton;
    procedure cbStartupClick(Sender: TObject);
    procedure cbConnectClick(Sender: TObject);
    procedure cbKickClick(Sender: TObject);
    procedure cbmessageClick(Sender: TObject);
    procedure cbdiceClick(Sender: TObject);
    procedure cblockClick(Sender: TObject);
    procedure cbunlockClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure RadioButton8Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbMusicClick(Sender: TObject);
    procedure cbDisconnectClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure cbMBlindClick(Sender: TObject);
    procedure cbMDeafClick(Sender: TObject);
    procedure cbMMuteClick(Sender: TObject);
    procedure cbMGroupClick(Sender: TObject);
    procedure cbMLockClick(Sender: TObject);
    procedure cbMUnlockClick(Sender: TObject);
    procedure cbMKickClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPref: TfrmPref;
{  sndMessage : boolean;
  sndStartup : boolean;
  sndConnect : boolean;
  sndDice: boolean;
  sndLock: boolean;
  sndUnLock: boolean;
  sndKick: boolean;
}
implementation

uses Main;

{$R *.DFM}


procedure TfrmPref.cbStartupClick(Sender: TObject);
begin
     SndStartup := cbStartup.checked;
end;

procedure TfrmPref.cbConnectClick(Sender: TObject);
begin
SndConnect := cbConnect.checked;
end;

procedure TfrmPref.cbKickClick(Sender: TObject);
begin
SndKick := cbKick.checked;
end;

procedure TfrmPref.cbmessageClick(Sender: TObject);
begin
SndMessage := cbMessage.checked;
end;

procedure TfrmPref.cbdiceClick(Sender: TObject);
begin
SndDice := cbDice.checked;
end;

procedure TfrmPref.cblockClick(Sender: TObject);
begin
SndLock := cbLock.checked;
end;

procedure TfrmPref.cbunlockClick(Sender: TObject);
begin
Sndunlock := cbUnlock.checked;
end;

procedure TfrmPref.Button1Click(Sender: TObject);
begin
Close;
end;

procedure TfrmPref.SpeedButton1Click(Sender: TObject);
begin
OpenDialog1.InitialDir:= path +'cursors';
if OpenDialog1.execute then
   edit1.Text := OpenDialog1.filename;
end;

procedure TfrmPref.RadioButton8Click(Sender: TObject);
begin
  Edit1.Enabled := true;
  SpeedButton1.enabled := true;
end;

procedure TfrmPref.Button2Click(Sender: TObject);
var
myCursor: string;
iniOptions : TBigIniFile;
CurItem: integer;
begin

   iniOptions := TBigIniFile.Create(path+'vrtable.ini');

   if RadioButton1.checked then
      begin
           MyCursor := path+'cursors\cursor1.cur';
           CurItem := 1;
      end;
   if RadioButton2.checked then
      begin
           MyCursor := path+'cursors\cursor2.ani';
           CurItem := 2;
      end;
   if RadioButton3.checked then
      begin
           MyCursor := path+'cursors\cursor3.cur';
           CurItem := 3;
      end;
   if RadioButton4.checked then
      begin
           MyCursor := path+'cursors\cursor4.ani';
           CurItem := 4;
      end;
   if RadioButton5.checked then
      begin
           MyCursor := path+'cursors\cursor5.ani';
           CurItem := 5;
      end;
   if RadioButton6.checked then
      begin
           MyCursor := path+'cursors\cursor6.ani';
           CurItem := 6;
      end;
   if RadioButton7.checked then
      begin
           MyCursor := path+'cursors\cursor7.ani';
           CurItem := 7;
      end;

if (RadioButton8.checked) and (Edit1.text <> '') then
      begin
           MyCursor :=Edit1.text;
           iniOptions.writeString('Options','Cursor',MyCursor);
           iniOptions.writeInteger('Options','CursorItem',8);
      end
   else
      begin
           iniOptions.writeString('Options','Cursor',ExtractFileName(MyCursor));
           iniOptions.writeInteger('Options','CursorItem',CurItem);
      end;

   iniOptions.Free;
   iniOptions := nil;

   SetSystemCursor(LoadCursorFromFile(PChar(MyCursor)), OCR_NORMAL);

end;

procedure TfrmPref.FormShow(Sender: TObject);
begin

AniIcon1.AniFile.LoadFromFile(path+'cursors\cursor2.ani');
AniIcon1.Animated := true;
AniIcon2.AniFile.LoadFromFile(path+'cursors\cursor4.ani');
AniIcon2.Animated := true;
AniIcon3.AniFile.LoadFromFile(path+'cursors\cursor5.ani');
AniIcon3.Animated := true;
AniIcon4.AniFile.LoadFromFile(path+'cursors\cursor6.ani');
AniIcon4.Animated := true;
AniIcon5.AniFile.LoadFromFile(path+'cursors\cursor7.ani');
AniIcon5.Animated := true;



end;

procedure TfrmPref.FormClose(Sender: TObject; var Action: TCloseAction);
begin
AniIcon1.Animated := false;
AniIcon2.Animated := false;
AniIcon3.Animated := false;
AniIcon4.Animated := false;
AniIcon5.Animated := false;

end;

procedure TfrmPref.cbMusicClick(Sender: TObject);
begin
    if Not CbMusic.Checked then
       begin
          if frmSound.MidiData1.Active then
             frmSound.CloseMidiFile;
             frmSound.StopMP3;
       end
    else
       Try
          FrmSound.CloseMidiFile;
          if MainForm.vreSearchPath('overhill.mid') <> 'FNF' then
             FrmSound.PlayMidi(MainForm.vreSearchPath('overhill.mid'),true);

       except
       end;
       MusicBackground := CbMusic.Checked;
end;

procedure TfrmPref.cbDisconnectClick(Sender: TObject);
begin
sndDisconnect :=  cbDisconnect.checked;
end;

procedure TfrmPref.Button3Click(Sender: TObject);
begin
if Edit5.text <>'' then
mmoSearch.Lines.Add(Edit5.text);
edit5.Text := '';
end;

procedure TfrmPref.SpeedButton2Click(Sender: TObject);
begin
if  BrowseFolder1.Execute then
    Edit5.text := BrowseFolder1.Directory;
end;

procedure TfrmPref.cbMBlindClick(Sender: TObject);
begin
     MsgBlind := FrmPref.cbMBlind.checked;

end;

procedure TfrmPref.cbMDeafClick(Sender: TObject);
begin
     MsgDeaf := FrmPref.cbMDeaf.checked;

end;

procedure TfrmPref.cbMMuteClick(Sender: TObject);
begin
     MsgMute := FrmPref.cbMMute.checked;
end;

procedure TfrmPref.cbMGroupClick(Sender: TObject);
begin
     MsgGroup := FrmPref.cbMGroup.checked;

end;

procedure TfrmPref.cbMLockClick(Sender: TObject);
begin
     MsgLock := FrmPref.cbMlock.checked;
end;

procedure TfrmPref.cbMUnlockClick(Sender: TObject);
begin
     MsgUnlock := FrmPref.cbMUnLock.checked;

end;

procedure TfrmPref.cbMKickClick(Sender: TObject);
begin
     MsgKick := FrmPref.cbMKick.checked;
end;

procedure TfrmPref.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key=VK_ESCAPE then
    Close;
end;

end.
   