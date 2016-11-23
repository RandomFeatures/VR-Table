unit macros;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Wordcap, ExtDlgs, StdCtrls, Buttons, ExtCtrls, explbtn, strFunctions, 
  ComCtrls;

type
  TfrmMacro = class(TForm)
    MSOfficeCaption1: TMSOfficeCaption;
    OpnImage: TOpenPictureDialog;
    OpnSound: TOpenDialog;
    panel1: TPanel;
    Label1: TLabel;
    edtname: TEdit;
    lblNewMac: TLabel;
    edtMacro: TEdit;
    sbOpen: TSpeedButton;
    picthear: TExplorerButton;
    pictsay: TExplorerButton;
    pictsee: TExplorerButton;
    btnCreate: TButton;
    Button1: TButton;
    btnMore: TButton;
    lbMacro: TListBox;
    btnEdit: TButton;
    btnDelete: TButton;
    btnApply: TButton;
    pictdo: TExplorerButton;
    rgMacroType: TRadioGroup;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    MacroList: TScrollBox;
    TabSheet2: TTabSheet;
    TreeView1: TTreeView;
    procedure btnCreateClick(Sender: TObject);

    procedure rgMacroTypeClick(Sender: TObject);
    procedure edtMacroChange(Sender: TObject);
    procedure sbOpenClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnMoreClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnDeleteClick(Sender: TObject);

  private
    { Private declarations }
  public
        procedure Setup(setting: string);
        procedure MyClick(Sender: TObject);
    { Public declarations }
  end;

var
  frmMacro: TfrmMacro;
  tmpCaption : string;
  crntindx: integer;
implementation

uses plyLst, Main, chat;

{$R *.DFM}

procedure TfrmMacro.Setup(setting: string);
var
i : integer;
begin
top := MainForm.top + MainForm.height + 1;

if Setting = 'chat' then
   begin
       Hide;
        Left := 1;
        height := frmchat.height;
        width := 140;
        panel1.width := 0;
        borderStyle := bsSizeable;
        for I := 0 to macrolist.ComponentCount - 1 do
           begin
            (macrolist.Components[i] as TExplorerButton).enabled := true;
           end;
    end;

if Setting = 'edit' then
   begin
        Hide;
        width := 386;
        height := 243;
        top := (screen.height - height) div 2;
        left := (screen.width - width) div 2;
        panel1.width := 250;
        borderStyle := bsSingle;
        btnCreate.visible := True;
        btnMore.caption := 'More >>>';
        for I := 0 to macrolist.ComponentCount - 1 do
            begin
            (macrolist.Components[i] as TExplorerButton).enabled := false;
            end;

end;
MainForm.PlayerMacros1.checked := true;
show;

end;



procedure TfrmMacro.btnCreateClick(Sender: TObject);
var
NewMacro: TExplorerButton;
NewImage: TBitMap;
begin
NewImage := pictsay.bitmap;
tmpCaption := rgMacroType.Items[rgMacroType.ItemIndex] + '%'+ edtMacro.text;
if rgMacroType.ItemIndex = 1 then
        NewImage := pictDo.bitmap;
if rgMacroType.ItemIndex = 2 then
        NewImage := picthear.bitmap;
if rgMacroType.ItemIndex = 3 then
        NewImage := pictsee.bitmap;


NewMacro := TExplorerButton.Create(macrolist);
NewMacro.Parent := macrolist;
NewMacro.Alignment := taLeftJustify;
NewMacro.Enabled := false;
NewMacro.Layout := blBitmapLeft;
NewMacro.UnselectedFontColor := clblack;
NewMacro.NoFocusBitmap:= NewImage;
NewMacro.Font.Color := clBlue;
NewMacro.Bitmap := NewImage;
NewMacro.Caption := EdtName.text;
NewMacro.Hint := tmpCaption;
NewMacro.Left:= 0;
NewMacro.height := 25;
NewMacro.top := 25 * (MacroList.ControlCount -1);
NewMacro.width := MacroList.clientwidth;
NewMacro.OnClick := myClick;
NewMacro.ShowHint := false;
NewMacro.Show;
NewMacro := Nil;
lbMacro.Items.add(EdtName.Text);
//edtMacro.ReadOnly := true;
edtMacro.text := '';
lblnewMac.caption := 'New Macro';
EdtName.text := '';
edtName.Setfocus;
//btnCreate.enabled := false;
//sbOpen.Visible := false;

