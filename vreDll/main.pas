unit main;

interface

uses forms, windows, Classes, SysUtils, SysInfo, Volume;


    procedure ShowSysInfo(Group: integer); export; stdcall;
    procedure ShowVolume; export; stdcall;
var
  MySysInfo: TfrmSysInfo;
  Myvolume: TfrmVolume;
  path: string;
implementation



procedure ShowSysInfo(Group: Integer);
begin
     if Not(Assigned(MySysInfo)) then
     MySysInfo := TfrmSysInfo.Create(Application);
     MySysInfo.Label3.caption := 'Group '+IntToStr(Group);
     MySysInfo.Show;
end;
procedure ShowVolume;
begin
     if Not(Assigned(MyVolume)) then
     MyVolume := TfrmVolume.Create(Application);
     MyVolume.Show;
end;


initialization
 path := ExtractFilePath(Application.ExeName);

finalization
MyVolume.free;
MyVolume := nil;
MySysInfo.free;
MySysinfo := nil;
end.
