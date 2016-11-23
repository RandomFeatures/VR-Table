unit Main;

interface

uses
  Windows, SysUtils, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DXPlay, DirectX, ComCtrls, strFunctions, Buttons, ExtCtrls, options,
  Menus, chat, plyLst, BigIni, Wordcap, explbtn, macros, Imageview, Common, ToolWin,
  ImgList, connect, VrePlayer, Classes, GifImage;

const
  DXCHAT_MESSAGE = 0;

type
 TDXChatMessage = record
    dwType: DWORD;  {  dwType is absolutely necessary.  }
    Len: Integer;
    C: array[0..0] of Char;
  end;

type
  TMainForm = class(TForm)
    DXPlay1: TDXPlay;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Options2: TMenuItem;
    MessageType2: TMenuItem;
    mnuspeaking: TMenuItem;
    mnudoing: TMenuItem;
    SendAs2: TMenuItem;
    mnuName: TMenuItem;
    mnuDesc: TMenuItem;
    View1: TMenuItem;
    MainChat1: TMenuItem;
    PlayerList1: TMenuItem;
    Options1: TMenuItem;
    N1: TMenuItem;
    GameConnetion1: TMenuItem;
    CreateJoinAGame1: TMenuItem;
    ExittheGame1: TMenuItem;
    LoadCharacterSettings1: TMenuItem;
    SaveCharacterSettings1: TMenuItem;
    N3: TMenuItem;
    openChrFile: TOpenDialog;
    saveChrFile: TSaveDialog;
    chatSave: TSaveDialog;
    chatOpen: TOpenDialog;
    Timer1: TTimer;
    LoadChat: TMenuItem;
    SaveChat: TMenuItem;
    N2: TMenuItem;
    Timer2: TTimer;
    PlayerMacros1: TMenuItem;
    SystemInformation1: TMenuItem;
    Loadmacrofile1: TMenuItem;
    SaveMacroFile1: TMenuItem;
    N4: TMenuItem;
    EditCreateMacros1: TMenuItem;
    PluginInformation1: TMenuItem;
    MainStatus: TStatusBar;
    Plugins1: TMenuItem;
    LoadGameFiles1: TMenuItem;
    SaveGameFiles1: TMenuItem;
    SoundPictureFiles1: TMenuItem;
    ClearChatWindow1: TMenuItem;
    Preferences1: TMenuItem;
    SystemMessages1: TMenuItem;
    Volume1: TMenuItem;
    System1: TMenuItem;
    Options3: TMenuItem;
    N5: TMenuItem;
    Notes1: TMenuItem;
    VRLocalPlayer: TVrePlayer;
    About1: TMenuItem;
    ToolBar1: TToolBar;
    speedbutton1: TToolButton;
    SpeedButton2: TToolButton;
    ToolButton3: TToolButton;
    SpeedButton3: TToolButton;
    SpeedButton4: TToolButton;
    ToolButton6: TToolButton;
    btnCreateJoin: TToolButton;
    btnleave: TToolButton;
    ToolButton9: TToolButton;
    SpeedButton9: TToolButton;
    SpeedButton10: TToolButton;
    ToolButton2: TToolButton;
    ToolButton1: TToolButton;
    ToolButton12: TToolButton;
    SpeedButton5: TToolButton;
    ToolButton17: TToolButton;
    ToolButton14: TToolButton;
    SpeedButton11: TToolButton;
    MSOfficeCaption1: TMSOfficeCaption;
    NewCharacter1: TMenuItem;
    ImageList1: TImageList;
    EditCharacterData1: TMenuItem;
    procedure DXPlay1AddPlayer(Sender: TObject; Player: TDXPlayPlayer);
    procedure DXPlay1DeletePlayer(Sender: TObject; Player: TDXPlayPlayer);
    procedure FormCreate(Sender: TObject);
    procedure DXPlay1Message(Sender: TObject; Player: TDXPlayPlayer; Data: Pointer;
      DataSize: Integer);
    procedure DXPlay1Open(Sender: TObject);
    Procedure TranslateMessage(MsgRcvd: String);
    procedure Options1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure mnuspeakingClick(Sender: TObject);
    procedure mnudoingClick(Sender: TObject);
    procedure mnuNameClick(Sender: TObject);
    procedure mnuDescClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CreateJoinAGame1Click(Sender: TObject);
    procedure DXPlay1SessionLost(Sender: TObject);
    procedure ExittheGame1Click(Sender: TObject);
    procedure MainChat1Click(Sender: TObject);
    procedure PlayerList1Click(Sender: TObject);
    procedure SndMsgToSinglePlayerOld(prvMsgToRemotePlayer: String; RemotePlayerID: Integer);
    procedure TranslatePrivateMessage(prvMsgRcvdFrmRemotePlayer: String);
    procedure TranslateAction(prvMsgRcvdFrmRemotePlayer: String);
    procedure TranslateImage(prvMsgRcvdFrmRemotePlayer: String);
    procedure TranslateSound(prvMsgRcvdFrmRemotePlayer: String);
    procedure TranslateMusic(prvMsgRcvdFrmRemotePlayer: String);
    Procedure TranslatePlgMsg(MsgRcvd: String);

    procedure LoadCharacterSettings1Click(Sender: TObject);
    procedure SaveCharacterSettings1Click(Sender: TObject);
    procedure loadchatClick(Sender: TObject);
    procedure SaveChatClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure PlayerMacros1Click(Sender: TObject);
    procedure SystemInformation1Click(Sender: TObject);
    procedure EditCreateMacros1Click(Sender: TObject);
    procedure mnuPluginClick(Sender: TObject);
    procedure DXPlay1Close(Sender: TObject);
    procedure LoadPCSetting;
    procedure LoadNPCSetting;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SoundPictureFiles1Click(Sender: TObject);
    procedure ClearChatWindow1Click(Sender: TObject);
    procedure Preferences1Click(Sender: TObject);
    procedure SystemMessages1Click(Sender: TObject);
    procedure Volume1Click(Sender: TObject);
    function vreSearchPath(FileName: String): String;
    procedure Notes1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure NewCharacter1Click(Sender: TObject);
    procedure EditCharacterData1Click(Sender: TObject);
  public
  end;

var
  MainForm: TMainForm;
  lstMsgsRcvd: TStringList;
  CharSettings: TBigIniFile;
  GameSettings: TBigIniFile;
  SndToAll: TDLLSendAll;
  SndToOne: TDLLSendOne;
  ShowMySysInfo:TDLLShowSysInfo;
  ShowMyVolume:TDllShowVolume;

  StatChang: TPluginStsChng;
  CntMode, gvAction, path, NPCFilePath: string;
  MyDllHandle: integer;
  sndDone, sndMessage, sndStartup, sndConnect : boolean;
  sndDice, sndLock, sndUnLock, sndKick, sndDisconnect: boolean;
  MusicBackground : Boolean;
  DPConnected: Boolean;
  Group1IsActive,Group2IsActive, Group3IsActive, Group4IsActive: Boolean;
  MsgLock, MsgUnLock, MsgKick, MsgBlind, MsgMute, MsgDeaf, MsgGroup: boolean;

implementation

uses Plugins, ImgSnd, preferences, sysMessages, Notes, about, Sound,
  character;

{$R *.DFM}

