unit main;

interface

uses forms, windows, Dice, cfg, plgcommon, Classes, SysUtils,DXPlay, DirectX, IniFiles;

const
  DXCHAT_MESSAGE = 0;


type
  TDXChatMessage = record
    dwType: DWORD;  {  dwType is absolutely necessary.  }
    Len: Integer;
    C: array[0..0] of Char;

end;

    function ReceivedMsg(RcvdMsg: String):Boolean; export; stdcall;
    procedure DescribePlugin(var version,Name,ID,Desc,Author,CopyRight: string); export; stdcall;
    procedure InitPlugin(incDPlay: TDXPlay; AppHand: THandle); export; stdcall;
    procedure StatusChange(NewStatus: string); export; stdcall;
    procedure LoadMenu(var ParentList: TStrings); export; stdcall;
    procedure ShowDiceM; export; stdcall;
    procedure Configure; export; stdcall;
    function strTokenAt(const S:String; Seperator: Char; At: Integer): String;
    procedure SndMsgToAllPlayers(TheMessage: PChar);
    procedure SndMsgOnePlayer(TheMessage: PChar; ID: integer);

var
  CurrntStatus : String;
  MyPluginfrm: TfrmDice;
  MyCfgFrm: TFrmCfg;
  DxPlayObj : TDXPlay;
  bPrivateRolls: Boolean;
implementation

procedure DescribePlugin(var version,Name,ID,Desc,Author,CopyRight: string);
begin
    Name := 'Dice Manager Plugin v1.0';
    ID := 'vrtDice1.0';
    Author := 'Allen Halsted';
    Desc := 'A generic dice rolling program.';
    Version := '1.0';
    CopyRight := '2000 Allen Halsted'
end;

function ReceivedMsg(RcvdMsg: String):Boolean;
begin
     Result := false;

     if StrTokenAt(RcvdMsg, '|', 0) <> 'vrtDice1.0' then
        Result := true
     else
        begin
             if MyCfgfrm.cbChat.Checked then
                SndMsgOnePlayer(Pchar('plgmsg|<b>'+StrTokenAt(RcvdMsg, '|', 1) + '</b> ' +StrTokenAt(RcvdMsg, '|', 2)),DxPlayObj.LocalPlayer.ID);

             if  (DxPlayObj.IsHost) or (DxPlayObj.LocalPlayer.Name = StrTokenAt(RcvdMsg, '|', 1)) then
             begin
                 MyPluginfrm.DiceViewer.text := MyPluginfrm.DiceViewer.text + '<b>'+StrTokenAt(RcvdMsg, '|', 1) + '</b> ' +StrTokenAt(RcvdMsg, '|', 2)+'<br>';
             end;
        end;
end;

procedure InitPlugin(incDPlay:TDXPlay; AppHand: THandle);
var
   ini: TiniFile;
begin

    DxPlayObj := incDPlay;




    Application.Handle := AppHand;

    MyPluginfrm := TfrmDice.Create(Application);

    MyPluginfrm.Left := 0;
    //MyPluginfrm.Height := 163;
    MyPluginfrm.Top := Screen.height - MyPluginfrm.height -28;
    //MyPluginfrm.width := Screen.width;
    //MyPluginfrm.Show;

    MyCfgfrm := Tfrmcfg.Create(Application);


    if not Assigned(DxPlayObj) then exit;
    if DxPlayObj.Opened then
    if DxPlayObj.IsHost then
      MyCfgfrm.cbHide.Enabled := true;

    ini := TiniFile.create(ExtractFilePath(application.exename)+strTokenAt(ExtractFileName(application.exename),'.',0) + '.ini');

    if MyCfgfrm.cbHide.enabled then
      MyCfgfrm.cbHide.checked := ini.ReadBool('vrtDice','Hide',false);
    bPrivateRolls := ini.ReadBool('vrtDice','Hide',false);
    MyCfgfrm.cbChat.Checked := ini.Readbool('vrtDice','chat',false);

    MyCfgfrm.rgDisp.ItemIndex := ini.ReadInteger('vrtDice','display',1);
    ini.Free;


end;

procedure StatusChange(NewStatus: String);
begin
     CurrntStatus := NewStatus;
end;

procedure LoadMenu(var ParentList: TStrings);
begin
     ParentList.Add('Dice Manager,ShowDiceM,6')
end;

procedure ShowDiceM;
begin
     if Assigned(MyPluginfrm) then
     MyPluginfrm.Show;
end;

procedure Configure;
begin
     if Assigned(Mycfgfrm) then
        mycfgfrm.show;


end;




function strTokenAt(const S:String; Seperator: Char; At: Integer): String;
var
  j,i: Integer;
begin
  Result:='';
  j := 1;
  i := 0;
  while (i<=At ) and (j<=Length(S)) do
  begin
    if S[j]=Seperator then
       Inc(i)
    else if i = At then
       Result:=Result+S[j];
    Inc(j);
  end;
end;

procedure SndMsgToAllPlayers(TheMessage: PChar);
var
  Msg: ^TDXChatMessage;
  MsgSize: Integer;
  TmpMsg: String;
begin
  TmpMsg := StrPas(TheMessage);
  if not Assigned(DxPlayObj) then exit;
  if Not(DxPlayObj.Opened) then exit;
  MsgSize := SizeOf(TDXChatMessage)+Length(TmpMsg);
  GetMem(Msg, MsgSize);
  try
    Msg.dwType := DXCHAT_MESSAGE;

    Msg.Len := Length(TmpMsg);

    StrLCopy(@Msg^.c, PChar(TheMessage), Length(TmpMsg));

    {  The message is sent all.  }
    DxPlayObj.SendMessage(DPID_ALLPLAYERS, Msg, MsgSize);

    {  The message is sent also to me.  }
    DxPlayObj.SendMessage(DxPlayObj.LocalPlayer.ID, Msg, MsgSize);

  finally
    FreeMem(Msg);
  end;
end;

procedure SndMsgOnePlayer(TheMessage: PChar; ID: integer);
var
  Msg: ^TDXChatMessage;
  MsgSize: Integer;
  TmpMsg: String;
begin
  TmpMsg := StrPas(TheMessage);
  if not Assigned(DxPlayObj) then exit;
  if Not(DxPlayObj.Opened) then exit;
  MsgSize := SizeOf(TDXChatMessage)+Length(TmpMsg);
  GetMem(Msg, MsgSize);
  try
    Msg.dwType := DXCHAT_MESSAGE;

    Msg.Len := Length(TmpMsg);

    StrLCopy(@Msg^.c, PChar(TheMessage), Length(TmpMsg));

    {  The message is sent also to me.  }
    DxPlayObj.SendMessage(ID, Msg, MsgSize);

  finally
    FreeMem(Msg);
  end;
end;



initialization

finalization
MyPluginfrm.free;
MyPluginfrm := nil;
Mycfgfrm.free;
Mycfgfrm := nil;

end.
