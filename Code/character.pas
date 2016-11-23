unit character;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Grids, ExtDlgs, Wordcap, strFunctions,VrePlayer;

type
  TfrmCharacter = class(TForm)
    PageControl1: TPageControl;
    tbGenInfo: TTabSheet;
    tbDesc: TTabSheet;
    mLngDesc: TMemo;
    Label1: TLabel;
    tbAbilities: TTabSheet;
    sgAbilities: TStringGrid;
    OpenPictureDialog: TOpenPictureDialog;
    btnLoadImage: TButton;
    btnClearImage: TButton;
    Panel1: TPanel;
    chrImage: TImage;
    tbMisc: TTabSheet;
    mQuick: TMemo;
    Label2: TLabel;
    edtShrtDesc: TEdit;
    edtPName: TEdit;
    Label3: TLabel;
    edtCName: TEdit;
    Label4: TLabel;
    edtRace: TEdit;
    Label5: TLabel;
    Alignment: TLabel;
    edtAlign: TEdit;
    edtsex: TEdit;
    Label6: TLabel;
    edtHeight: TEdit;
    Label7: TLabel;
    edtweight: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    edtSize: TEdit;
    Label10: TLabel;
    edtAge: TEdit;
    Label11: TLabel;
    edtHair: TEdit;
    Label12: TLabel;
    EdtEyes: TEdit;
    btnDone: TButton;
    MSOfficeCaption1: TMSOfficeCaption;
    btnCancel: TButton;
    Label13: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnClearImageClick(Sender: TObject);
    procedure btnLoadImageClick(Sender: TObject);
    procedure btnDoneClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Setup(bReadOnly,bClearAll,bAutoLoad: Boolean; VrePlayer: TVREPlayer);

  end;

var
  frmCharacter: TfrmCharacter;

implementation

uses Main, chat;

{$R *.DFM}

procedure TfrmCharacter.FormShow(Sender: TObject);
begin
     sgAbilities.Cells[0,0] := 'Ability';
     sgAbilities.Cells[1,0] := 'Rating';
     sgAbilities.Cells[2,0] := 'Modifier';
     PageControl1.ActivePage:= tbGenInfo;
end;

procedure TfrmCharacter.btnClearImageClick(Sender: TObject);
begin
     chrImage.Picture := nil;
end;

procedure TfrmCharacter.btnLoadImageClick(Sender: TObject);
begin
   OpenPictureDialog.InitialDir := ExtractFilePath(Application.exeName) +'characterimages';
   if OpenPictureDialog.execute then
   begin
        chrImage.Picture.LoadFromFile(OpenPictureDialog.FileName);
        MainForm.VRLocalPlayer.Image_Name := ExtractFileName(OpenPictureDialog.FileName);
        MainForm.VRLocalPlayer.Image_Height := IntToStr(chrImage.Picture.height);
        MainForm.VRLocalPlayer.Image_width := IntToStr(chrImage.Picture.Width);

   end;

end;

procedure TfrmCharacter.btnDoneClick(Sender: TObject);
var
strAbility: string;
iLoop: integer;
begin
     if (edtCName.text = '') or (edtPName.text = '') then
     begin
          ShowMessage('Some required information is missing');
          PageControl1.ActivePage := tbGenInfo;
          exit;
     end;

     MainForm.VRLocalPlayer.Character_Name := edtCName.Text;
     MainForm.VRLocalPlayer.Description_Short := edtShrtDesc.text;
     MainForm.VRLocalPlayer.Description_Long.Text := mLngDesc.text;
     MainForm.VRLocalPlayer.Character_QuickStat.Text := mQuick.text;
     MainForm.vrLocalPlayer.Player_Name := edtPName.text;
     MainForm.vrLocalPlayer.Race := edtRace.text;
     MainForm.vrLocalPlayer.Alignment := edtAlign.text;
     MainForm.vrLocalPlayer.sex := edtsex.text;
     MainForm.vrLocalPlayer.Height := edtHeight.text;
     MainForm.vrLocalPlayer.weight := edtweight.text;
     MainForm.vrLocalPlayer.size := edtSize.text;
     MainForm.vrLocalPlayer.age := edtAge.text;
     MainForm.vrLocalPlayer.hair := edtHair.text;
     MainForm.vrLocalPlayer.eyes := edtEyes.text;

     for iLoop := 1 to sgAbilities.RowCount -1  do
         if sgAbilities.Cells[0,iLoop] <> '' then
         strAbility := strAbility + sgAbilities.Cells[0,iLoop] +'|'+sgAbilities.Cells[1,iLoop]+'|'+sgAbilities.Cells[2,iLoop] +'~';

     StrStripLast(strAbility);
     MainForm.vrLocalPlayer.Abilities :=  strAbility;

     if (MainForm.VRLocalPlayer.Character_Name <> '') or (MainForm.VRLocalPlayer.Description_Short <> '') then
        begin
             MainForm.SaveCharacterSettings1.enabled := true;
             MainForm.SpeedButton2.enabled := true;
             MainForm.SaveGameFiles1.enabled := true;
        end
     else
         begin
              MainForm.SaveCharacterSettings1.enabled := false;
              MainForm.SpeedButton2.enabled := false;
              MainForm.SaveGameFiles1.enabled := false;
         end;

     if Not(MainForm.DXPlay1.Opened) then
       begin
            MainForm.btnCreateJoin.enabled := true;
            MainForm.CreateJoinAGame1.enabled := true;
       end;

     ModalResult := mrok;