procedure TMainForm.DXPlay1AddPlayer(Sender: TObject; Player: TDXPlayPlayer);
begin
  if Player.RemotePlayer then
     begin
          frmSysMsg.mmoSysMsg.Lines.Add('*'+Player.Name+' has entered the game.*');
          frmPlayerList.AddAPlayer(Player.Name + '\' + IntToStr(Player.ID));
     end;
end;

procedure TMainForm.DXPlay1DeletePlayer(Sender: TObject;
  Player: TDXPlayPlayer);
begin
     if Player.RemotePlayer then
        begin
             frmPlayerList.DeleteAPlayer(Player.Name + '\' + IntToStr(Player.ID));
             frmSysMsg.mmoSysMsg.Lines.Add('*'+Player.Name+' has left the game.*');
        end;
end;

procedure TMainForm.DXPlay1Open(Sender: TObject);
var
   i: Integer;
begin

  //Sound
  try
     if sndConnect  then
        frmSound.PlayWave(vreSearchPath('connect.wav'));
  except
      on E: Exception do
    begin
//      Application.HandleException(E);
//      Application.Terminate;
    end;

  end;
   frmChat.Show;
   frmPlayerList.show;
//  if DXPlay1.isHost then frmChat.GroupBox1.visible := true;
  for i:=0 to DXPlay1.Players.Count-1 do
      begin
           if DXPlay1.Players[i].RemotePlayer then
              begin
                   frmSysMsg.mmoSysMsg.Lines.Add(Format('*%s is entering the game.*', [DXPlay1.Players[i].Name]));
                   frmPlayerList.AddAPlayer(DXPlay1.Players[i].Name + '\' + IntToStr(DXPlay1.Players[i].ID));
              end;
      end;
  if MyDllHandle <> 0 then
     begin
          SndToAll := GetProcAddress(MyDllHandle, cDLL_SndAll);
          SndToOne := GetProcAddress(MyDllHandle, cDLL_SndOne);
     end;

       VRLocalPlayer.Player_Name := DXPlay1.LocalPlayer.Name;

end;

procedure TMainForm.FormCreate(Sender: TObject);
begin


  CntMode := 'NotConnect';
  MainStatus.Panels[0].Text := 'Not Connected';
  MainStatus.Panels[1].Text := 'Session Name: None';
  MainStatus.Panels[2].Text := 'Client Status: None';

  //create our list for received private messages
  lstMsgsRcvd := TStringList.Create;



end;
//Received Message
procedure TMainForm.DXPlay1Message(Sender: TObject; Player: TDXPlayPlayer; Data: Pointer;
  DataSize: Integer);
var
  chrMsg: string;
begin
  case DXPlayMessageType(Data) of
    DXCHAT_MESSAGE:
        begin
          if TDXChatMessage(Data^).Len<=0 then
            chrMsg := ''
          else begin
            SetLength(chrMsg, TDXChatMessage(Data^).Len);
            StrLCopy(PChar(chrMsg), @TDXChatMessage(Data^).c, Length(chrMsg));
          end;
          //sound
          try
            if (sndDice) and (StrTokenAt(chrMsg, '|',0)= 'vrtDice1.0') and (StrTokenAt(chrMsg, '|',1) = DXPlay1.LocalPlayer.Name)then
               frmSound.PlayWave(vreSearchPath('dice.wav'));

          except
          end;
          if Not(frmPlugin.RcvdMsgToPlugins(chrMsg)) then exit;


          //Received a normal message
          if StrTokenAt(StrTokenAt(chrMsg, '|',0),':',0) = 'Message' then
             TranslateMessage(chrMsg);
          //Take s3m, mp3, midi
          if StrTokenAt(chrMsg, '|',0)= 'Music' then
             TranslateMusic(chrMsg);

          //sound
          if StrTokenAt(chrMsg, '|',0)= 'Sound' then
             TranslateSound(chrMsg);

          if StrTokenAt(chrMsg, '|',0)= 'Picture' then
             TranslateImage(chrMsg);
            //private action
          if StrTokenAt(chrMsg, '|',0)= 'Action' then
             TranslateAction(chrMsg);
          //received a private message
          if StrTokenAt(chrMsg, '|',0)= 'PrivateMessage' then
             TranslatePrivateMessage(chrMsg);

          //received a private message
          if StrTokenAt(chrMsg, '|',0)= 'plgmsg' then
             TranslatePlgMsg(chrMsg);



        end;
  end;
end;



Procedure TMainForm.TranslateMessage(MsgRcvd: String);
var
{   ChrNameFontColor:      TColor;
   ChrNameFontSize:       Integer;
   ChrNameFontBold:       String;
   ChrNameFontItalic:     String;
   ChrNameFontUnder:      String;
   MsgBodyFontColor:      TColor;
   MsgBodyFontSize:       Integer;
   MsgBodyFontBold:       String;
   MsgBodyFontItalic:     String;
   MsgBodyFontUnder:      String;
   MsgChrDesc:            String;
 }  MsgAction:             String;
//   MsgBody:               String;

begin
{
Color|Size|Bold|Italic|Underlined|Description|Talk/Action|Message
Color|Integer|T/F|T/F|T/F|String|String|String
}
//'<img src="images/lich.gif" width="25" height="43">'
   if Not DxPlay1.IsHost then
      begin
         if StrTokenAt(StrTokenAt(MsgRcvd, '|', 0), ':', VRLocalPlayer.Group) <> 'True' then exit;
      end;

// group|ActionType|ChrName|chrMsg));
   MsgAction := StrTokenAt(MsgRcvd,'|',1);



   if (MsgAction = 'Talk') and (VRLocalPlayer.Status_Deaf) then exit;
   if (MsgAction = 'Action') and (VRLocalPlayer.Status_Blind) then exit;

   if MsgAction = 'Action' then
      frmChat.ChatLog.add(StrTokenAt(MsgRcvd,'|',2) +'*'+StrTokenAt(MsgRcvd,'|',3) +' '+StrTokenAt(MsgRcvd,'|',4) + '* <br>');
    //format the message for talking
    if MsgAction = 'Talk' then
      frmChat.ChatLog.add(StrTokenAt(MsgRcvd,'|',2) +StrTokenAt(MsgRcvd,'|',3)+' says: '+StrTokenAt(MsgRcvd,'|',4)+'<br>');

     frmChat.MainChat.LoadStrings(frmChat.ChatLog);

     frmChat.MainChat.VScrollBarPosition :=frmChat.MainChat.VScrollBarRange;

//   ChatLog
   //read in font setting for character name
{   ChrNameFontColor := StringToColor(StrTokenAt(MsgRcvd, '|', 1));
   ChrNameFontSize :=  StrToInt(StrTokenAt(MsgRcvd, '|', 2));
   ChrNameFontBold :=  StrTokenAt(MsgRcvd, '|', 3);
   ChrNameFontItalic :=  StrTokenAt(MsgRcvd, '|', 4);
   ChrNameFontUnder :=  StrTokenAt(MsgRcvd, '|', 5);
   //get the character name to print
   MsgChrDesc :=  StrTokenAt(MsgRcvd, '|', 6);
   //get the characters action type
   MsgAction :=  StrTokenAt(MsgRcvd, '|', 7);
   if (MsgAction = 'Talk') and (VRLocalPlayer.Status_Deaf) then exit;
   if (MsgAction = 'Action') and (VRLocalPlayer.Status_Blind) then exit;

   //read in font setting for messagebody
   MsgBodyFontColor := StringToColor(StrTokenAt(MsgRcvd, '|', 8));
   MsgBodyFontSize :=  StrToInt(StrTokenAt(MsgRcvd, '|', 9));
   MsgBodyFontBold :=  StrTokenAt(MsgRcvd, '|', 10);
   MsgBodyFontItalic :=  StrTokenAt(MsgRcvd, '|', 11);
   MsgBodyFontUnder :=  StrTokenAt(MsgRcvd, '|', 12);
   //get the message body
   MsgBody :=  StrTokenAt(MsgRcvd, '|', 13);

   //set up the RichEdit for the character font
   with frmChat.reChatWindow.SelAttributes do
        begin
             Color := ChrNameFontColor;
             Size := ChrNameFontSize;
             Style := [];
             if ChrNameFontBold = 'True' then Style := Style + [fsbold];
             if ChrNameFontItalic  = 'True' then Style := Style + [fsItalic];
             if ChrNameFontUnder  = 'True' then Style := Style + [fsUnderline];

        end;
   //format the message for an action
   if MsgAction = 'Action' then
      frmChat.reChatWindow.Lines.Append('*'+MsgChrDesc + Space + MsgBody + '*');
    //format the message for talking
    if MsgAction = 'Talk' then
       begin
            frmChat.reChatWindow.Lines.Append(MsgChrDesc + ' says: '+ MsgBody);
            //setup the rich text font for the messages
            frmChat.reChatWindow.SelStart := length(frmChat.reChatWindow.text)-3 - Length(MsgBody);
            frmChat.reChatWindow.SelLength := length(MsgBody)+1;
            with frmChat.reChatWindow.SelAttributes do
                 begin
                      Color := MsgBodyFontColor;
                      Size := MsgBodyFontSize;
                      Style := [];
                      if MsgBodyFontBold = 'True' then Style := Style + [fsbold];
                      if MsgBodyFontItalic  = 'True' then Style := Style + [fsItalic];
                      if MsgBodyFontUnder  = 'True' then Style := Style + [fsUnderline];
                 end;
       end;
   //write the message to the richedit box
   try
 //     if frmChat.Active then
//         begin
              frmChat.reChatWindow.SelStart := length(frmChat.reChatWindow.text);
              frmChat.reChatWindow.SetFocus;
              frmchat.EdtMsgBody.setfocus;
//         end;
   except
       on E: Exception do
    begin
//      Application.HandleException(E);
//      Application.Terminate;
    end;

   end;
 }
end;

Procedure TMainForm.TranslatePlgMsg(MsgRcvd: String);

begin

     frmChat.ChatLog.add(StrTokenAt(MsgRcvd,'|',1)+'<br>');

     frmChat.MainChat.LoadStrings(frmChat.ChatLog);

     frmChat.MainChat.VScrollBarPosition :=frmChat.MainChat.VScrollBarRange;


end;


procedure TMainForm.Options1Click(Sender: TObject);
begin

   if frmOptions.ShowModal = mrOk then
      begin
           frmChat.lblPlayerName.Caption := FrmOptions.EdtChrName.Text;
           frmChat.lblPlayerName.font.color := FrmOptions.EdtChrName.font.color;
           frmChat.lblPlayerDesc.Caption := FrmOptions.edtChrDesc.text;
           frmChat.lblPlayerDesc.font.color := FrmOptions.edtChrDesc.font.color;
           frmChat.FontDialog1.font := FrmOptions.edtChrName.Font;
      end;

end;

procedure TMainForm.Exit1Click(Sender: TObject);
begin
    close;
end;

procedure TMainForm.mnuspeakingClick(Sender: TObject);
begin
   frmChat.rbTalk.checked := true;
   mnuspeaking.checked := true;
end;

procedure TMainForm.mnudoingClick(Sender: TObject);
begin
   frmChat.rbAction.checked := true;
   mnudoing.checked := true;

end;

procedure TMainForm.mnuNameClick(Sender: TObject);
begin
     mnuName.Checked := true;
     frmChat.rbtnName.checked := true;
end;

procedure TMainForm.mnuDescClick(Sender: TObject);
begin
     mnuDesc.checked := true;
     frmChat.rbtnDesc.checked := true;
end;


procedure TMainForm.FormShow(Sender: TObject);
var
iniOptions: TBigIniFile;
MyCursor : String;
i: integer;
MidiFile: string;
IntMyDll:  TDLLInit;

begin

     iniOptions := TBigIniFile.Create(path+'vrtable.ini');

     MyCursor := iniOptions.readString('Options','Cursor','cursor1.cur');
     if iniOptions.readInteger('Options','CursorItem',1)=8 then
        begin
             SetSystemCursor(LoadCursorFromFile(PChar(MyCursor)), OCR_NORMAL);
             frmPref.Edit1.text := MyCursor;
             frmPref.RadioButton8.checked := true;
        end
     else
         begin
              if iniOptions.readInteger('Options','CursorItem',1)=1 then
                 frmPref.RadioButton1.checked := true;
              if iniOptions.readInteger('Options','CursorItem',1)=2 then
                 frmPref.RadioButton2.checked := true;
              if iniOptions.readInteger('Options','CursorItem',1)=3 then
                 frmPref.RadioButton3.checked := true;
              if iniOptions.readInteger('Options','CursorItem',1)=4 then
                 frmPref.RadioButton4.checked := true;
              if iniOptions.readInteger('Options','CursorItem',1)=5 then
                 frmPref.RadioButton5.checked := true;
              if iniOptions.readInteger('Options','CursorItem',1)=6 then
                 frmPref.RadioButton6.checked := true;

              SetSystemCursor(LoadCursorFromFile(PChar(path+'cursors\'+ MyCursor)), OCR_NORMAL);
         end;


     if paramstr(1) <> '/GM' then
        begin
             MSOfficeCaption1.CaptionText.Caption := '  (Player Client)';
             LoadGameFiles1.visible := false;
             SaveGameFiles1.visible := false;
             Speedbutton1.hint := 'Load character file';
             SendAs2.visible := false;
             LoadGameFiles1.enabled := false;
             SaveGameFiles1.enabled := false;
             SendAs2.enabled := false;
             frmChat.GroupBox1.Visible := false;
             frmChat.GroupBox1.Enabled := false;
             frmMacro.TabSheet2.Tabvisible := false;
             frmChat.pnlgroup.visible := false;
             frmPlayerList.TabSheet2.TabVisible := false;
             btnCreateJoin.enabled := false;
             CreateJoinAGame1.enabled := false;

        end
     else
         begin
              MSOfficeCaption1.CaptionText.Caption := '  (GM Client)';
              SaveCharacterSettings1.visible := false;
              SaveCharacterSettings1.enabled := false;
              Speedbutton1.hint := 'Load game file';
              LoadCharacterSettings1.visible := false;
              LoadCharacterSettings1.enabled := false;

              btnCreateJoin.enabled := false;
              CreateJoinAGame1.enabled := false;
         end;

     FrmPref.cbMLock.checked := iniOptions.readBool('Messages', 'Lock', false);
     msgLock :=  FrmPref.cbMLock.checked;
     FrmPref.cbMUnlock.checked := iniOptions.readBool('Messages', 'UnLock', false);
     msgUnLock:=  FrmPref.cbMUnlock.checked;
     FrmPref.cbMkick.checked := iniOptions.readBool('Messages', 'Kick', false);
     msgKick :=  FrmPref.cbMkick.checked;
     FrmPref.cbMblind.checked := iniOptions.readBool('Messages', 'Blind', false);
     msgBlind :=  FrmPref.cbMblind.checked;
     FrmPref.cbMdeaf.checked := iniOptions.readBool('Messages', 'Deaf', false);
     msgDeaf :=  FrmPref.cbMdeaf.checked;
     FrmPref.cbMmute.checked := iniOptions.readBool('Messages', 'Mute', false);
     msgMute :=  FrmPref.cbMmute.checked;
     FrmPref.cbMGroup.checked := iniOptions.readBool('Messages', 'Group', false);
     msgGroup :=  FrmPref.cbMGroup.checked;


     FrmPref.cbMessage.checked := iniOptions.ReadBool('Options', 'Message', False);
     SndMessage := FrmPref.cbMessage.checked;
     FrmPref.cbStartup.checked := iniOptions.ReadBool('Options', 'Startup', False);
     SndStartup := FrmPref.cbStartup.checked;
     FrmPref.cbConnect.checked := iniOptions.ReadBool('Options', 'Connect', False);
     SndConnect := FrmPref.cbConnect.checked;
     FrmPref.cbDice.checked := iniOptions.ReadBool('Options', 'Dice', False);
     SndDice := FrmPref.cbDice.checked;
     FrmPref.cbLock.checked := iniOptions.ReadBool('Options', 'Lock', False);
     SndLock := FrmPref.cblock.checked;
     FrmPref.cbUnlock.checked := iniOptions.ReadBool('Options', 'UnLock', False);
     SndUnlock := FrmPref.cbUnLock.checked;
     FrmPref.cbkick.checked := iniOptions.ReadBool('Options', 'Kick', False);
     SndKick := FrmPref.cbKick.checked;
     FrmPref.cbMusic.checked := iniOptions.ReadBool('Options', 'Music', False);
     MusicBackground := FrmPref.cbMusic.checked;
     FrmPref.cbDisconnect.checked := iniOptions.ReadBool('Options', 'Disconnect', False);
     sndDisconnect := FrmPref.cbDisconnect.checked;





     //Search Path
     if iniOptions.readInteger('Search Path', 'Count', 0) <> 0 then
        begin
             for i := 0 to iniOptions.readInteger('Search Path', 'Count', 0) -1 do
                 begin
                      frmPref.mmoSearch.Lines.Add(iniOptions.readString('Search Path','Path'+ IntToStr(i),''));
                 end;
        end
     else
         begin
             frmPref.mmoSearch.Lines.Add(Lowercase(path));
             frmPref.mmoSearch.Lines.Add(Lowercase(path+'sounds'));
             frmPref.mmoSearch.Lines.Add(Lowercase(path+'images'));
             frmPref.mmoSearch.Lines.Add(Lowercase(path+'music'));
             frmPref.mmoSearch.Lines.Add(Lowercase(path+'gamefiles'));
             frmPref.mmoSearch.Lines.Add(Lowercase(path+'character'));
             frmPref.mmoSearch.Lines.Add(Lowercase(path+'cursors'));
             frmPref.mmoSearch.Lines.Add(Lowercase(path+'plugin'));
         end;

     iniOptions.Free;
     iniOptions := nil;

      if MusicBackground then
        begin

             //frmSound.playmp3(vreSearchPath('VolkswagonJetta.mp3'),false, true)
             //background.mid
             midiFile := vreSearchPath('overhill.mid');
             if midiFile <> 'FNF' then
             frmSound.OpenMidiFile(midiFile);
             if frmSound.MidiData1.Active then
                begin
                     frmSound.MidiPlayer1.Play := True
                end;
        end;


     if MyDllHandle = 0 then
     begin
          MyDllHandle := LoadLibrary(PChar('vrtable.dll'));
          IntMyDll := GetProcAddress(MyDllHandle, cDLL_INIT);
          ShowMySysInfo := GetProcAddress(MyDllHandle, cDLL_ShowSysInfo);
          ShowMyVolume := GetProcAddress(MyDllHandle, cDLL_ShowVolume);

          if assigned(IntMyDll) then
          begin
               IntMyDll(DXPlay1, Application.Handle);
          end;
     end;

          //Sound
        if sndStartUp then
           frmSound.PlayWave(vreSearchPath('startup.wav'));

end;

procedure TMainForm.CreateJoinAGame1Click(Sender: TObject);
var
configForm : TfrmConnect;
begin
   try
      try
         ConfigForm := TfrmConnect.Create(Self);
         ConfigForm.DXPlay := DXPlay1;
         if paramstr(1) <> '/GM' then
            begin
                 ConfigForm.JoinGame.Checked := true;
            end;
         ConfigForm.NewGamePlayerName.text := VrLocalPlayer.Character_Name;
         ConfigForm.JoinGamePlayerName.text := VrLocalPlayer.Character_Name;

        if ConfigForm.ShowModal = mrOk then
           begin
                CntMode := 'Connected';
                MainStatus.Panels[0].Text := 'Connected';
                MainStatus.Panels[1].Text := 'Session Name: ' +  DXPlay1.SessionName;
                if DXPlay1.isHost then
                   MainStatus.Panels[2].Text := 'Client Status: Master Control'
                else
                    MainStatus.Panels[2].Text := 'Client Status: Locked';

                ExittheGame1.enabled := true;
                btnleave.enabled := true;
                CreateJoinAGame1.enabled := false;
                btnCreateJoin.enabled := false;
                frmPlayerList.isActive;
                if DxPlay1.isHost then
                   begin
                        frmChat.btnSend.enabled := true;
                        frmChat.btnSend.caption := 'Send';
                   end;
           end;
      finally
         ConfigForm.Free;
      end;

  except
      CntMode := 'NotConnected';
      MainStatus.Panels[0].Text := 'Not Connected';
      MainStatus.Panels[1].Text := 'Session Name: None';
      MainStatus.Panels[2].Text := 'Client Status: None';

      ExittheGame1.enabled := false;
      btnleave.enabled := false;
      CreateJoinAGame1.enabled := true;
      btnCreateJoin.enabled := true;
      frmPlayerList.isInActive;
      frmChat.btnSend.enabled := false;
  end;

end;

procedure TMainForm.DXPlay1SessionLost(Sender: TObject);
begin
  CntMode := 'NotConnect';
  MainStatus.Panels[0].Text := 'Lost Connection';
  MainStatus.Panels[1].Text := 'Session Name: None';
  MainStatus.Panels[2].Text := 'Client Status: None';

  ExittheGame1.enabled := false;
  btnleave.enabled := false;
  CreateJoinAGame1.enabled := true;
  btnCreateJoin.enabled :=true;
  frmPlayerList.isInActive;
  frmChat.btnSend.enabled := false;
  //Add code to reset everything
end;

procedure TMainForm.ExittheGame1Click(Sender: TObject);
begin

  CntMode := 'NotConnect';
  MainStatus.Panels[0].Text := 'Not Connected';
  MainStatus.Panels[1].Text := 'Session Name: None';
  MainStatus.Panels[2].Text := 'Client Status: None';

  ExittheGame1.enabled := false;
  btnleave.enabled := false;
  CreateJoinAGame1.enabled := true;
  btnCreateJoin.enabled := true;

  frmPlayerList.isInActive;
  frmChat.btnSend.enabled := false;

  try
     DXPlay1.Close;


    while frmPlayerList.PlayerList.count <> 0 do
    begin
          TVrePlayer(frmPlayerList.PlayerList.Objects[0]).Reindex;
          TVrePlayer(frmPlayerList.PlayerList.Objects[0]).free;
          frmPlayerList.PlayerList.delete(0);
    end;
    frmPlayerList.PlayerList.Clear;

  except
      on E: Exception do
    begin
//      Application.HandleException(E);
//      Application.Terminate;
    end;
 end;
  //Add code to reset everything

end;

procedure TMainForm.MainChat1Click(Sender: TObject);
begin
     //show the chat form
//     if MainChat1.Checked then
//        frmChat.Close
//     else
         FrmChat.Setup;

end;

procedure TMainForm.PlayerList1Click(Sender: TObject);
begin
     //show the player list
     if PlayerList1.Checked then
        begin
             frmPlayerList.close;
             PlayerList1.Checked := false;
        end
     else
         begin
              frmPlayerList.Setup;
              PlayerList1.Checked := true;
         end;
end;


procedure TMainForm.SndMsgToSinglePlayerOld(prvMsgToRemotePlayer: String; RemotePlayerID: Integer);
var
  Msg: ^TDXChatMessage;
  MsgSize: Integer;
begin

  MsgSize := SizeOf(TDXChatMessage)+Length(prvMsgToRemotePlayer);
  GetMem(Msg, MsgSize);
  try
    Msg.dwType := DXCHAT_MESSAGE;

    Msg.Len := Length(prvMsgToRemotePlayer);

    StrLCopy(@Msg^.c, PChar(prvMsgToRemotePlayer), Length(prvMsgToRemotePlayer));
    //Send the message to the specific player
    DXPlay1.SendMessage(RemotePlayerID, Msg, MsgSize);

  finally
    FreeMem(Msg);
  end;
end;

procedure TMainForm.TranslatePrivateMessage(prvMsgRcvdFrmRemotePlayer: String);
var
i : integer;
PlayerName: string;
PlayerID: string;
PlayerMessage: String;
begin

PlayerName := StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1), '\', 0);
PlayerID:= StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1), '\', 1);
PlayerMessage := StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 2);

   for I := 0 to frmPlayerList.PlayerList.Count -1 do
   begin
        if TVREPlayer(frmPlayerList.PlayerList.Objects[i]).Player_ID = PlayerID then
        begin
             TVREPlayer(frmPlayerList.PlayerList.Objects[i]).Message_Waiting := true;
             TVREPlayer(frmPlayerList.PlayerList.Objects[i]).Player_Messages.Add(PlayerMessage);
             TVREPlayer(frmPlayerList.PlayerList.Objects[i]).Chat_History.Add('.................');
             TVREPlayer(frmPlayerList.PlayerList.Objects[i]).Chat_History.Add(PlayerName + ': '+ PlayerMessage);
        end;
   end;

   //change to ICon to indicate a new messages
//   if frmPlayerList.CurrentCondition(frmPlayerList.playrList.ItemFocused.caption) <> 2 then
//   frmPlayerList.UpdateConditionList(frmPlayerList.playrList.ItemFocused.caption,'Message');
//   frmPlayerList.playrList.ItemFocused.ImageIndex := frmPlayerList.CurrentCondition(frmPlayerList.playrList.ItemFocused.caption);
   //Add the message to the list of received messages
//   lstMsgsRcvd.Add(prvMsgRcvdFrmRemotePlayer);

//   for I := 0 to frmPlayerList.ComponentCount - 1 do
//       begin
//            if (frmPlayerList.Components[i] is TMemo) then
//            if (frmPlayerList.Components[i] as TMemo).Name = StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1), '\', 0) then
//               begin
//                    (frmPlayerList.Components[i] as TMemo).lines.Add('...');
//                    (frmPlayerList.Components[i] as TMemo).lines.Add( StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1), '\', 0)+': ' + StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 2));
//               end;
//       end;

  //sound
  try
    if sndMessage then
       frmSound.PlayWave(vreSearchPath('message.wav'));
    except
      on E: Exception do
    begin
//      Application.HandleException(E);
//      Application.Terminate;
    end;
  end;

end;

procedure TMainForm.LoadCharacterSettings1Click(Sender: TObject);
var
newcaption: string;
newHint : string;
newType : string;
NewMacro: TExplorerButton;
NewImage: TBitMap;
I: integer;
tf: string;
begin
     if Paramstr(1) = '/GM' then
        begin
             OpenChrFile.InitialDir := path + 'gamefiles';
             OpenChrFile.FilterIndex := 2;
        end
     else
         begin
              OpenChrFile.InitialDir := path + 'character';
              OpenChrFile.FilterIndex := 1;
         end;

  if OpenChrFile.execute then
  begin
       if Not(DXPlay1.Opened) then
       begin
            btnCreateJoin.enabled := true;
            CreateJoinAGame1.enabled := true;
       end;

       SendAs2.visible := false;
       CharSettings := TBigIniFile.Create(OpenChrFile.filename);
       frmChat.tcCharacterList.Tabs.Clear;
       frmChat.tcCharacterList.visible := true;
       frmChat.Panel5.bevelouter := bvRaised;
       frmOptions.edtChrName.text := '';
       frmOptions.edtChrDesc.text := '';

       while frmMacro.macrolist.ComponentCount <> 0 do
           begin
                (frmMacro.macrolist.Components[0] as TExplorerButton).free;
           end;


       if CharSettings.ReadString('FileType', 'Type', '') = 'GM' then
          begin
             SendAs2.visible := true;
       //      frmOptions.rgChrType.ItemIndex := 1;
             NPCFilePath := OpenChrFile.fileName;
             LoadNPCSetting;
          end
       else
       if CharSettings.ReadString('FileType', 'Type', '') = 'PC' then
          LoadPCSetting;

     for I := 0 to CharSettings.ReadInteger('Macro', 'Count',0) - 1 do
       begin
          NewCaption := StrTokenAt(CharSettings.ReadString('Macro', 'Macro'+IntToStr(i), ''), '%',2);
          NewHint := StrTokenAt(CharSettings.ReadString('Macro', 'Macro'+IntToStr(i), ''), '%',1);
          NewType := StrTokenAt(CharSettings.ReadString('Macro', 'Macro'+IntToStr(i), ''), '%',0);
          NewImage := frmMacro.pictsay.bitmap;

          if NewType = 'Action' then
             NewImage := frmMacro.pictDo.bitmap;
          if NewType =  'Play Sound' then
             NewImage := frmMacro.picthear.bitmap;
          if NewType = 'Show Image' then
             NewImage := frmMacro.pictsee.bitmap;

          NewMacro := TExplorerButton.Create(frmMacro.macrolist);
          NewMacro.Parent := frmMacro.macrolist;
          NewMacro.visible := false;
          NewMacro.Alignment := frmMacro.pictsee.Alignment;//taLeftJustify;
          NewMacro.Layout := blBitmapLeft;
          NewMacro.UnselectedFontColor := clblack;
          NewMacro.NoFocusBitmap:= NewImage;
          NewMacro.Font.Color := clBlue;
          NewMacro.Bitmap := NewImage;
          NewMacro.Caption := NewCaption;
          NewMacro.Hint := NewType +'%'+NewHint;
          NewMacro.Left:= 0;
          NewMacro.height := 25;
          NewMacro.top := 25 * (frmMacro.MacroList.ControlCount -1);
          NewMacro.width := frmMacro.MacroList.clientwidth;
          NewMacro.OnClick := frmMacro.myClick;
          NewMacro.ShowHint := false;
          NewMacro.visible := true;
          NewMacro.Show;
          NewMacro := Nil;
          frmMacro.lbMacro.Items.add(NewCaption);
       end;
       try
          if Paramstr(1) = '/GM' then
             begin
                  tf := ExtractFilePath(OpenChrFile.FileName) + StrTokenAt(ExtractFileName(OpenChrFile.FileName),'.', 0) + '.gcl';
                //FiX
                //  frmSndImg.DXImageList1.Items.LoadFromFile(tf);
               //   frmSndImg.label3.caption := ExtractFileName(tf);
               //   for i := 0 to  CharSettings.ReadInteger('Image', 'count',0)-1 do
               //       begin
               //            frmSndImg.lbImagelist.Items.Add(CharSettings.ReadString('Image', 'img'+IntToStr(i), ''));
               //       end;
                  //FIX sound
                 // tf := ExtractFilePath(OpenChrFile.FileName) + StrTokenAt(ExtractFileName(OpenChrFile.FileName),'.', 0) + '.scl';
                 // frmSndImg.DXWaveList1.Items.LoadFromFile(tf);
                 // frmSndImg.label4.caption := ExtractFileName(tf);
                //  for i := 0 to  CharSettings.ReadInteger('Sound', 'count',0)-1 do
                //      begin
                //           frmSndImg.lbSoundlist.Items.Add(CharSettings.ReadString('Sound', 'snd'+IntToStr(i), ''));
                //      end;

             end;
       except
             on E: Exception do
                begin
//                     Application.HandleException(E);
                  //   frmSndImg.lbImagelist.Items.Add('File Not Found');
//                     Application.Terminate;
                end;
       end;

        CharSettings.free;
        CharSettings := nil;
  end;

end;

procedure TMainForm.SaveCharacterSettings1Click(Sender: TObject);
var
i: integer;
MacInfo: string;
begin

  if OpenChrFile.FileName <> '' then
     saveChrFile.filename := OpenChrFile.FileName
  else
      if SaveChrFile.FileName = '' then
         saveChrFile.filename := 'Untitled.chr';

  saveChrFile.InitialDir := path + 'character';
  if saveChrFile.execute then
  begin
       if not Assigned (CharSettings) then
       CharSettings := TBigIniFile.Create(saveChrFile.filename);
       CharSettings.writeString('FileType', 'Type','PC');
       //Character Data
       CharSettings.WriteString('character','ImageName', VrLocalPlayer.Image_Name);
       CharSettings.WriteString('character','ImageWidth', VrLocalPlayer.Image_Width);
       CharSettings.WriteString('character','ImageHeight', VrLocalPlayer.Image_Height);

       CharSettings.writeString('Character', 'PlayerName',VrLocalPlayer.Player_Name);
       CharSettings.writeString('Character', 'CharacterName',VrLocalPlayer.Character_Name);
       CharSettings.WriteString('Character', 'CharacterDesc',VrLocalPlayer.Description_Short);

       CharSettings.writeString('Character', 'FontColor',ColorToString(FrmOptions.edtChrName.Font.color));
       CharSettings.WriteInteger('Character', 'FontSize',FrmOptions.edtChrName.Font.size);

       CharSettings.WriteBool('Character', 'FontItalic',fsItalic in FrmOptions.edtChrName.Font.Style);
       CharSettings.WriteBool('Character', 'FontBold',fsBold in FrmOptions.edtChrName.Font.Style);
       CharSettings.writeBool('Character', 'FontUnderline',fsUnderline in FrmOptions.edtChrName.Font.Style);
       CharSettings.WriteInteger('Long', 'count', VrLocalPlayer.Description_Long.count);
       for i := 0 to VrLocalPlayer.Description_Long.count -1 do
       CharSettings.WriteString('Long', 'Line'+IntToStr(i),VrLocalPlayer.Description_Long.Strings[i]);

       CharSettings.WriteInteger('Stats', 'count', VrLocalPlayer.Character_QuickStat.count);
       for i := 0 to  VrLocalPlayer.Character_QuickStat.count -1  do
       CharSettings.WriteString('Stats', 'Stat'+IntToStr(i),VrLocalPlayer.Character_QuickStat.Strings[i]);

       CharSettings.WriteString('Character', 'Race', VrLocalPlayer.Race);
       CharSettings.WriteString('Character', 'Alignment', VrLocalPlayer.Alignment);
       CharSettings.WriteString('Character', 'Sex', VrLocalPlayer.Sex);
       CharSettings.WriteString('Character', 'Height', VrLocalPlayer.Height);
       CharSettings.WriteString('Character', 'Weight', VrLocalPlayer.Weight);
       CharSettings.WriteString('Character', 'Size', VrLocalPlayer.Size);
       CharSettings.WriteString('Character', 'Age', VrLocalPlayer.Age);
       CharSettings.WriteString('Character', 'Hair', VrLocalPlayer.Hair);
       CharSettings.WriteString('Character', 'Eyes', VrLocalPlayer.Eyes);
       CharSettings.WriteString('Character', 'Abilities', VrLocalPlayer.Abilities);


       //Macros
       CharSettings.writeInteger('Macro', 'Count', frmMacro.macrolist.ComponentCount);
       for I := 0 to frmMacro.macrolist.ComponentCount - 1 do
       begin
          MacInfo := (frmMacro.macrolist.Components[i] as TExplorerButton).Hint +'%'+
              (frmMacro.macrolist.Components[i] as TExplorerButton).Caption;

          CharSettings.writeString('Macro', 'Macro'+IntToStr(i), MacInfo);
       end;

       CharSettings.free;
       CharSettings := nil;



  end;

end;

procedure TMainForm.loadchatClick(Sender: TObject);
begin
  ChatOpen.InitialDir := path + 'ChatLogs';
  if chatOpen.execute then
     begin
          FrmChat.ChatLog.Clear;
          FrmChat.MainChat.Clear;
          FrmChat.ChatLog.LoadFromFile(chatOpen.FileName);
          FrmChat.MainChat.LoadStrings(FrmChat.ChatLog);
          frmChat.MainChat.VScrollBarPosition :=frmChat.MainChat.VScrollBarRange;

     end;

end;

procedure TMainForm.SaveChatClick(Sender: TObject);
begin
if FrmChat.ChatLog.Count = 0  then exit;
if ChatOpen.FileName <> '' then
     Chatsave.filename := ChatOpen.FileName
  else
     if Chatsave.filename = '' then
        Chatsave.filename := 'Untitled.rtf';

  Chatsave.InitialDir := path + 'ChatLogs';
  if chatsave.execute then
     FrmChat.ChatLog.SaveToFile(chatSave.FileName);

//     frmChat.reChatWindow.lines.SaveToFile(chatSave.FileName);
end;

procedure TMainForm.TranslateAction(prvMsgRcvdFrmRemotePlayer: String);
begin
   if StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 2) = 'Lock' then
      begin
           //sound
           if sndLock then
              frmSound.PlayWave(vreSearchPath('Lock.wav'));


           if MsgLock then
           MessageDlg('Session Host : '+ StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1), '\', 0) + ' has lock you out of the main chat.', mtInformation,[mbOk], 0);
           MainStatus.Panels[2].Text := 'Client Status: Locked by ' + StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1), '\', 0);
           frmChat.btnSend.Caption := 'Locked...';
           frmChat.btnSend.enabled := false;
           frmSysMsg.mmoSysMsg.Lines.Add('Locked by ' + StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1), '\', 0));
      end;
   if StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 2) = 'Unlock' then
      begin
           //sound
           if sndUnLock then
              frmSound.PlayWave(vreSearchPath('unLock.wav'));

           if MsgUnLock then
           MessageDlg('Session Host: '+ StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1), '\', 0) + ' has unlocked your chat.', mtInformation,[mbOk], 0);
           MainStatus.Panels[2].Text := 'Client Status: Normal';
           frmChat.btnSend.Caption := 'Send';
           frmChat.btnSend.enabled := true;
           frmSysMsg.mmoSysMsg.Lines.Add('Unlocked by ' + StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1), '\', 0));

      end;

   if StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 2) = 'Group 1' then
      begin
           VRLocalPlayer.Group := 1;
           frmSysMsg.mmoSysMsg.Lines.Add('Assigned to Group 1');
           if MsgGroup then
           MessageDlg('Session Host: '+ StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1), '\', 0) + ' has assigned you to group' + IntToStr(VRLocalPlayer.Group) , mtInformation,[mbOk], 0);
      end;

   if StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 2) = 'Group 2' then
      begin
           VRLocalPlayer.Group := 2;
           frmSysMsg.mmoSysMsg.Lines.Add('Assigned to Group 2');
           if MsgGroup then
           MessageDlg('Session Host: '+ StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1), '\', 0) + ' has assigned you to group' + IntToStr(VRLocalPlayer.Group) , mtInformation,[mbOk], 0);
      end;

   if StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 2) = 'Group 3' then
      begin
           VRLocalPlayer.Group:= 3;
           frmSysMsg.mmoSysMsg.Lines.Add('Assigned to Group 3');
           if MsgGroup then
           MessageDlg('Session Host: '+ StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1), '\', 0) + ' has assigned you to group' + IntToStr(VRLocalPlayer.Group) , mtInformation,[mbOk], 0);
      end;

   if StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 2) = 'Group 4' then
      begin
           VRLocalPlayer.Group:= 4;
           frmSysMsg.mmoSysMsg.Lines.Add('Assigned to Group 4');
           if MsgGroup then
           MessageDlg('Session Host: '+ StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1), '\', 0) + ' has assigned you to group' + IntToStr(VRLocalPlayer.Group) , mtInformation,[mbOk], 0);
      end;

   if StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 2) = 'Blind' then
      begin
           if MsgBlind then
           MessageDlg( 'You were blinded by Session Host : '+ StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1), '\', 0) , mtInformation,[mbOk], 0);
           VRLocalPlayer.Status_Blind := true;
           frmSysMsg.mmoSysMsg.Lines.Add('Blinded by ' + StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1), '\', 0));

      end;

   if StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 2) = 'NotBlind' then
      begin
           if Msgblind then
           MessageDlg('Session Host: '+ StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1), '\', 0) + ' has returned your sight.', mtInformation,[mbOk], 0);
           VRLocalPlayer.Status_Blind := false;
           frmSysMsg.mmoSysMsg.Lines.Add('Unblinded by ' + StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1), '\', 0));
      end;
   if StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 2) = 'Mute' then
      begin
           if MsgMute then
           MessageDlg( 'You were muted by Session Host : '+ StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1), '\', 0) , mtInformation,[mbOk], 0);
           VRLocalPlayer.Status_Mute := true;
           frmChat.rbTalk.Enabled := false;
           frmChat.rbAction.checked := true;
           mnuspeaking.Enabled := false;
           mnuDoing.checked := true;
           frmSysMsg.mmoSysMsg.Lines.Add('Muted by ' + StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1), '\', 0));

      end;
   if StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 2) = 'NotMute' then
      begin

           if MsgMute then
           MessageDlg('Session Host: '+ StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1), '\', 0) + ' has allowed you speak.', mtInformation,[mbOk], 0);
           VRLocalPlayer.Status_Mute := false;
           frmChat.rbTalk.Enabled := true;
           mnuspeaking.Enabled :=true;
           frmSysMsg.mmoSysMsg.Lines.Add('Unmuted by ' + StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1), '\', 0));

      end;
   if StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 2) = 'Deaf' then
      begin
           if MsgDeaf then
           MessageDlg( 'You were deafend by Session Host : '+ StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1), '\', 0) , mtInformation,[mbOk], 0);

           VRLocalPlayer.Status_Deaf := true;
           frmSysMsg.mmoSysMsg.Lines.Add('Deafend by ' + StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1), '\', 0));

      end;
   if StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 2) = 'NotDeaf' then
      begin
           if MsgDeaf then
           MessageDlg('Session Host: '+ StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1), '\', 0) + ' has returned your hearing.', mtInformation,[mbOk], 0);
           VRLocalPlayer.Status_Deaf := false;
           frmSysMsg.mmoSysMsg.Lines.Add('Undeafend by ' + StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1), '\', 0));

      end;

   MainStatus.Panels[3].text := 'Character Status:';
   if VRLocalPlayer.Status_Blind then
      MainStatus.Panels[3].text :=MainStatus.Panels[3].text + ' Blind';
   if VRLocalPlayer.Status_Mute then
      MainStatus.Panels[3].text :=MainStatus.Panels[3].text + ' Mute';
   if VRLocalPlayer.Status_Deaf then
      MainStatus.Panels[3].text :=MainStatus.Panels[3].text + ' Deaf';

   if (Not(VRLocalPlayer.Status_Blind)) and (Not(VRLocalPlayer.Status_Mute)) and (Not(VRLocalPlayer.Status_Deaf)) then
      MainStatus.Panels[3].text :=MainStatus.Panels[3].text + ' Normal';

   if StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 2) = 'Kick' then
      begin
           //sound
           if sndKick then
              frmSound.PlayWave(vreSearchPath('kick.wav'));

           MessageDlg('Session Host: ' +StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1), '\', 0) + ' has kicked you out of the game. You must now wait a while before you can connect again.', mtInformation,[mbOk], 0);
           MainStatus.Panels[2].Text := 'Client Status: Kicked out by ' + StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1), '\', 0);
           frmSysMsg.mmoSysMsg.Lines.Add('Kicked by ' + StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1), '\', 0));

           while frmPlayerList.PlayerList.count <> 0 do
           begin
                TVrePlayer(frmPlayerList.PlayerList.Objects[0]).ReIndex;
                TVrePlayer(frmPlayerList.PlayerList.Objects[0]).free;
                frmPlayerList.PlayerList.delete(0);
           end;
                frmPlayerList.PlayerList.Clear;

           CntMode := 'NotConnect';
           MainStatus.Panels[0].Text := 'Not Connected';
           MainStatus.Panels[1].Text := 'Session Name: None';
           MainStatus.Panels[2].Text := 'Client Status: None';

           ExittheGame1.enabled := false;
           btnleave.enabled := false;