end;

Procedure TfrmMacro.MyClick(Sender: TObject);
var
saveTalk: boolean;
saveAction : boolean;
begin
    if StrTokenAt((Sender as TExplorerButton).hint, '%',0) = 'Talk' then
       begin
            FrmChat.EdtMsgBody.clear;
            FrmChat.EdtMsgBody.Text := StrTokenAt((Sender as TExplorerButton).hint, '%',1);
            saveAction := FrmChat.rbAction.checked;
            saveTalk := FrmChat.rbTalk.checked;

            FrmChat.rbTalk.checked := true;
            FrmChat.BtnSendClick(Sender);

            FrmChat.rbAction.checked := saveAction;
            FrmChat.rbTalk.checked := saveTalk;
            FrmChat.EdtMsgBody.clear;
       end;

    if StrTokenAt((Sender as TExplorerButton).hint, '%',0) = 'Action' then
       begin
            FrmChat.EdtMsgBody.clear;
            FrmChat.EdtMsgBody.Text := StrTokenAt((Sender as TExplorerButton).hint, '%',1);
            saveAction := FrmChat.rbAction.checked;
            saveTalk := FrmChat.rbTalk.checked;

            FrmChat.rbAction.checked := true;
            FrmChat.BtnSendClick(Sender);

            FrmChat.rbAction.checked := saveAction;
            FrmChat.rbTalk.checked := saveTalk;
            FrmChat.EdtMsgBody.clear;
       end;


  //  if StrTokenAt((Sender as TExplorerButton).hint, '%',0) = 'Play Sound' then
  //  if StrTokenAt((Sender as TExplorerButton).hint, '%',0) = 'Show Image' then






end;


procedure TfrmMacro.rgMacroTypeClick(Sender: TObject);
begin
   edtMacro.ReadOnly := true;
   sbOpen.Visible := false;

   if rgMacroType.ItemIndex = 0 then
      begin
           edtMacro.ReadOnly := false;
           lblNewMac.Caption := 'What would you like to say?';
           edtName.setfocus;
      end;
   if rgMacroType.ItemIndex = 1 then
      begin
           edtMacro.ReadOnly := false;
           lblNewMac.Caption := 'What would you like to do?';
           edtName.setfocus;
      end;
   if rgMacroType.ItemIndex = 2 then
      begin
           OpnSound.initialdir := ExtractFilePath(Application.exename) + 'sounds';
           OpnSound.Execute;
           edtMacro.Text := OpnSound.FileName;
           lblNewMac.Caption := 'Selected Sound File';
           sbOpen.Hint := 'Select a different sound';
           sbOpen.Visible := true;
           edtName.setfocus;
      end;

   if rgMacroType.ItemIndex = 3 then
      begin
           OpnImage.initialdir := ExtractFilePath(Application.exename) + 'Images';
           OpnImage.Execute;
           edtMacro.Text := OpnImage.FileName;
           lblNewMac.Caption := 'Selected Image File';
           sbOpen.Hint := 'Select a different image';
           sbOpen.Visible := true;
           edtName.setfocus;
      end;

end;

procedure TfrmMacro.edtMacroChange(Sender: TObject);
begin
if (edtMacro.text <> '') and (edtName.text <> '') then
     btnCreate.Enabled := true
else
    btnCreate.enabled := false;

end;

procedure TfrmMacro.sbOpenClick(Sender: TObject);
begin
   if rgMacroType.ItemIndex = 2 then
      begin
           OpnSound.initialdir := ExtractFilePath(Application.exename) + 'sounds';
           OpnSound.Execute;
           edtMacro.Text := OpnSound.FileName;
           edtName.setfocus;
      end;

   if rgMacroType.ItemIndex = 3 then
      begin
           OpnImage.initialdir := ExtractFilePath(Application.exename) + 'Images';
           OpnImage.Execute;
           edtMacro.Text := OpnImage.FileName;
           edtName.setfocus;
      end;

