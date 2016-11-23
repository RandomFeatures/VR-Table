unit chat;

interface

uses
  Windows, Messages, SysUtils,  Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, ComCtrls, Wordcap, EllipsisLabel, VREMemo, BigIni,
  Classes, HTMLLite;

type
  TfrmChat = class(TForm)
    Panel4: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Bevel3: TBevel;
    btnFontColor: TSpeedButton;
    btnFontBold: TSpeedButton;
    btnFontItalic: TSpeedButton;
    btnfontUnderline: TSpeedButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Splitter1: TSplitter;
    fontcolor: TColorDialog;
    MSOfficeCaption1: TMSOfficeCaption;
    EdtMsgBody: TVREMemo;
    FontDialog1: TFontDialog;
    Panel8: TPanel;
    Panel9: TPanel;
    tcCharacterList: TTabControl;
    Panel5: TPanel;
    GroupBox1: TGroupBox;
    lblPlayerName: TEllipsisLabel;
    lblPlayerDesc: TEllipsisLabel;
    rbtnName: TRadioButton;
    rbtnDesc: TRadioButton;
    gbActionType: TGroupBox;
    rbTalk: TRadioButton;
    rbAction: TRadioButton;
    Panel6: TPanel;
    Panel7: TPanel;
    btnLongSDesc: TSpeedButton;
    btnQuickView: TSpeedButton;
    SbQStats: TStatusBar;
    pnlgroup: TPanel;
    cbGroup1: TCheckBox;
    cbGroup2: TCheckBox;
    cbGroup3: TCheckBox;
    cbGroup4: TCheckBox;
    btnSend: TButton;
    Label1: TLabel;
    cbFontSize: TComboBox;
    Panel10: TPanel;
    MainChat: ThtmlLite;
    procedure btnfontUnderlineClick(Sender: TObject);
    procedure btnFontItalicClick(Sender: TObject);
    procedure btnFontBoldClick(Sender: TObject);
    procedure btnFontColorClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure tcCharacterListChange(Sender: TObject);
    procedure btnLongSDescClick(Sender: TObject);
    procedure btnQuickViewClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure rbActionClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
     ChatLog: TStrings;
     procedure Setup;

    { Public declarations }
  end;

var
  frmChat: TfrmChat;
  NPCSettings: TBigIniFile;
  
implementation

uses Options, Main, plyLst, macros;

{$R *.DFM}



procedure TfrmChat.btnfontUnderlineClick(Sender: TObject);
begin
     if btnfontUnderline.down then
        EdtMsgBody.Font.Style := EdtMsgBody.Font.Style + [fsUnderline]
     else
        EdtMsgBody.Font.Style := EdtMsgBody.Font.Style - [fsUnderline];

end;

procedure TfrmChat.btnFontItalicClick(Sender: TObject);
begin
     if btnfontItalic.down then
        EdtMsgBody.Font.Style := EdtMsgBody.Font.Style + [fsItalic]
     else
        EdtMsgBody.Font.Style := EdtMsgBody.Font.Style - [fsItalic];

end;

procedure TfrmChat.btnFontBoldClick(Sender: TObject);
begin
     if btnfontBold.down then
        EdtMsgBody.Font.Style := EdtMsgBody.Font.Style + [fsBold]
     else
        EdtMsgBody.Font.Style := EdtMsgBody.Font.Style - [fsBold];

end;

procedure TfrmChat.btnFontColorClick(Sender: TObject);
begin
     if fontColor.execute then
        EdtMsgBody.Font.color := fontcolor.color;


end;

procedure TfrmChat.FormShow(Sender: TObject);
begin

   cbFontSize.ItemIndex := 8;
   edtMsgBody.setfocus;
   if frmOptions.EdtChrName.Text = '' then
 //  frmOptions.EdtChrName.Text := Mainform.DXPlay1.LocalPlayer.Name;
   lblPlayerName.Caption := FrmOptions.EdtChrName.Text;
   lblPlayerDesc.Caption := FrmOptions.EdtChrDesc.Text;

end;