//           CreateJoinAGame1.enabled := true;
           frmPlayerList.isInActive;
           frmChat.btnSend.enabled := false;
           timer1.enabled := true;
      end;



end;


procedure TMainForm.Timer1Timer(Sender: TObject);
begin
     DXPlay1.Close;
     Timer1.Enabled := false;
     Timer2.Enabled := true;

end;

procedure TMainForm.Timer2Timer(Sender: TObject);
begin
     MessageDlg('You may now join another game.', mtInformation,[mbOk], 0);
     CreateJoinAGame1.enabled := true;
     btnCreateJoin.enabled := true;

     MainStatus.Panels[2].Text := 'Client Status: None';
     timer2.enabled := false;
end;

procedure TMainForm.PlayerMacros1Click(Sender: TObject);
begin
   if PlayerMacros1.Checked then
      frmMacro.Close
   else
       frmMacro.Setup('chat');
end;

procedure TMainForm.SystemInformation1Click(Sender: TObject);
begin
   if assigned(ShowMySysInfo) then
      ShowMySysInfo(VRLocalPlayer.Group);

{ if SystemInformation1.checked then
    begin
         MySysInfo.close;
         SystemInformation1.checked := false;
    end
else
    begin
         if Not(assigned(MySysInfo)) then
            MySysInfo := TfrmSysInfo.create(self);
         MySysInfo.show;
         SystemInformation1.checked := true;
    end;
 }
