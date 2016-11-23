library VRTable;

uses
  SysUtils,
  Classes,
  dllmain in 'dllmain.pas',
  main in 'main.pas',
  SysInfo in 'SysInfo.pas' {frmSysInfo},
  Volume in 'Volume.pas' {frmVolume};

exports
    SndMsgToAllPlayers, InitDLL, SndMsgToSinglePlayer, PlayerCount,
    LocalPlayerName, LocalPlayerisHost, ShowSysInfo, ShowVolume;
begin
end.
