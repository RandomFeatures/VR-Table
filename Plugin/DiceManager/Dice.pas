unit Dice;

interface

uses
  Windows, SysUtils, Forms, Buttons, Classes,
  TFlatEditUnit, TFlatSpinEditUnit, inifiles,
  janMarkupViewer, StdCtrls,Controls, ExtCtrls;

type
  TfrmDice = class(TForm)
    btnPanel: TPanel;
    btnd12: TBitBtn;
    btnd20: TBitBtn;
    btnd100: TBitBtn;
    btnd4: TBitBtn;
    btnd6: TBitBtn;
    btnd8: TBitBtn;
    btnd10: TBitBtn;
    btnd3: TBitBtn;
    numDice: TFlatSpinEditInteger;
    bonus: TFlatSpinEditInteger;
    Label1: TLabel;
    Label2: TLabel;
    viewerPanel: TPanel;
    Panel3: TPanel;
    DiceViewer: TjanMarkupViewer;
    procedure btnd4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    DiceRolls: TStrings;
    procedure ShowHoraz;
    procedure ShowVert;

  end;

var
  frmDice: TfrmDice;

implementation
uses main;
{$R *.DFM}

procedure TfrmDice.btnd4Click(Sender: TObject);
var I :integer;
Roll :integer;
begin

     Roll := 0;
     for i := 1 to numDice.value do
     begin
          Roll := Roll + Random(TBitBtn(Sender).tag)+1;
     end;

    // Allen rolls <font  color="#FF0000">(1d6+0)</font> Result: <font  color="#FF0000">4 + 0 =</font><font  color="#0000FF"> 4</font>
     if not Assigned(DxPlayObj) then exit;
     if Not(DxPlayObj.Opened) then
     begin
          if  viewerPanel.left = 0 then
              MyPluginfrm.DiceViewer.text := MyPluginfrm.DiceViewer.text + 'You rolled <font  color="#FF0000">(' + IntToStr(numDice.value)+ TBitBtn(Sender).caption+'+'+IntToStr(Bonus.value)+')</font><br> -> <font  color="#FF00FF">'+IntToStr(Roll) + '+'+IntToStr(Bonus.Value)+'</font> = <font  color="#0000FF">' + IntToStr(Roll + bonus.value)+ '</font>'+'<br>'
          else
              MyPluginfrm.DiceViewer.text := MyPluginfrm.DiceViewer.text + 'You rolled <font  color="#FF0000">(' + IntToStr(numDice.value)+ TBitBtn(Sender).caption+'+'+IntToStr(Bonus.value)+')</font> -> <font  color="#FF00FF">'+IntToStr(Roll) + '+'+IntToStr(Bonus.Value)+'</font> = <font  color="#0000FF">' + IntToStr(Roll + bonus.value)+ '</font>'+'<br>';
          exit;
     end;

     if (DxPlayObj.IsHost) and (bPrivateRolls) then
     begin
          if  viewerPanel.left = 0 then
              MyPluginfrm.DiceViewer.text := MyPluginfrm.DiceViewer.text + 'Private roll <font  color="#FF0000">(' + IntToStr(numDice.value)+ TBitBtn(Sender).caption+'+'+IntToStr(Bonus.value)+')</font><br> -> <font  color="#FF00FF">'+IntToStr(Roll) + '+'+IntToStr(Bonus.Value)+'</font> = <font  color="#0000FF">' + IntToStr(Roll + bonus.value)+ '</font>'+'<br>'
          else
              MyPluginfrm.DiceViewer.text := MyPluginfrm.DiceViewer.text + 'Private roll <font  color="#FF0000">(' + IntToStr(numDice.value)+ TBitBtn(Sender).caption+'+'+IntToStr(Bonus.value)+')</font> -> <font  color="#FF00FF">'+IntToStr(Roll) + '+'+IntToStr(Bonus.Value)+'</font> = <font  color="#0000FF">' + IntToStr(Roll + bonus.value)+ '</font>'+'<br>';

          if MyCfgfrm.cbChat.Checked then
             SndMsgOnePlayer(Pchar('plgmsg|<b>'+'Private roll <font  color="#FF0000">(' + IntToStr(numDice.value)+ TBitBtn(Sender).caption+'+'+IntToStr(Bonus.value)+')</font> -> <font  color="#FF00FF">'+IntToStr(Roll) + '+'+IntToStr(Bonus.Value)+'</font> = <font  color="#0000FF">' + IntToStr(Roll + bonus.value)+ '</font>'),DxPlayObj.LocalPlayer.ID);

          exit;
     end;

     if  viewerPanel.left = 0 then
         SndMsgToAllPlayers(PChar('vrtDice1.0|'+DxPlayObj.LocalPlayer.Name+'|'+ 'rolls <font  color="#FF0000">(' + IntToStr(numDice.value)+ TBitBtn(Sender).caption+'+'+IntToStr(Bonus.value)+')</font><br> -> <font  color="#FF00FF">'+IntToStr(Roll) + '+'+IntToStr(Bonus.Value)+'</font> = <font  color="#0000FF">' + IntToStr(Roll + bonus.value)+ '</font>'))
     else
         SndMsgToAllPlayers(PChar('vrtDice1.0|'+DxPlayObj.LocalPlayer.Name+'|'+ 'rolls <font  color="#FF0000">(' + IntToStr(numDice.value)+ TBitBtn(Sender).caption+'+'+IntToStr(Bonus.value)+')</font> -> <font  color="#FF00FF">'+IntToStr(Roll) + '+'+IntToStr(Bonus.Value)+'</font> = <font  color="#0000FF">' + IntToStr(Roll + bonus.value)+ '</font>'));
end;

procedure TfrmDice.FormShow(Sender: TObject);
var
   ini: TiniFile;
begin

   Randomize;
   ini := TiniFile.create(ExtractFilePath(application.exename)+strTokenAt(ExtractFileName(application.exename),'.',0) + '.ini');

   if ini.ReadInteger('vrtDice','display',1) = 1 then
      showHoraz
   else
      ShowVert;
   ini.Free;


end;


procedure TfrmDice.FormCreate(Sender: TObject);
begin
DiceRolls := TStringList.create;

end;

procedure TfrmDice.FormDestroy(Sender: TObject);
begin
DiceRolls.Clear;
DiceRolls.Free;
DiceRolls := Nil;
end;


procedure TfrmDice.ShowVert;
begin
  Height :=  235;
  width := 169;

  btnPanel.Left := 12;
  btnPanel.Top := 102;
  btnPanel.Height := 105;
  btnPanel.Width :=  137;
  viewerPanel.Left := 0;
  viewerPanel.top := 0;
  viewerPanel.Width := 161;
  viewerPanel.height := 105;


end;

procedure TfrmDice.ShowHoraz;
begin
  Height :=  132;
  width := 436;

  btnPanel.Left := 0;
  btnPanel.Top := 0;
  btnPanel.Height := 105;
  btnPanel.Width :=  137;

  viewerPanel.Left := 144;
  viewerPanel.top := 0;
  viewerPanel.Width := 284;
  viewerPanel.height := 105;


end;


initialization
end.
