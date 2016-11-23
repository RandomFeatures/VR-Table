unit DLLMain;

interface

uses  forms, Windows, SysUtils, DXPlay, DirectX;

const
  DXCHAT_MESSAGE = 0;

type
  TDXChatMessage = record
    dwType: DWORD;  {  dwType is absolutely necessary.  }
    Len: Integer;
    C: array[0..0] of Char;
  end;

procedure SndMsgToAllPlayers(TheMessage: PChar); export; stdcall;
procedure SndMsgToSinglePlayer(prvMsgToRemotePlayer: PChar; RemotePlayerID: Integer); export; stdcall;
procedure InitDLL(incDPlay: TDXPlay; AppHand: THandle); export; stdcall;

function PlayerCount: Integer; export; stdcall;
function LocalPlayerName: PChar; export; stdcall;
function LocalPlayerisHost: Boolean;export; stdcall;


var
PlrCount: Integer;
PlrName: string;
PlrisHost: Boolean;
MyDPlay : TDXPlay;

implementation

procedure InitDLL(incDPlay: TDXPlay; AppHand: THandle);
begin
     MyDPlay := incDPlay;
     Application.Handle := AppHand;
end;

procedure SndMsgToAllPlayers(TheMessage: PChar);
var
  Msg: ^TDXChatMessage;
  MsgSize: Integer;
  TmpMsg: String;
begin
  TmpMsg := StrPas(TheMessage);
  if not Assigned(MyDPlay) then exit;
  MsgSize := SizeOf(TDXChatMessage)+Length(TmpMsg);
  GetMem(Msg, MsgSize);
  try
    Msg.dwType := DXCHAT_MESSAGE;

    Msg.Len := Length(TmpMsg);

    StrLCopy(@Msg^.c, PChar(TheMessage), Length(TmpMsg));

    {  The message is sent all.  }
    MyDPlay.SendMessage(DPID_ALLPLAYERS, Msg, MsgSize);

    {  The message is sent also to me.  }
    MyDPlay.SendMessage(MyDPlay.LocalPlayer.ID, Msg, MsgSize);

  finally
    FreeMem(Msg);
  end;
end;

procedure SndMsgToSinglePlayer(prvMsgToRemotePlayer: PChar; RemotePlayerID: Integer);
var
  Msg: ^TDXChatMessage;
  MsgSize: Integer;
  tmpMsg: String;
begin
   TmpMsg := StrPas(prvMsgToRemotePlayer);
  if not Assigned(MyDPlay) then exit;
  MsgSize := SizeOf(TDXChatMessage)+Length(TmpMsg);
  GetMem(Msg, MsgSize);
  try
    Msg.dwType := DXCHAT_MESSAGE;

    Msg.Len := Length(TmpMsg);

    StrLCopy(@Msg^.c, PChar(TmpMsg), Length(TmpMsg));
    //Send the message to the specific player
    MyDPlay.SendMessage(RemotePlayerID, Msg, MsgSize);

  finally
    FreeMem(Msg);
  end;
end;

function PlayerCount: Integer;
begin
     if Assigned(MyDPlay) then
        result := MyDPlay.Players.Count
     else result := 0;
end;

function LocalPlayerName: PChar;
begin
     if Assigned(MyDPlay) then
        result := PChar(MyDPlay.LocalPlayer.Name)
     else result := PChar('None');

end;

function LocalPlayerisHost: Boolean;
begin
     if Assigned(MyDPlay) then
       result := MyDPlay.ishost
    else result := false;

end;

end.
