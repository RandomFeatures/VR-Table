unit Plgcommon;

interface

uses  windows, Classes;

const
    cDLL_SndAll         = 'SndMsgToAllPlayers';
    cDLL_SndOne         = 'SndMsgToSinglePlayer';
    cDLL_isHost         = 'LocalPlayerisHost';
    cDLL_PlyrName       = 'LocalPlayerName';

type
    TDLLSendAll         = procedure (TheMessage: PChar);stdcall;
    TDLLSendOne         = procedure (prvMsgToRemotePlayer: PChar; RemotePlayerID: Integer);stdcall;
    TDLLisHost          = function  :Boolean; stdcall;
    TDLLPlyrName        = function  :PChar; stdcall;
implementation

end.