procedure TfrmChat.btnSendClick(Sender: TObject);
var
  Dsc: string;
  BuildMsg: string;
  chrfntBold :string;
  chrfntItalic :string;
  chrfntUnder :string;
  chrfntSize :string;
  MsgfntBold :string;
  MsgfntItalic :string;
  MsgfntUnder :string;
  MsgfntSize :string;
  ActionType: string;
  chGroup1: string;
  chGroup2: string;
  chGroup3: string;
  chGroup4: string;
  chrName: string;
  chrMsg: string;
  imgFile: string;

begin

  if (CntMode = 'NotConnect') or (CntMode = 'Locked') or (btnSend.caption='Locked...')then exit;

  imgfile := '';

  if MainForm.VrLocalPlayer.Image_Name <> '' then
     imgfile := '<img src="..\characterimages\'+MainForm.VrLocalPlayer.Image_Name+'" width="'+MainForm.VrLocalPlayer.Image_Width+'" height="'+MainForm.VrLocalPlayer.Image_Height+'">';

  MsgfntBold := 'False';
  MsgfntItalic := 'False';
  MsgfntUnder := 'False';
  MsgfntSize := IntToStr(EdtMsgBody.Font.Size);

  chrfntBold := 'False';
  chrfntItalic := 'False';
  chrfntUnder := 'False';
  chrfntSize := IntToStr(frmOptions.edtChrName.Font.Size);
  chGroup1 := 'False';
  chGroup2 := 'False';
  chGroup3 := 'False';
  chGroup4 := 'False';

  if frmChat.rbTalk.checked then ActionType := 'Talk';
  if frmChat.rbAction.checked then ActionType := 'Action';

  if trim(frmChat.EdtMsgBody.Text) = '' then EdtMsgBody.Text := 'Nothing.';
  if (rbtnName.Checked) and (lblPlayerName.caption <> '') then
     Dsc:=lblPlayerName.caption
   else
      if (rbtnDesc.Checked) and (lblPlayerDesc.caption <> '') then
         Dsc:= lblPlayerDesc.caption
      else
          Dsc := MainForm.DXPlay1.LocalPlayer.Name;

  if fsBold in EdtMsgBody.font.style then MsgfntBold := 'True';
  if fsItalic in EdtMsgBody.font.style then MsgfntItalic := 'True';
  if fsUnderline in EdtMsgBody.font.style then MsgfntUnder := 'True';

  if fsBold in FontDialog1.font.style then ChrfntBold := 'True';
  if fsItalic in FontDialog1.font.style then chrfntItalic := 'True';
  if fsUnderline in FontDialog1.font.style then chrfntUnder := 'True';

  if MainForm.DXPlay1.IsHost then
     begin
          if cbGroup1.checked then chGroup1 := 'True';
          if cbGroup2.checked then chGroup2 := 'True';
          if cbGroup3.checked then chGroup3 := 'True';
          if cbGroup4.checked then chGroup4 := 'True';
     end
  else
      begin
          if MainForm.VRLocalPlayer.Group = 1 then chGroup1 := 'True';
          if MainForm.VRLocalPlayer.Group = 2 then chGroup2 := 'True';
          if MainForm.VRLocalPlayer.Group = 3 then chGroup3 := 'True';
          if MainForm.VRLocalPlayer.Group = 4 then chGroup4 := 'True';
      end;

  //ID and Group
  buildMsg  := 'Message'+':'+chGroup1 +':'+chGroup2 +':'+ chGroup3+':'+ chGroup4 +'|';

  //character Name
  ChrName := '<font face="MS Sans Serif" size="'+frmOptions.cbFontSize.Items[frmOptions.cbFontSize.ItemIndex]+'" color="'+IntToHex(GetRValue(ColorToRGB(FontDialog1.font.color)),2)+IntToHex(GetGValue(ColorToRGB(FontDialog1.font.color)),2)+IntToHex(GetBValue(ColorToRGB(FontDialog1.font.color)),2)+'">';
  if fsBold in FontDialog1.font.style then ChrName := ChrName + '<b>';
  if fsItalic in FontDialog1.font.style then ChrName := ChrName + '<i>';
  if fsUnderline in FontDialog1.font.style then ChrName := ChrName + '<u>';

  ChrName := ChrName + Dsc;

  if fsUnderline in FontDialog1.font.style then ChrName := ChrName + '</u>';
  if fsItalic in FontDialog1.font.style then ChrName := ChrName + '</i>';
  if fsBold in FontDialog1.font.style then ChrName := ChrName + '</b>';

  ChrName := ChrName+ '</font>';

  chrMsg := '<font face="MS Sans Serif" size="'+cbFontSize.Items[cbFontSize.ItemIndex]+'" color="#'+IntToHex(GetRValue(ColorToRGB(EdtMsgBody.font.color)),2)+IntToHex(GetGValue(ColorToRGB(EdtMsgBody.font.color)),2)+IntToHex(GetBValue(ColorToRGB(EdtMsgBody.font.color)),2)+'">';

  if fsBold in EdtMsgBody.font.style then chrMsg := chrMsg + '<b>';
  if fsItalic in EdtMsgBody.font.style then chrMsg := chrMsg + '<i>';
  if fsUnderline in EdtMsgBody.font.style then chrMsg := chrMsg + '<u>';

  chrMsg := chrMsg + Trim(EdtMsgBody.Text);

  if fsUnderline in EdtMsgBody.font.style then chrMsg := chrMsg + '</u>';
  if fsItalic in EdtMsgBody.font.style then chrMsg := chrMsg + '</i>';
  if fsBold in EdtMsgBody.font.style then chrMsg := chrMsg + '</b>';


  chrMsg := chrMsg+ '</font>';