end;

procedure TMainForm.EditCreateMacros1Click(Sender: TObject);
begin
    frmMacro.Setup('edit');
end;

procedure TMainForm.mnuPluginClick(Sender: TObject);
begin
      if PluginInformation1.checked then
         begin
              frmPlugin.close;
              PluginInformation1.checked := false;
         end
      else
          begin
               frmPlugin.show;
               PluginInformation1.checked := true;
          end;


end;

procedure TMainForm.DXPlay1Close(Sender: TObject);
begin
  //sound
  try
     if sndDisconnect then
       frmSound.PlayWave(vreSearchPath('disconnect.wav'));

  except
      on E: Exception do
    begin
//      Application.HandleException(E);
//      Application.Terminate;
    end;

  end;

SndToAll := nil;
SndToOne := nil;

end;

procedure TMainForm.LoadPCSetting;
var
I: integer;
begin
     FrmOptions.edtChrName.text := CharSettings.ReadString('Character', 'CharacterName','');
     FrmOptions.edtChrDesc.text := CharSettings.ReadString('Character', 'CharacterDesc','');
     frmchat.tcCharacterList.Tabs.Add(FrmOptions.edtChrName.text);
     FrmOptions.edtChrName.Font.color := StringToColor(CharSettings.ReadString('Character', 'FontColor',''));
     FrmOptions.edtChrDesc.Font.color := StringToColor(CharSettings.ReadString('Character', 'FontColor',''));
     FrmOptions.edtChrName.Font.size :=  CharSettings.ReadInteger('Character', 'FontSize',8);
     FrmOptions.edtChrDesc.Font.size :=  CharSettings.ReadInteger('Character', 'FontSize',8);

     VrLocalPlayer.Player_Name := CharSettings.ReadString('Character','PlayerName','');
     VrLocalPlayer.Character_Name := CharSettings.ReadString('Character','CharacterName','');
     VrLocalPlayer.Description_Short := CharSettings.ReadString('Character','CharacterDesc','');
     VrLocalPlayer.Player_Name := CharSettings.ReadString('Character','PlayerName','');

     VrLocalPlayer.Image_Name := CharSettings.ReadString('Character','ImageName','');
     VrLocalPlayer.Image_Height := CharSettings.ReadString('Character','ImageHeight','');
     VrLocalPlayer.Image_Width := CharSettings.ReadString('Character','ImageWidth','');

     VrLocalPlayer.Race := CharSettings.ReadString('Character','Race', '');
     VrLocalPlayer.Alignment := CharSettings.ReadString('Character','Alignment', '');
     VrLocalPlayer.Sex := CharSettings.ReadString('Character','Sex','');
     VrLocalPlayer.Height := CharSettings.ReadString('Character','Height','');
     VrLocalPlayer.Weight := CharSettings.ReadString('Character','Weight','');
     VrLocalPlayer.Size := CharSettings.ReadString('Character','Size','');
     VrLocalPlayer.Age := CharSettings.ReadString('Character','Age','');
     VrLocalPlayer.Hair := CharSettings.ReadString('Character','Hair','');
     VrLocalPlayer.Eyes := CharSettings.ReadString('Character','Eyes','');
     VrLocalPlayer.Abilities := CharSettings.ReadString('Character','Abilities','');


     for i := 0 to CharSettings.ReadInteger('Long', 'count',0) -1 do
      VrLocalPlayer.Description_Long.add(CharSettings.ReadString('Long', 'Line'+IntToStr(i), ''));

     for i := 0 to CharSettings.ReadInteger('Stats', 'count',0) -1 do
      VrLocalPlayer.Character_QuickStat.add(CharSettings.ReadString('Stats', 'Stat'+IntToStr(i), ''));


     if CharSettings.ReadBool('Character', 'FontBold',False) then
        begin
             FrmOptions.btnFontBold.down := true;
             FrmOptions.edtChrName.Font.Style := FrmOptions.edtChrName.Font.Style + [fsBold];
             FrmOptions.edtChrDesc.Font.Style := FrmOptions.edtChrDesc.Font.Style + [fsBold];
        end
     else
         begin
              FrmOptions.edtChrName.Font.Style := FrmOptions.edtChrName.Font.Style - [fsBold];
              FrmOptions.edtChrDesc.Font.Style := FrmOptions.edtChrDesc.Font.Style - [fsBold];
         end;

     if CharSettings.ReadBool('Character', 'FontItalic',False) then
        begin
             FrmOptions.btnFontItalic.down := true;
             FrmOptions.edtChrName.Font.Style := FrmOptions.edtChrName.Font.Style + [fsItalic];
             FrmOptions.edtChrDesc.Font.Style := FrmOptions.edtChrDesc.Font.Style + [fsItalic];
        end
     else
         begin
              FrmOptions.edtChrName.Font.Style := FrmOptions.edtChrName.Font.Style - [fsItalic];
              FrmOptions.edtChrDesc.Font.Style := FrmOptions.edtChrDesc.Font.Style - [fsItalic];
         end;

     if CharSettings.ReadBool('Character', 'FontUnderline',False) then
        begin
             FrmOptions.btnFontUnderLine.down := true;
             FrmOptions.edtChrName.Font.Style := FrmOptions.edtChrName.Font.Style + [fsUnderline];
             FrmOptions.edtChrDesc.Font.Style := FrmOptions.edtChrDesc.Font.Style + [fsUnderline];
        end
     else
         begin
              FrmOptions.edtChrName.Font.Style := FrmOptions.edtChrName.Font.Style - [fsUnderline];
              FrmOptions.edtChrDesc.Font.Style := FrmOptions.edtChrDesc.Font.Style - [fsUnderline];
         end;
     frmChat.FontDialog1.font := FrmOptions.edtChrName.Font;
     frmChat.lblPlayerName.Caption := FrmOptions.EdtChrName.Text;
     frmChat.lblPlayerName.font.color := FrmOptions.EdtChrName.font.color;
     frmChat.lblPlayerDesc.Caption := FrmOptions.edtChrDesc.text;
     frmChat.lblPlayerDesc.font.color := FrmOptions.edtChrDesc.font.color;
     SaveCharacterSettings1.enabled := true;

     if Paramstr(1) <> '/GM' then
     SpeedButton2.enabled := true;
     SaveGameFiles1.enabled := true;