end;


procedure TfrmMacro.Button1Click(Sender: TObject);
begin
setup('chat');
end;

procedure TfrmMacro.FormResize(Sender: TObject);
var
i :integer;
begin
//rgMacroType.ItemIndex := 0;
btnEdit.enabled := true;
btnDelete.enabled := true;
edtMacro.ReadOnly := false;
edtName.ReadOnly := false;
edtname.text := '';
edtMacro.text := '';
lbMacro.Items.Clear;

for I := 0 to macrolist.ComponentCount - 1 do
begin
    (macrolist.Components[i] as TExplorerButton).width := MacroList.clientwidth;
    lbMacro.Items.Add((macrolist.Components[i] as TExplorerButton).caption);
end;
end;

procedure TfrmMacro.btnMoreClick(Sender: TObject);
begin
if btnMore.caption = 'More >>>' then
   begin
        btnMore.caption := 'Close <<<';
        btnCreate.visible := false;
        Height := 386;
   end
else
   begin
        btnMore.caption := 'More >>>';
        btnCreate.visible := True;
        width := 386;
        height := 243;
        panel1.width := 250;
   end;
end;


procedure TfrmMacro.btnEditClick(Sender: TObject);
begin
   if lbMacro.ItemIndex = -1 then  exit;
   crntindx := lbMacro.ItemIndex;
   edtname.text := (macrolist.Components[crntindx] as TExplorerButton).Caption;
   edtMacro.text := StrTokenAt((macrolist.Components[crntindx] as TExplorerButton).Hint, '%', 1);
   if StrTokenAt((macrolist.Components[crntindx] as TExplorerButton).Hint, '%', 0) = 'Talk' then rgMacroType.ItemIndex := 0;
   if StrTokenAt((macrolist.Components[crntindx] as TExplorerButton).Hint, '%', 0) = 'Action' then rgMacroType.ItemIndex := 1;
   if StrTokenAt((macrolist.Components[crntindx] as TExplorerButton).Hint, '%', 0) = 'Play Sound' then rgMacroType.ItemIndex := 2;
   if StrTokenAt((macrolist.Components[crntindx] as TExplorerButton).Hint, '%', 0) = 'Show Image' then rgMacroType.ItemIndex := 3;
//   lbMacro.Items.Delete(crntindx);
   btnDelete.enabled := false;
   btnEdit.enabled := false;
   btnApply.enabled := true;
end;

procedure TfrmMacro.btnApplyClick(Sender: TObject);
var
NewImage: TBitMap;

begin

NewImage := pictsay.bitmap;

if rgMacroType.ItemIndex = 1 then
        NewImage := pictDo.bitmap;
if rgMacroType.ItemIndex = 2 then
        NewImage := picthear.bitmap;
if rgMacroType.ItemIndex = 3 then
        NewImage := pictsee.bitmap;

   (macrolist.Components[crntindx] as TExplorerButton).Caption := edtname.text;
   (macrolist.Components[crntindx] as TExplorerButton).hint := rgMacroType.Items[rgMacroType.ItemIndex] + '%'+ edtMacro.text;
   (macrolist.Components[crntindx] as TExplorerButton).bitmap := NewImage;
   (macrolist.Components[crntindx] as TExplorerButton).NoFocusBitmap:= NewImage;

   btnDelete.enabled := true;
   btnEdit.enabled := true;
   btnApply.enabled := false;

end;

procedure TfrmMacro.FormClose(Sender: TObject; var Action: TCloseAction);
begin
MainForm.PlayerMacros1.checked := false;

end;

procedure TfrmMacro.btnDeleteClick(Sender: TObject);
var
i : integer;
begin
   if (lbMacro.Items.count = 0) or (lbMacro.ItemIndex = -1) then exit;

   crntindx := lbMacro.ItemIndex;
   lbMacro.Items.Delete(crntindx);
   (macrolist.Components[crntindx] as TExplorerButton).free;

   for I := 0 to macrolist.ComponentCount - 1 do
       begin
            (macrolist.Components[i] as TExplorerButton).Top := 25 * i;
       end;


end;

end.
  