//  showmessage(ChrName +'|'+chrMsg);
//  buildMsg  := 'Message'+':'+chGroup1 +':'+chGroup2 +':'+ chGroup3+':'+ chGroup4 +'|'+ ColorToString(fontDialog1.font.color)+'|'+chrfntSize+'|'+chrfntBold+'|'+chrfntItalic+'|'+chrfntUnder+'|'+Dsc+
//       '|'+ActionType+'|'+ColorToString(EdtMsgBody.font.color)+'|'+MsgfntSize+'|'+MsgfntBold+'|'+MsgfntItalic+'|'+MsgfntUnder+'|'+Trim(EdtMsgBody.Text);

  if Assigned(sndToAll) then
  SndToAll(PChar(buildMsg +ActionType+'|'+imgfile+'|'+ ChrName +'|'+chrMsg));
  EdtMsgBody.Clear;
  Dsc := '';
  buildMsg := '';
  EdtMsgBody.setfocus;

end;

procedure TfrmChat.Setup;
begin
MainChat.ServerRoot := Path + 'characterImages';
Left :=  frmMacro.left + frmMacro.width + 1;
width := frmPlayerList.left - left - 1;
top := 122;
top := MainForm.top + MainForm.height + 1;

MainForm.MainChat1.checked := true;
show;

end;



procedure TfrmChat.FormResize(Sender: TObject);
begin
  // btnSend.left := Panel2.Width - btnSend.width - 2;
end;


procedure TfrmChat.tcCharacterListChange(Sender: TObject);
//var
//crntCount: Integer;
//lineCount: integer;
begin
    if not Assigned (NPCSettings) then
    NPCSettings := TBigIniFile.Create(NPCFilePath);

    if tcCharacterList.TabIndex = 0 then
      begin
           lblPlayerName.Caption := FrmOptions.EdtChrName.Text;
           lblPlayerName.font.color := FrmOptions.EdtChrName.font.color;
           lblPlayerDesc.Caption := FrmOptions.edtChrDesc.text;
           lblPlayerDesc.font.color := FrmOptions.edtChrDesc.font.color;
           FontDialog1.font := FrmOptions.edtChrName.Font;
      end
    else
        begin
             lblPlayerName.caption := NPCSettings.ReadString('NPC'+IntToStr(tcCharacterList.TabIndex), 'Name', '');
             lblPlayerDesc.caption := NPCSettings.ReadString('NPC'+IntToStr(tcCharacterList.TabIndex), 'ShortDesc', '');
