unit cfg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, inifiles;

type
  TfrmCfg = class(TForm)
    btnClose: TButton;
    Label1: TLabel;
    rgDisp: TRadioGroup;
    cbHide: TCheckBox;
    cbChat: TCheckBox;
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCfg: TfrmCfg;

implementation
uses main,dice;
{$R *.DFM}

procedure TfrmCfg.btnCloseClick(Sender: TObject);
begin
   if rgDisp.ItemIndex = 1 then
      MyPluginfrm.showHoraz
   else
      MyPluginfrm.ShowVert;

     close;

end;

procedure TfrmCfg.FormClose(Sender: TObject; var Action: TCloseAction);
var
   ini: TiniFile;
begin


   ini := TiniFile.create(ExtractFilePath(application.exename)+strTokenAt(ExtractFileName(application.exename),'.',0) + '.ini');

   if DxPlayObj.IsHost then
   begin
      ini.writeBool('vrtDice','Hide',cbHide.checked);
      bPrivateRolls := cbHide.checked;
   end;

   ini.WriteInteger('vrtDice','display',rgDisp.ItemIndex);
   ini.Writebool('vrtDice','chat',cbChat.checked);

   ini.Free;
end;

procedure TfrmCfg.FormShow(Sender: TObject);
var
   ini: TiniFile;
begin
    if not Assigned(DxPlayObj) then exit;
    if DxPlayObj.Opened then
    if DxPlayObj.IsHost then
      cbHide.Enabled := true;
    
    ini := TiniFile.create(ExtractFilePath(application.exename)+strTokenAt(ExtractFileName(application.exename),'.',0) + '.ini');

    if cbHide.enabled then
      cbHide.checked := ini.ReadBool('vrtDice','Hide',false);
    bPrivateRolls := cbHide.checked;
    rgDisp.ItemIndex := ini.ReadInteger('vrtDice','display',1);
    cbChat.Checked := ini.Readbool('vrtDice','chat',false);
    ini.Free;

end;

end.