end;

procedure TMainForm.LoadNPCSetting;
var
iLoop: integer;
begin

     if frmchat.tcCharacterList.Tabs.count = 0 then
        begin
             FrmOptions.edtChrName.text := CharSettings.ReadString('GM', 'Name', 'GM');
             FrmOptions.edtChrDesc.text := CharSettings.ReadString('GM', 'ShortDesc', 'The Game Master');
             FrmOptions.edtChrName.Font.color := StringToColor(CharSettings.ReadString('GM', 'Color', 'clRed'));
             FrmOptions.edtChrDesc.Font.color := StringToColor(CharSettings.ReadString('GM', 'Color', 'clRed'));
             FrmOptions.edtChrName.Font.size :=  CharSettings.ReadInteger('GM', 'Size', 8);
             FrmOptions.edtChrDesc.Font.size :=  CharSettings.ReadInteger('GM', 'Size', 8);
             frmchat.tcCharacterList.Tabs.Add(FrmOptions.edtChrName.text);
        end;


     if CharSettings.ReadBool('GM', 'Bold',False) then
        begin
             FrmOptions.btnFontBold.down := true;
             FrmOptions.edtChrName.Font.Style := FrmOptions.edtChrName.Font.Style + [fsBold];
             FrmOptions.edtChrDesc.Font.Style := FrmOptions.edtChrDesc.Font.Style + [fsBold];
        end
     else
         begin
              FrmOptions.edtChrName.Font.Style := FrmOptions.edtChrName.Font.Style - [fsBold];
              FrmOptions.edtChrDesc.Font.Style := FrmOptions.edtChrDesc.Font.Style - [fsBold];
         end;

     if CharSettings.ReadBool('GM', 'Italic',False) then
        begin
             FrmOptions.btnFontItalic.down := true;
             FrmOptions.edtChrName.Font.Style := FrmOptions.edtChrName.Font.Style + [fsItalic];
             FrmOptions.edtChrDesc.Font.Style := FrmOptions.edtChrDesc.Font.Style + [fsItalic];
        end
     else
         begin
              FrmOptions.edtChrName.Font.Style := FrmOptions.edtChrName.Font.Style - [fsItalic];
              FrmOptions.edtChrDesc.Font.Style := FrmOptions.edtChrDesc.Font.Style - [fsItalic];
         end;

     if CharSettings.ReadBool('GM', 'Underline',False) then
        begin
             FrmOptions.btnFontUnderLine.down := true;
             FrmOptions.edtChrName.Font.Style := FrmOptions.edtChrName.Font.Style + [fsUnderline];
             FrmOptions.edtChrDesc.Font.Style := FrmOptions.edtChrDesc.Font.Style + [fsUnderline];
        end
     else
         begin
              FrmOptions.edtChrName.Font.Style := FrmOptions.edtChrName.Font.Style - [fsUnderline];
              FrmOptions.edtChrDesc.Font.Style := FrmOptions.edtChrDesc.Font.Style - [fsUnderline];
         end;

     frmChat.FontDialog1.font := FrmOptions.edtChrName.Font;
     frmChat.lblPlayerName.Caption := FrmOptions.EdtChrName.Text;
     frmChat.lblPlayerName.font.color := FrmOptions.EdtChrName.font.color;
     frmChat.lblPlayerDesc.Caption := FrmOptions.edtChrDesc.text;
     frmChat.lblPlayerDesc.font.color := FrmOptions.edtChrDesc.font.color;
     SaveCharacterSettings1.enabled := true;
     if Paramstr(1) <> '/GM' then
     SpeedButton2.enabled := true;
     SaveGameFiles1.enabled := true;

     frmChat.GroupBox1.visible := true;
     frmChat.btnQuickView.visible := true;
     frmChat.btnLongSDesc.visible := true;
     frmChat.FontDialog1.font := FrmOptions.edtChrName.Font;
     frmChat.lblPlayerName.Caption := FrmOptions.EdtChrName.Text;
     frmChat.lblPlayerName.font.color := FrmOptions.EdtChrName.font.color;
     frmChat.lblPlayerDesc.Caption := FrmOptions.edtChrDesc.text;
     frmChat.lblPlayerDesc.font.color := FrmOptions.edtChrDesc.font.color;

     for iLoop := 1 to CharSettings.ReadInteger('NPC', 'count', 0) do
         begin
               frmchat.tcCharacterList.Tabs.Add(CharSettings.ReadString('NPC'+IntToStr(iLoop), 'Name',''));
         end;


