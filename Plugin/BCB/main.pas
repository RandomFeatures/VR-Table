unit main;

interface

uses forms, windows, Dice, plgcommon, Classes, SysUtils;


    function ReceivedMsg(RcvdMsg: String):Boolean; export; stdcall;
    procedure DescribePlugin(var Desc: string); export; stdcall;
    procedure InitPlugin(AppHand: THandle); export; stdcall;
    procedure StatusChange(NewStatus: string); export; stdcall;
    procedure LoadMenu(ParentList: TStrings); export; stdcall;
    procedure ShowDiceM; export; stdcall;
    function strTokenAt(const S:String; Seperator: Char; At: Integer): String;

var
  VREDLLHandle: integer;
  SndToAll: TDLLSendAll;
  PlyrHost: TDLLisHost;
  PlyrNamecll: TDLLPlyrName;
  PlrName : string;
  CurrntStatus : String;
  MyPluginfrm: TfrmDice;

implementation

procedure DescribePlugin(var Desc: string);
begin
    Desc := 'Dice Manager Plugin';
end;

function ReceivedMsg(RcvdMsg: String):Boolean;
begin
     Result := false;

     if StrTokenAt(RcvdMsg, '|', 0) <> 'Dice' then
        Result := true
     else
        begin
             //(PlyrHost) or
           //  PlrName := PlyrNamecll;
             if  (PlyrHost) or (PlrName = StrTokenAt(RcvdMsg, '|', 1)) then
                 MyPluginfrm.mmoRecord.lines.add(StrTokenAt(RcvdMsg, '|', 1) + ' ' +StrTokenAt(RcvdMsg, '|', 2));
        end;
end;

procedure InitPlugin(AppHand: THandle);
//var
//path: string;
begin
 //Path := ExtractFilePath(Application.exeName);
 if VREDLLHandle = 0 then
       begin

            VREDLLHandle := LoadLibrary(PChar('vrtable.dll'));
            if VREDLLHandle <> 0 then
               begin

                    SndToAll := GetProcAddress(VREDLLHandle, cDLL_SndAll);
                    // sndToAll('Type|Color|Size|Bold|Italic|Underline|Sender|Action|Color|Size|Bold|Italic|UnderLine|MessageText');
                    PlyrHost := GetProcAddress(VREDLLHandle, cDLL_isHost);

                    plyrNamecll := GetProcAddress(VREDLLHandle, cDLL_PlyrName);

               end;
       end;
Application.Handle := AppHand;
MyPluginfrm := TfrmDice.Create(Application);
MyPluginfrm.Left := 0;
MyPluginfrm.Height := 163;
MyPluginfrm.Top := Screen.height - MyPluginfrm.height -28;
MyPluginfrm.width := Screen.width;
//MyPluginfrm.Show;


end;

procedure StatusChange(NewStatus: String);
begin
     CurrntStatus := NewStatus;
end;

procedure LoadMenu(ParentList: TStrings);
begin
ParentList.Add('Dice Manager,ShowDiceM,4')

end;

procedure ShowDiceM;
begin
     if Assigned(MyPluginfrm) then
     MyPluginfrm.Show;
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


initialization
VREDLLHandle := 0;

finalization
FreeLibrary(VREDLLHandle);
MyPluginfrm.free;
MyPluginfrm := nil;

end.
