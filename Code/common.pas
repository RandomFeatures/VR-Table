unit common;

interface

uses  windows, DXPlay, Classes;

const
    cPLUGIN_DESCRIBE    = 'DescribePlugin';
    cPLUGIN_INIT        = 'InitPlugin';
    cPLUGIN_Config      = 'Configure';
    cPLUGIN_RCVDMSG     = 'ReceivedMsg';
    cPLUGIN_STSCHNG     = 'StatusChange';
    cPLUGIN_LOADMNU     = 'LoadMenu';
    cDLL_INIT           = 'InitDLL';
    cDLL_SndAll         = 'SndMsgToAllPlayers';
    cDLL_SndOne         = 'SndMsgToSinglePlayer';
    cDLL_isHost         = 'LocalPlayerisHost';
    cDLL_PlyrName       = 'LocalPlayerName';
    cDLL_ShowSysInfo    = 'ShowSysInfo';
    cDLL_ShowVolume     = 'ShowVolume';

type
    TPluginDescribe     = procedure (var version,Name,ID,Desc,Author,CopyRight: string); stdcall;
    TPluginInit         = procedure (incDPlay: TDXPlay; AppHand: THandle); stdcall;
    TPluginConfig       = procedure stdcall;
    TPluginRcvdMsg      = function (RcvdMsg: string):Boolean; stdCall;
    TPluginStsChng      = procedure (NewStatus: string); stdcall;
    TPluginLoadMnu      = procedure (var ParentList: TStrings); stdcall;
    TDLLInit            = procedure (incDPlay: TDXPlay; AppHand: THandle); stdcall;
    TDLLSendAll         = procedure (TheMessage: PChar);stdcall;
    TDLLSendOne         = procedure (prvMsgToRemotePlayer: PChar; RemotePlayerID: Integer);stdcall;
    TDLLisHost          = function  :Boolean; stdcall;
    TDLLPlyrName        = function  :PChar; stdcall;
    TDLLShowSysInfo     = procedure (group:integer)export; stdcall;
    TDllShowVolume      = procedure export; stdcall;

implementation

end.