//             crntCount := NPCSettings.ReadInteger('NPC'+IntToStr(tcCharacterList.TabIndex), 'Lines', 0);
             //  for LineCount := 0 to  crntCount - 1 do
             //      begin
             //          mmoFullDesc.lines.add(NPCSettings.ReadString('NPC'+IntToStr(tcCharacterList.TabIndex), 'Line'+IntToStr(LineCount),''));
             //      end;
             FontDialog1.Font.Color := stringToColor(NPCSettings.ReadString('NPC'+IntToStr(tcCharacterList.TabIndex), 'Color', ''));
             FontDialog1.Font.size := NPCSettings.ReadInteger('NPC'+IntToStr(tcCharacterList.TabIndex), 'Size', 8);
             FontDialog1.Font.Style := [];
             if NPCSettings.readBool('NPC'+IntToStr(tcCharacterList.TabIndex), 'Bold', false) then
                FontDialog1.Font.Style := FontDialog1.Font.Style + [fsBold];
             if NPCSettings.readBool('NPC'+IntToStr(tcCharacterList.TabIndex), 'Italic', false) then
                FontDialog1.Font.Style := FontDialog1.Font.Style + [fsItalic];
             if NPCSettings.readBool('NPC'+IntToStr(tcCharacterList.TabIndex), 'Underline', false) then
                FontDialog1.Font.Style := FontDialog1.Font.Style + [fsUnderline];

                lblPlayerName.font.color := FontDialog1.Font.color;
                lblPlayerDesc.font.color := FontDialog1.Font.color;
             SbQStats.Panels.Clear;
             btnQuickView.down := false;

        end;
       NPCSettings.free;
       NPCSettings := nil;

end;









procedure TfrmChat.btnLongSDescClick(Sender: TObject);
var
i: integer;
begin
if tcCharacterList.TabIndex = 0 then
   begin
        if MainForm.VrLocalPlayer.Description_Long.count <> 0 then
        EdtMsgBody.text := MainForm.VrLocalPlayer.Description_Long.text;
   end
else
    begin
         if not Assigned (NPCSettings) then
         NPCSettings := TBigIniFile.Create(NPCFilePath);
         EdtMsgBody.lines.clear;
         for i := 0 to NPCSettings.ReadInteger('NPC'+IntToStr(tcCharacterList.TabIndex), 'Lines', 0) -1 do
             begin
                  EdtMsgBody.lines.add(NPCSettings.ReadString('NPC'+IntToStr(tcCharacterList.TabIndex), 'Line'+IntToStr(i), ''));
             end;

         NPCSettings.free;
         NPCSettings := nil;

    end;

end;

procedure TfrmChat.btnQuickViewClick(Sender: TObject);
var
i: integer;
begin

if tcCharacterList.TabIndex = 0 then
   begin
        if MainForm.VrLocalPlayer.Character_QuickStat.count = 0 then exit;
        if btnQuickView.down then
           begin

                for i := 0 to MainForm.VrLocalPlayer.Character_QuickStat.count -1 do
                    begin
                         SbQStats.Panels.Add;
                         SbQStats.Panels.items[i].width := length(MainForm.VrLocalPlayer.Character_QuickStat.Strings[i])*8;
                         SbQStats.Panels.items[i].Text := MainForm.VrLocalPlayer.Character_QuickStat.Strings[i];
                    end;
                SbQStats.Panels.Add;
           end
        else
            begin
                 SbQStats.Panels.Clear;
            end;
   end
else
    begin
        if btnQuickView.down then
           begin
                if not Assigned (NPCSettings) then
                NPCSettings := TBigIniFile.Create(NPCFilePath);

                for i := 0 to NPCSettings.ReadInteger('NPC'+IntToStr(tcCharacterList.TabIndex), 'Stats', 0) -1 do
                    begin
                         SbQStats.Panels.Add;
                         SbQStats.Panels.items[i].Text := NPCSettings.ReadString('NPC'+IntToStr(tcCharacterList.TabIndex), 'Stat'+IntToStr(i), '');

                    end;
                NPCSettings.free;
                NPCSettings := nil;
                SbQStats.Panels.Add;
           end
        else
            begin
                 SbQStats.Panels.Clear;
            end;
    end;
end;

procedure TfrmChat.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     MainForm.MainChat1.checked := false;
end;

procedure TfrmChat.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
if MainForm.DXPlay1.Opened then CanClose := false;
end;

procedure TfrmChat.rbActionClick(Sender: TObject);
begin
 EdtMsgBody.SetFocus;
end;

procedure TfrmChat.FormCreate(Sender: TObject);
begin
ChatLog := TStringList.create;

end;

procedure TfrmChat.FormDestroy(Sender: TObject);
begin
ChatLog.clear;
ChatLog.Free;
ChatLog := nil;
end;

end.