end;


procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
iniOptions: TBigIniFile;
i : integer;
begin
     iniOptions := TBigIniFile.Create(path+'vrtable.ini');
     iniOptions.WriteBool('Options', 'Message', FrmPref.cbMessage.checked);
     iniOptions.WriteBool('Options', 'Startup', FrmPref.cbStartup.checked);
     iniOptions.WriteBool('Options', 'Connect', FrmPref.cbConnect.checked);
     iniOptions.WriteBool('Options', 'Dice',  FrmPref.cbDice.checked);
     iniOptions.WriteBool('Options', 'Lock', FrmPref.cbLock.checked);
     iniOptions.WriteBool('Options', 'UnLock', FrmPref.cbUnlock.checked);
     iniOptions.WriteBool('Options', 'Kick', FrmPref.cbkick.checked);
     iniOptions.WriteBool('Options', 'Music', FrmPref.cbMusic.checked);
     iniOptions.WriteBool('Options', 'Disconnect', FrmPref.cbDisconnect.checked);

     iniOptions.WriteBool('Messages', 'Lock', FrmPref.cbMLock.checked);
     iniOptions.WriteBool('Messages', 'UnLock', FrmPref.cbMUnlock.checked);
     iniOptions.WriteBool('Messages', 'Kick', FrmPref.cbMkick.checked);
     iniOptions.WriteBool('Messages', 'Blind', FrmPref.cbMblind.checked);
     iniOptions.WriteBool('Messages', 'Deaf', FrmPref.cbMdeaf.checked);
     iniOptions.WriteBool('Messages', 'Mute', FrmPref.cbMmute.checked);
     iniOptions.WriteBool('Messages', 'Group', FrmPref.cbMGroup.checked);

     for i := 0 to frmPref.mmoSearch.Lines.count -1 do
         begin
              iniOptions.WriteString('Search Path','Path'+ IntToStr(i),frmPref.mmoSearch.Lines.Strings[i]);
         end;
     iniOptions.WriteInteger('Search Path','Count', frmPref.mmoSearch.Lines.count);
     iniOptions.Free;
     iniOptions := nil;


     frmSound.CloseMidiFile;
     frmSound.StopMP3;
     if MyDllHandle <> 0 then
        FreeLibrary(MyDllHandle);

     frmChat.Close;
     frmMacro.close;
     frmPlayerList.close;
     frmImgSnd.close;
     frmPlugin.close;
     frmOptions.close;
     frmPref.close;
     frmSysMsg.close;