end;

procedure TfrmCharacter.Setup(bReadOnly,bClearAll,bAutoLoad: Boolean; VrePlayer: TVREPlayer);
var
   strAbility: String;
   iLoop: integer;
begin

    if bClearAll then
    begin
          mLngDesc.Lines.clear;
          mQuick.Lines.clear;
          edtShrtDesc.text := '';
          edtPName.text := '';
          edtCName.text := '';
          edtRace.text := '';
          edtAlign.text := '';
          edtsex.text := '';
          edtHeight.text := '';
          edtweight.text := '';
          edtSize.text := '';
          edtAge.text := '';
          edtHair.text := '';
          edtEyes.text := '';
          sgAbilities.Cols[0].clear;
          sgAbilities.Cols[1].clear;
          sgAbilities.Cols[2].clear;
          chrImage.Picture := nil;
          if frmchat.tcCharacterList.Tabs.Count = 1 then
             frmchat.tcCharacterList.Tabs.Delete(0);
    end;

    if bAutoLoad then
    begin
          mLngDesc.Lines.Assign(VrePlayer.Description_Long);
          mQuick.Lines.Assign(VrePlayer.Character_QuickStat);
          edtShrtDesc.text := VrePlayer.Description_Short;
          edtPName.text := VrePlayer.Player_Name;
          edtCName.text := VrePlayer.Character_Name;
          edtRace.text := VrePlayer.Race;
          edtAlign.text := VrePlayer.Alignment;
          edtsex.text := VrePlayer.sex;
          edtHeight.text := VrePlayer.Height;
          edtweight.text := VrePlayer.weight;
          edtSize.text := VrePlayer.size;
          edtAge.text := VrePlayer.age;
          edtHair.text := VrePlayer.hair;
          edtEyes.text := VrePlayer.eyes;
          strAbility := VrePlayer.Abilities;

          for iLoop := 1 to StrTokenCount(strAbility,'|') -1 do
          begin
               sgAbilities.Cells[0,iLoop]:= StrTokenAt(StrTokenAt(strAbility,'~',iLoop-1), '|', 0);
               sgAbilities.Cells[1,iLoop]:= StrTokenAt(StrTokenAt(strAbility,'~',iLoop-1), '|', 1);
               sgAbilities.Cells[2,iLoop]:= StrTokenAt(StrTokenAt(strAbility,'~',iLoop-1), '|', 2);
          end;

          if VrePlayer.Image_Name <> '' then
            chrImage.Picture.LoadFromFile(MainForm.VreSearchPath(VrePlayer.Image_Name));
    end;

    mLngDesc.ReadOnly := bReadOnly;
    mQuick.ReadOnly := bReadOnly;
    edtShrtDesc.ReadOnly := bReadOnly;
    edtPName.ReadOnly := bReadOnly;
    edtCName.ReadOnly := bReadOnly;
    edtRace.ReadOnly := bReadOnly;
    edtAlign.ReadOnly := bReadOnly;
    edtsex.ReadOnly := bReadOnly;
    edtHeight.ReadOnly := bReadOnly;
    edtweight.ReadOnly := bReadOnly;
    edtSize.ReadOnly := bReadOnly;
    edtAge.ReadOnly := bReadOnly;
    edtHair.ReadOnly := bReadOnly;
    edtEyes.ReadOnly := bReadOnly;
    if bReadOnly then
       sgAbilities.Options := sgAbilities.Options - [goEditing]
    else
       sgAbilities.Options := sgAbilities.Options + [goEditing];
    btnLoadImage.enabled := Not(bReadOnly);
    btnClearImage.enabled := Not(bReadOnly);
    
   ShowModal;

end;

procedure TfrmCharacter.btnCancelClick(Sender: TObject);
begin
     ModalResult := mrok;
end;

procedure TfrmCharacter.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
     if (frmchat.tcCharacterList.Tabs.Count = 0) and (MainForm.vrLocalPlayer.Character_Name <> '') then
     begin
          frmchat.tcCharacterList.Tabs.Add(MainForm.vrLocalPlayer.Character_Name);
          frmChat.Panel5.bevelouter := bvRaised;
     end;

end;

end.