//     frmChat.Release;
//     frmMacro.Release;
//     frmPlayerList.Release;
//     frmImgSnd.Release;
//     frmPlugin.Release;
//     frmOptions.Release;



     frmPlayerList.isInActive;
     lstMsgsRcvd.free;
     lstMsgsRcvd := nil;
     CharSettings.free;
     CharSettings := nil;
     GameSettings.free;
     GameSettings := nil;

     try
//        if DPConnected then
        DXPlay1.Close;
     except
           on E: Exception do
           begin
//                Application.HandleException(E);
               //      Application.Terminate;
           end;
     end;

     if regReadString(HKEY_CURRENT_USER, 'Control Panel\Cursors\Arrow') = '' then
        SetSystemCursor(Screen.Cursors[0], OCR_NORMAL)
     else
        SetSystemCursor(LoadCursorFromFile(PChar(regReadString(HKEY_CURRENT_USER, 'Control Panel\Cursors\Arrow'))), OCR_NORMAL);

//     Release;
//     Application.terminate;
end;

procedure TMainForm.TranslateMusic(prvMsgRcvdFrmRemotePlayer: String);
var
MusicFile: string;
begin
    if MusicBackground then
    Try
       musicFile := vreSearchPath(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1));

      if MusicFile = 'FNF' then exit;

      if LowerCase(StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1),'.',1)) = 's3m' then
         FrmSound.PlayMusic(MusicFile,True);// s3m Music

      if LowerCase(StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1),'.',1)) = 'xm' then
         FrmSound.PlayMusic(MusicFile,True);// xm Music

      if LowerCase(StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1),'.',1)) = 'mp3' then
         FrmSound.PlayMp3(MusicFile,True,true);// MP3 Music

      if LowerCase(StrTokenAt(StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1),'.',1)) = 'mid' then
         FrmSound.PlayMidi(MusicFile,True);// Midi Music


    except
          on E: Exception do
             begin
//                  Application.HandleException(E);
//                  Application.Terminate;
                  FrmSound.MusicRepeat := false;
             end;

    end;
end;

procedure TMainForm.TranslateImage(prvMsgRcvdFrmRemotePlayer: String);
var
viewer : TFrmImageView;
Image: string;
begin
     image := StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|', 1);
     if vreSearchPath(image)='FNF' then
        exit;

     viewer := TFrmImageView.Create(self);

     try
        viewer.Setup(vreSearchPath(image), clBlack);

        if frmImgSnd.lbImage.Items.IndexOf(image) = -1 then
           frmImgSnd.lbImage.Items.Add(image);
     finally
        viewer := Nil;
     end

end;

procedure TMainForm.TranslateSound(prvMsgRcvdFrmRemotePlayer: String);
var
sound: string;
begin

     sound := StrTokenAt(prvMsgRcvdFrmRemotePlayer, '|',1);

     try
        if vreSearchPath(Sound) = 'FNF' then exit;

        if frmImgSnd.lbSFX.Items.IndexOf(sound) <> -1 then
           frmImgSnd.lbSFX.Items.Add(Sound);

        //sound
        if LowerCase(StrTokenAt(Sound,'.',1)) = 'wav' then
           frmSound.PlayWave(vreSearchPath(Sound));
        if LowerCase(StrTokenAt(Sound,'.',1)) = 'mp3' then
           FrmSound.PlayMp3(vreSearchPath(Sound),false,false);// MP3 Music
     except;

     end;

end;


procedure TMainForm.SoundPictureFiles1Click(Sender: TObject);
begin
     if SoundPictureFiles1.checked then
        begin
             frmImgSnd.Close;
             SoundPictureFiles1.checked := false;
        end
     else
         begin
              frmImgSnd.show;
              SoundPictureFiles1.checked := true;
         end;
end;

procedure TMainForm.ClearChatWindow1Click(Sender: TObject);
begin
          FrmChat.ChatLog.Clear;
          FrmChat.MainChat.Clear;
end;

procedure TMainForm.Preferences1Click(Sender: TObject);
begin
frmPref.show;
end;

procedure TMainForm.SystemMessages1Click(Sender: TObject);
begin
     if SystemMessages1.checked then
        begin
             frmSysMsg.close;
             SystemMessages1.checked := false;
        end
     else
         begin
              frmSysMsg.show;
              SystemMessages1.checked := true;
         end;
end;

procedure TMainForm.Volume1Click(Sender: TObject);
begin
   if assigned(ShowMyVolume) then
      ShowMyVolume;

{     if Volume1.checked then
        begin
             frmVolume.close;
             Volume1.checked := false;
        end
     else
         begin
             frmVolume.Show;
              Volume1.checked := true;
         end;

 }
end;
//move this to the DLL
function TMainForm.vreSearchPath(FileName: String): String;
var
i : integer;
begin
     Result := 'FNF';
     try
     for i := 0 to frmPref.mmoSearch.Lines.count -1 do
         if FileExists(frmPref.mmoSearch.Lines.Strings[i] + '\'+ FileName) then
            Result := frmPref.mmoSearch.Lines.Strings[i] + '\'+ FileName;

     if result = 'FNF' then
        begin
             MessageDlg(FileName+ ' cannot be found please provide the correct location', mtInformation,[mbOk], 0);
             frmPref.PageControl1.ActivePage:= frmPref.TabSheet3;
             if frmPref.showmodal = mrOk then
                for i := 0 to frmPref.mmoSearch.Lines.count -1 do
                    if FileExists(frmPref.mmoSearch.Lines.Strings[i] + '\'+ FileName) then
                       Result := frmPref.mmoSearch.Lines.Strings[i] + '\'+ FileName;
          end;
     except
     end;
end;




procedure TMainForm.Notes1Click(Sender: TObject);
begin

frmNotes.Show

end;

procedure TMainForm.About1Click(Sender: TObject);
var
MyAbout: TfrmAbout;
begin
         MyAbout := TfrmAbout.Create(Self);
         if MyAbout.ShowModal = mrOk then
         begin
              MyAbout.Free;
              MyAbout := nil;
         end;

end;



procedure TMainForm.NewCharacter1Click(Sender: TObject);
begin
     frmCharacter.Setup(false,true,false,VRLocalPlayer);
end;

procedure TMainForm.EditCharacterData1Click(Sender: TObject);
begin
    frmCharacter.Setup(false,true,True,VRLocalPlayer);
end;

initialization
MyDllHandle :=0;
path := ExtractFilePath(Application.exename);
sndDone:= False;
Group1IsActive:= false;
Group2IsActive:= false;
Group3IsActive:= false;
Group4IsActive:= false;
DPConnected:= false;
end.
