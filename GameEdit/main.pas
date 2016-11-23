unit main;

interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Dialogs, StdCtrls, Buttons,
  ExtCtrls, Wordcap, Menus, ComCtrls, BigIni,  xprocs, Controls, ActiveX,
  Wave, DXSounds, MMSystem, ExtDlgs, DXDraws, ImgList,  TreeUtils, TDocFile_U1;

const
   IMG_NODE_ROOT = 0;
   IMG_NODE_FILE_CLOSED = 1;
   IMG_NODE_FILE_OPEN = 2;
   IMG_NODE_FOLDER_CLOSED = 3;
   IMG_NODE_FOLDER_OPEN = 4;

type
      {Enum used for easily identifying nodes}
   eNodeType = (ntUnknown,  ntRoot,  ntFile,  ntFolder);


  TfrmGameEdt = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    OpenGameFile1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    MSOfficeCaption1: TMSOfficeCaption;
    gbchrInfo: TGroupBox;
    edtChrName: TEdit;
    edtshrtDesc: TEdit;
    mmoFullDesc: TMemo;
    GroupBox2: TGroupBox;
    Panel1: TPanel;
    lbNPCList: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    BitBtn1: TBitBtn;
    btnNew: TBitBtn;
    btnEdit: TBitBtn;
    btnAdd: TBitBtn;
    btnCancel: TBitBtn;
    FontDialog1: TFontDialog;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    SaveGameFile1: TMenuItem;
    TabSheet4: TTabSheet;
    mmoQuickStat: TMemo;
    Label4: TLabel;
    GroupBox1: TGroupBox;
    GroupBox3: TGroupBox;
    Label5: TLabel;
    edtGMName: TEdit;
    Label6: TLabel;
    edtGMDesc: TEdit;
    BitBtn2: TBitBtn;
    FontDialog2: TFontDialog;
    DXSound1: TDXSound;
    GroupBox4: TGroupBox;
    Panel2: TPanel;
    WaveCollect: TListBox;
    GroupBox5: TGroupBox;
    OpenDialog2: TOpenDialog;
    btnSoundAdd: TBitBtn;
    edtFileName: TEdit;
    edtFreq: TEdit;
    BitBtn5: TBitBtn;
    Label7: TLabel;
    Label9: TLabel;
    edtLngth: TEdit;
    Label10: TLabel;
    edtSize: TEdit;
    Label12: TLabel;
    BitBtn6: TBitBtn;
    GroupBox6: TGroupBox;
    Panel3: TPanel;
    lbImages: TListBox;
    GroupBox7: TGroupBox;
    BitBtn4: TBitBtn;
    DXImageList1: TDXImageList;
    OpenPictureDialog1: TOpenPictureDialog;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    btnImgImp: TBitBtn;
    btnImgExp: TBitBtn;
    SaveDialog2: TSaveDialog;
    BitBtn11: TBitBtn;
    BitBtn12: TBitBtn;
    BitBtn13: TBitBtn;
    DXWaveList1: TDXWaveList;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    OpenDialog3: TOpenDialog;
    OpenDialog4: TOpenDialog;
    SaveDialog3: TSaveDialog;
    Label8: TLabel;
    edtname: TEdit;
    lblNewMac: TLabel;
    edtMacro: TEdit;
    sbOpen: TSpeedButton;
    btnCreate: TButton;
    Button2: TButton;
    btnDelete: TButton;
    ListBox1: TListBox;
    RadioGroup1: TRadioGroup;
    TabSheet5: TTabSheet;
    but_AddFolder: TButton;
    but_Remove: TButton;
    tv_eg5: TTreeView;
    Button1: TButton;
    Button3: TButton;
    but_AddFile: TButton;
    Label11: TLabel;
    mcroName: TEdit;
    Label13: TLabel;
    MacroText: TMemo;
    ImageList1: TImageList;
    Button4: TButton;
    SaveDialog4: TSaveDialog;
    procedure Exit1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure NewGameFile1Click(Sender: TObject);
    procedure ReadNPCList;
    procedure OpenGameFile1Click(Sender: TObject);
    procedure edtChrNameChange(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure btnImgExpClick(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure lbImagesClick(Sender: TObject);
    procedure btnImgImpClick(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn13Click(Sender: TObject);
    procedure WaveCollectClick(Sender: TObject);
    procedure but_RemoveClick(Sender: TObject);
    procedure but_AddFolderClick(Sender: TObject);
    procedure but_AddFileClick(Sender: TObject);
    procedure btnSoundAddClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure tv_eg5DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure tv_eg5DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure tv_eg5DblClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
     function GetNodeType(  Node : TTreeNode  ) : eNodeType;
     procedure AddRootNode;
     function IsNodeAllowed(  ParentNode : TTreeNode;
                              NewNodesType : eNodeType
                            ) : boolean;
     procedure writeMacro;
     procedure readMacro;
     function LoadName_callback(  sElementName : WideString;
                                  dwType : DWORD;
                                  pData : pointer
                                ) : boolean;


  public
    { Public declarations }
    Audio: TAudioFileStream;

  end;

var
  frmGameEdt: TfrmGameEdt;
  TmpGameFile : TBigIniFile;
  path : string;
  Changes: Boolean;
  Picturs: TPictureCollection;

implementation

{$R *.DFM}

procedure Save_CallBack(  Node : TTreeNode;  pData : pointer  );
var
   stor : TDocFileStorage;
   subStor : TDocFileStorage;
   strmImages : TDocFileStream;
begin
      {End of recursion (base case)}
   if(  (Node = nil) or (pData = nil)  ) then
      Exit;

   stor := TDocFileStorage(pData);

      {Create a storage for this node
        NB Remeber the limits on a storage element's name,
        (31 chars max etc...)}
   subStor := stor.CreateStorage(  Node.Text,  MY_STGM_CREATE  );

      {Was storage created}
   if(  subStor = nil  ) then
   begin
      ShowMessage(  'Error creating sub-storage'  );
      Exit;
   end;

      {Open the stream for saving the image info to}
   strmImages := subStor.CreateStream(  'Images',  MY_STGM_CREATE  );

      {Images stream created?}
   if(  strmImages = nil  ) then
   begin
      ShowMessage(  'Error Creating stream'  )
   end
   else begin
         {Save image and selected index}
      strmImages.WriteString(   IntToStr(  Node.ImageIndex  ) + #13#10 +
                                IntToStr(  Node.SelectedIndex  )
                             );

   end;

      {Save all children}
   if(  Node.GetFirstChild <> nil  ) then
      Save_CallBack(  Node.GetFirstChild,  subStor  );

      {Save all siblings}
   if(  Node.GetNextSibling <> nil  ) then
      Save_CallBack(  Node.GetNextSibling,  stor  );


   strmImages.Free;
   subStor.Free;
end;

procedure Load_CallBack(  Node : TTreeNode;  pData : pointer  );
var
   stor : TDocFileStorage;
   substor : TDocFileStorage;
   strmImages : TDocFileStream;
begin
   stor := TDocFileStorage(pData);
      {Open the storage for this element}
   substor := stor.OpenStorage(  Node.Text,  MY_STGM_OPEN  );

      {Storage opened?}
   if(  substor = nil  ) then
   begin
      ShowMessage(  'Cant open storage ' + Node.Text  );
      Exit;
   end;

      {Open the images stream}
   strmImages := substor.OpenStream(  'Images',  MY_STGM_OPEN  );

      {Stream open?}
   if(  strmImages <> nil  ) then
   begin
      with TStringList.Create do
      begin
            {Load the stream's data into a TString List}
         LoadFromStream(  strmImages  );

         if(  Count > 0  ) then
         begin
               {Get the saved image index}
            Node.ImageIndex := StrToInt(  Strings[ 0 ]  );

            if(  Count > 1  ) then
                  {Get the saved selected index}
               Node.SelectedIndex := StrToInt(  Strings[ 1 ]  );
         end;

         Free;
      end;

         {Close the stream}
      strmImages.Free;
   end;

      {Enum all sub-elements}
   substor.EnumElements(  frmGameEdt.LoadName_callback,  substor  );

      {Done with storage}
   substor.Free;
end;

procedure TfrmGameEdt.Exit1Click(Sender: TObject);
begin
Close;
end;

procedure TfrmGameEdt.BitBtn1Click(Sender: TObject);
begin
     if FontDialog1.execute then
        begin
             edtChrName.Font :=  FontDialog1.font;
             edtshrtDesc.Font :=  FontDialog1.font;
             mmoFullDesc.Font :=  FontDialog1.font;
        end;
end;

procedure TfrmGameEdt.btnAddClick(Sender: TObject);
var
crntCount: Integer;
lineCount: integer;
begin
    if not(Assigned(TmpGameFile)) then
    TmpGameFile := TBigIniFile.Create(path + 'Gamefile.tmp');

    if (btnAdd.Caption = 'Update') and (btnAdd.tag <> 0) then
       begin
            TmpGameFile.WriteString('NPC'+IntToStr(btnAdd.tag), 'Name', edtChrName.text);
            TmpGameFile.WriteString('NPC'+IntToStr(btnAdd.tag), 'ShortDesc', edtshrtDesc.text);
            TmpGameFile.WriteInteger('NPC'+IntToStr(btnAdd.tag), 'Lines', mmoFullDesc.lines.count);
            TmpGameFile.WriteInteger('NPC'+IntToStr(btnAdd.tag), 'Stats', mmoQuickStat.lines.count);
            for LineCount := 0 to  mmoFullDesc.lines.count - 1 do
                begin
                     TmpGameFile.WriteString('NPC'+IntToStr(btnAdd.tag), 'Line'+IntToStr(LineCount),mmoFullDesc.lines[LineCount]);
                end;
            for LineCount := 0 to  mmoQuickStat.lines.count - 1 do
                begin
                     TmpGameFile.WriteString('NPC'+IntToStr(btnAdd.tag), 'Stat'+IntToStr(LineCount),mmoQuickStat.lines[LineCount]);
                end;
                //write out font stuff
            TmpGameFile.WriteString('NPC'+IntToStr(btnAdd.tag), 'Color', ColorToString(FontDialog1.Font.Color));
            TmpGameFile.WriteInteger('NPC'+IntToStr(btnAdd.tag), 'Size', FontDialog1.Font.size);
            TmpGameFile.WriteBool('NPC'+IntToStr(btnAdd.tag), 'Bold', fsBold in FontDialog1.Font.Style);
            TmpGameFile.WriteBool('NPC'+IntToStr(btnAdd.tag), 'Italic', fsItalic in FontDialog1.Font.Style);
            TmpGameFile.WriteBool('NPC'+IntToStr(btnAdd.tag), 'Underline', fsUnderLine in FontDialog1.Font.Style);
       end
    else
        begin
             CrntCount := TmpGameFile.ReadInteger('NPC', 'count', 0);
             Inc(CrntCount);
             TmpGameFile.WriteInteger('NPC', 'count', CrntCount);
             TmpGameFile.WriteString('NPC'+IntToStr(CrntCount), 'Name', edtChrName.text);
             TmpGameFile.WriteString('NPC'+IntToStr(CrntCount), 'ShortDesc', edtshrtDesc.text);
             TmpGameFile.WriteInteger('NPC'+IntToStr(CrntCount), 'Lines', mmoFullDesc.lines.count);
             TmpGameFile.WriteInteger('NPC'+IntToStr(btnAdd.tag), 'Stats', mmoQuickStat.lines.count);
            for LineCount := 0 to  mmoFullDesc.lines.count - 1 do
                 begin
                      TmpGameFile.WriteString('NPC'+IntToStr(CrntCount), 'Line'+IntToStr(LineCount),mmoFullDesc.lines[LineCount]);
                 end;
            for LineCount := 0 to  mmoQuickStat.lines.count - 1 do
                begin
                     TmpGameFile.WriteString('NPC'+IntToStr(btnAdd.tag), 'Stat'+IntToStr(LineCount),mmoQuickStat.lines[LineCount]);
                end;

                 //write out font stuff
             TmpGameFile.WriteString('NPC'+IntToStr(CrntCount), 'Color', ColorToString(FontDialog1.Font.Color));
             TmpGameFile.WriteInteger('NPC'+IntToStr(CrntCount), 'Size', FontDialog1.Font.size);
             TmpGameFile.WriteBool('NPC'+IntToStr(CrntCount), 'Bold', fsBold in FontDialog1.Font.Style);
             TmpGameFile.WriteBool('NPC'+IntToStr(CrntCount), 'Italic', fsItalic in FontDialog1.Font.Style);
             TmpGameFile.WriteBool('NPC'+IntToStr(CrntCount), 'Underline', fsUnderLine in FontDialog1.Font.Style);
        end;

    ReadNPCList;

    edtChrName.text := '';
    edtshrtDesc.text := '';
    mmoFullDesc.lines.clear;
    mmoQuickStat.lines.clear;
    edtChrName.Font := lbNPCList.font;
    edtshrtDesc.Font := lbNPCList.font;
    mmoFullDesc.Font := lbNPCList.font;
    FontDialog1.Font := lbNPCList.font;
    gbchrInfo.enabled := false;

    btnAdd.tag := 0;
    btnAdd.enabled := false;
    btnAdd.Caption := 'Add';
    btnNew.enabled := true;
    btnEdit.Enabled := true;
    btnCancel.enabled := false;
    changes := true;
end;

procedure TfrmGameEdt.btnNewClick(Sender: TObject);
begin
btnCancel.enabled := true;
gbchrInfo.enabled := true;
edtChrName.setfocus;
btnEdit.enabled := false;
btnNew.enabled := false;
end;

procedure TfrmGameEdt.NewGameFile1Click(Sender: TObject);
var
iLoop: integer;
ImageListName: string;
SoundListName: string;
storFile : TDocFileStorage;
begin

   TmpGameFile.WriteString('GM', 'Name', edtGMName.text);
   TmpGameFile.WriteString('GM', 'ShortDesc', edtGMDesc.text);
   TmpGameFile.WriteString('GM', 'Color', ColorToString(FontDialog2.Font.Color));
   TmpGameFile.WriteInteger('GM', 'Size', FontDialog2.Font.size);
   TmpGameFile.WriteBool('GM', 'Bold', fsBold in FontDialog2.Font.Style);
   TmpGameFile.WriteBool('GM', 'Italic', fsItalic in FontDialog2.Font.Style);
   TmpGameFile.WriteBool('GM', 'Underline', fsUnderLine in FontDialog2.Font.Style);

   TmpGameFile.WriteInteger('Sound', 'Count', WaveCollect.Items.Count);
   for iLoop := 0 to WaveCollect.Items.Count - 1 do
   TmpGameFile.WriteString('Sound', 'snd'+IntToStr(iLoop),WaveCollect.Items.Strings[iLoop]);

   TmpGameFile.WriteInteger('Image', 'Count', lbImages.Items.Count);
   for iLoop := 0 to lbImages.Items.Count - 1 do
   TmpGameFile.WriteString('Image', 'img'+IntToStr(iLoop),lbImages.Items.Strings[iLoop]);

    if SaveDialog1.FileName = '' then
       SaveDialog1.InitialDir := ExtractFilePath(Application.exename)+ 'Gamefiles'
    else
       SaveDialog1.InitialDir := ExtractFilePath(SaveDialog1.FileName);

    if SaveDialog1.Execute then
       begin
            MSOfficeCaption1.CaptionText.Caption := '[' +  ExtractFileName(SaveDialog1.FileName) + ']';
            OpenDialog1.FileName := '';

       end
    else
           exit;

         ImageListName := ExtractFilePath(SaveDialog1.FileName) + StrTokenAt(ExtractFileName(SaveDialog1.FileName),'.', 0) + '.gcl';
         SoundListName := ExtractFilePath(SaveDialog1.FileName) + StrTokenAt(ExtractFileName(SaveDialog1.FileName),'.', 0) + '.scl';

         if WaveCollect.Items.Count <> 0 then
            begin
                 DXWaveList1.Items.SaveToFile(SoundListName);
                 TmpGameFile.WriteString('Sound', 'FileName', ExtractFileName(SoundListName));
            end;
         if lbImages.Items.Count <> 0 then
            begin
                 Picturs.SaveToFile(ImageListName);
                 TmpGameFile.WriteString('Image', 'FileName', ExtractFileName(ImageListName));
            end;

         if fileExists(SaveDialog1.FileName) then
         fileShredder(SaveDialog1.FileName);
         if fileCopy(path + 'Gamefile.tmp',SaveDialog1.FileName) then
            begin
                 btnNew.enabled := true;
            end
         else
             Information('There was an error saving the file');

//savetreeview
   storFile := CreateDocFile(ExtractFilePath(SaveDialog1.FileName) + StrTokenAt(ExtractFileName(SaveDialog1.FileName),'.', 0) +  '.ole',
                                MY_STGM_CREATE
                             );

   if(  storFile = nil  ) then
   begin
      ShowMessage(  'Cant create file'  );
      Exit;
   end;

      {Start saving}
   Save_CallBack(  tv_eg5.Items[ 0 ],  storFile  );

      {Done}
   storFile.Free;

end;

procedure TfrmGameEdt.ReadNPCList;
var
crntCount: Integer;
iLoop: Integer;
begin
     if not(Assigned(TmpGameFile)) then
     TmpGameFile := TBigIniFile.Create(path+'GameFile.tmp');
     lbNPCList.Items.Clear;
     crntCount := TmpGameFile.ReadInteger('NPC', 'count', 0);
     for iLoop := 1 to crntCount do
         begin
              lbNPCList.Items.Add(TmpGameFile.ReadString('NPC'+IntToStr(iLoop), 'Name', ''));
         end;


end;


procedure TfrmGameEdt.OpenGameFile1Click(Sender: TObject);
var
ImageListName: string;
SoundListName: string;
i : integer;
storFile : TDocFileStorage;

begin
OpenDialog1.InitialDir := ExtractFilePath(Application.exename) + 'gamefiles';
if OpenDialog1.Execute then
   begin
        MSOfficeCaption1.CaptionText.Caption := '[' +  ExtractFileName(OpenDialog1.FileName) + ']';
        SaveDialog1.FileName := OpenDialog1.FileName;
        if Assigned(TmpGameFile) then
           begin
               TmpGameFile.free;
               TmpGameFile := nil;
           end;
        fileShredder(path + 'Gamefile.tmp');
        if Xprocs.fileCopy(OpenDialog1.FileName, path + 'Gamefile.tmp') then
           begin
             ReadNPCList;
             BtnNew.enabled := true;
             btnEdit.Enabled := true;
           end
        else
            begin
                 Information('There wan an error creating the temp file make sure the disk is not full or write protected.');
                 exit;
            end;

        edtGMName.text := TmpGameFile.readString('GM', 'Name', 'GM');
        edtGMDesc.text := TmpGameFile.readString('GM', 'ShortDesc', 'The Game Master');
        FontDialog2.Font.Color := StringToColor(TmpGameFile.readString('GM', 'Color', 'clRed'));
        FontDialog2.Font.size := TmpGameFile.readInteger('GM', 'Size', 8);
        FontDialog2.Font.Style := [];
        if TmpGameFile.readBool('GM', 'Bold', False) then
        FontDialog2.Font.Style := FontDialog2.Font.Style + [fsBold];
        if TmpGameFile.readBool('GM', 'Italic', False) then
        FontDialog2.Font.Style := FontDialog2.Font.Style + [fsItalic];
        if TmpGameFile.readBool('GM', 'UnderLine', False) then
        FontDialog2.Font.Style := FontDialog2.Font.Style + [fsUnderline];
        edtGMName.Font :=  FontDialog2.font;
        edtGMDesc.Font :=  FontDialog2.font;

  ImageListName := ExtractFilePath(OpenDialog1.FileName) + StrTokenAt(ExtractFileName(OpenDialog1.FileName),'.', 0) + '.gcl';
  SoundListName := ExtractFilePath(OpenDialog1.FileName) + StrTokenAt(ExtractFileName(OpenDialog1.FileName),'.', 0) + '.scl';

  if FileExists(SoundListName) then
  begin
       DXWaveList1.Items.LoadFromFile(SoundListName );
       for i := 0 to DXWaveList1.Items.Count - 1 do
           begin
                WaveCollect.items.add(DXWaveList1.Items.items[i].Name);
           end;
  end;

  if FileExists(ImageListName) then
     begin
       Picturs.LoadFromFile(ImageListName);
       for i := 0 to picturs.Count - 1 do
            begin
                 lbImages.items.add(picturs.Items[i].Name);
            end;
  end;
   end;

  if fileExists(ExtractFilePath(OpenDialog1.FileName) + StrTokenAt(ExtractFileName(OpenDialog1.FileName),'.', 0) + '.ole') then
     begin
      {Open the file}
      storFile := OpenDocFile(   ExtractFilePath(OpenDialog1.FileName) + StrTokenAt(ExtractFileName(OpenDialog1.FileName),'.', 0) + '.ole',
                              MY_STGM_OPEN
                           );

      {Was the DocFile opened}
      if(  storFile = nil  ) then
           begin
                ShowMessage(  'Cant open file'  );
                Exit;
           end;

      {Remove all tree nodes}
     tv_eg5.Items.Clear;

      {Enum all root level elements in the storage file}
      storFile.EnumElements(  LoadName_callback,  storFile  );
    end;
      {Done}
   storFile.Free;


end;

procedure TfrmGameEdt.edtChrNameChange(Sender: TObject);
begin
btnAdd.Enabled := true;
end;

procedure TfrmGameEdt.btnEditClick(Sender: TObject);
var
crntCount: Integer;
lineCount: integer;
begin
    if not(Assigned(TmpGameFile)) then
    TmpGameFile := TBigIniFile.Create(path + 'Gamefile.tmp');

    if lbNPCList.ItemIndex = -1 then exit;
    edtChrName.text := TmpGameFile.ReadString('NPC'+IntToStr(lbNPCList.ItemIndex + 1), 'Name', '');
    edtshrtDesc.text := TmpGameFile.ReadString('NPC'+IntToStr(lbNPCList.ItemIndex + 1), 'ShortDesc', '');
    crntCount := TmpGameFile.ReadInteger('NPC'+IntToStr(lbNPCList.ItemIndex + 1), 'Lines', 0);

    for LineCount := 0 to  crntCount - 1 do
        begin
            mmoFullDesc.lines.add(TmpGameFile.ReadString('NPC'+IntToStr(lbNPCList.ItemIndex + 1), 'Line'+IntToStr(LineCount),''));
        end;

    crntCount := TmpGameFile.ReadInteger('NPC'+IntToStr(lbNPCList.ItemIndex + 1), 'Stats', 0);
    for LineCount := 0 to  crntCount - 1 do
        begin
            mmoQuickStat.lines.add(TmpGameFile.ReadString('NPC'+IntToStr(lbNPCList.ItemIndex + 1), 'Stat'+IntToStr(LineCount),''));
        end;

    FontDialog1.Font.Color := stringToColor(TmpGameFile.ReadString('NPC'+IntToStr(lbNPCList.ItemIndex + 1), 'Color', ''));
    FontDialog1.Font.size := TmpGameFile.ReadInteger('NPC'+IntToStr(lbNPCList.ItemIndex + 1), 'Size', 8);
    if TmpGameFile.readBool('NPC'+IntToStr(lbNPCList.ItemIndex + 1), 'Bold', false) then
      FontDialog1.Font.Style := FontDialog1.Font.Style + [fsBold];
    if TmpGameFile.readBool('NPC'+IntToStr(lbNPCList.ItemIndex + 1), 'Italic', false) then
       FontDialog1.Font.Style := FontDialog1.Font.Style + [fsItalic];
    if TmpGameFile.readBool('NPC'+IntToStr(lbNPCList.ItemIndex + 1), 'Underline', false) then
       FontDialog1.Font.Style := FontDialog1.Font.Style + [fsUnderline];

    edtChrName.font := FontDialog1.Font;
    edtshrtDesc.font := FontDialog1.Font;
    mmoFullDesc.font := FontDialog1.Font;

btnAdd.tag :=  lbNPCList.ItemIndex + 1;
gbchrInfo.enabled := true;
btnAdd.enabled := true;
btnAdd.Caption := 'Update';
btnNew.enabled := false;
btnEdit.Enabled := false;
btnCancel.enabled := true;

end;

procedure TfrmGameEdt.btnCancelClick(Sender: TObject);
begin

    edtChrName.text := '';
    edtshrtDesc.text := '';
    mmoFullDesc.lines.clear;
    mmoQuickStat.lines.clear;
    edtChrName.Font := lbNPCList.font;
    edtshrtDesc.Font := lbNPCList.font;
    mmoFullDesc.Font := lbNPCList.font;
    FontDialog1.Font := lbNPCList.font;
    gbchrInfo.enabled := false;

    btnAdd.tag := 0;
    btnAdd.enabled := false;
    btnAdd.Caption := 'Add';
    btnNew.enabled := true;
    btnEdit.Enabled := true;
    btnCancel.enabled := false;
end;

procedure TfrmGameEdt.FormCreate(Sender: TObject);
begin
    AddRootNode;
    Picturs := TPictureCollection.create(self);
    if not(Assigned(TmpGameFile)) then
    TmpGameFile := TBigIniFile.Create(ExtractFilePath(Application.exeName)+'gamefile.tmp');
    TmpGameFile.WriteInteger('NPC', 'count', 0);
    TmpGameFile.WriteString('FileType', 'Type', 'GM');
end;


procedure TfrmGameEdt.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     DXSound1.Finalize;
     Picturs.Free;
     Picturs := nil;
     TmpGameFile.free;
     TmpGameFile := nil;
     fileShredder(path + 'Gamefile.tmp');
     Application.terminate;

end;

procedure TfrmGameEdt.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
if Changes then
   begin
        if Question('Do you wish to save changes to '+ SaveDialog1.FileName +' first?') then
           NewGameFile1Click(Sender)
        
   end;


end;

procedure TfrmGameEdt.BitBtn2Click(Sender: TObject);
begin
     if FontDialog2.execute then
        begin
             edtGMName.Font :=  FontDialog2.font;
             edtGMDesc.Font :=  FontDialog2.font;
        end;

end;

procedure TfrmGameEdt.FormShow(Sender: TObject);
begin
Try
   PageControl1.ActivePage := TabSheet4;
   DXSound1.Initialize;
   Picturs.Clear;
except
end;
end;

procedure TfrmGameEdt.Button1Click(Sender: TObject);
begin
tv_eg5.LoadFromFile(ExtractFilePath(Application.exeName)+'MacList.mcl');
tv_eg5.FullExpand;

end;

procedure TfrmGameEdt.BitBtn6Click(Sender: TObject);
var
  WaveFormat: TWaveFormatEx;
begin
OpenDialog2.InitialDir := ExtractFilePath(Application.exename);
if OpenDialog2.Execute then
   begin
        edtFileName.text := ExtractFileName(OpenDialog2.fileName);
        Audio := TAudioFileStream.Create(DXSound1.DSound);
        Audio.FileName := OpenDialog2.FileName;
        Audio.Looped := false;

        {  Setting of format of primary buffer.  }
        MakePCMWaveFormatEx(WaveFormat, 44100, Audio.Format.wBitsPerSample, 2);
        DXSound1.Primary.SetFormat(WaveFormat);

        edtFreq.text := IntToStr(Audio.Frequency) + ' Hz';
        edtSize.text := IntToStr(Audio.Size) + ' bytes';
        edtLngth.text := IntToStr(Audio.BufferLength div 1000) + ' second(s)';
//      edtTyp.text :=
        btnSoundAdd.enabled := true;
        BitBtn5.enabled := true;
   end;

end;

procedure TfrmGameEdt.BitBtn7Click(Sender: TObject);
begin
OpenPictureDialog1.InitialDir := ExtractFilePath(Application.exename) + '\images';
if OpenPictureDialog1.Execute then
   begin

      Image1.picture.LoadFromFile(OpenPictureDialog1.filename);
      BitBtn4.enabled := true;
   end;

end;

procedure TfrmGameEdt.BitBtn4Click(Sender: TObject);
var
Item: TPictureCollectionItem;
begin
     Item := TPictureCollectionItem.Create(picturs);
     Item.Name := StrTokenAt(ExtractFileName(OpenPictureDialog1.filename), '.', 0);
     Item.Picture := image1.picture;
     lbImages.Items.Add(StrTokenAt(ExtractFileName(OpenPictureDialog1.filename), '.', 0));

end;

procedure TfrmGameEdt.btnImgExpClick(Sender: TObject);
begin
SaveDialog2.InitialDir := ExtractFilePath(Application.exename)+ 'images';
if SaveDialog2.execute then
   Picturs.SaveToFile(SaveDialog2.FileName);
end;

procedure TfrmGameEdt.BitBtn8Click(Sender: TObject);
begin
ShowMessage(IntToStr(Picturs.count));
end;

procedure TfrmGameEdt.BitBtn5Click(Sender: TObject);
begin
if btnSoundAdd.enabled then
   Audio.play
else
    DXWaveList1.items.Items[WaveCollect.ItemIndex].play(false);
end;


procedure TfrmGameEdt.lbImagesClick(Sender: TObject);
begin
   Image1.picture := picturs.Items[lbImages.ItemIndex].picture;
   BitBtn4.enabled := false;

end;

procedure TfrmGameEdt.btnImgImpClick(Sender: TObject);
var
i : integer;
begin
OpenDialog3.InitialDir := ExtractFilePath(Application.exename)+ 'images';
if OpenDialog3.execute then
   begin
        Picturs.LoadFromFile(OpenDialog3.FileName);
        for i := 0 to picturs.Count - 1 do
            begin
                 lbImages.items.add(picturs.Items[i].Name);
            end
   end;



end;

procedure TfrmGameEdt.BitBtn12Click(Sender: TObject);
var
i : integer;
begin
OpenDialog4.InitialDir := ExtractFilePath(Application.exename)+ 'sounds';
if OpenDialog4.execute then
   begin
        DXWaveList1.Items.LoadFromFile(OpenDialog4.FileName);
        for i := 0 to DXWaveList1.Items.Count - 1 do
            begin
                 WaveCollect.items.add(DXWaveList1.Items.items[i].Name);
            end
   end;


end;

procedure TfrmGameEdt.BitBtn13Click(Sender: TObject);
begin
SaveDialog3.InitialDir := ExtractFilePath(Application.exename) + 'sounds';
if SaveDialog3.execute then
   begin
        DXWaveList1.Items.SaveToFile(SaveDialog3.FileName);
   end;

end;

procedure TfrmGameEdt.WaveCollectClick(Sender: TObject);
begin
    btnSoundAdd.enabled := false;
    BitBtn5.enabled := true;
    edtFreq.text := IntToStr(DXWaveList1.items.Items[WaveCollect.ItemIndex].Frequency) + ' Hz';
    edtSize.text := IntToStr(DXWaveList1.items.Items[WaveCollect.ItemIndex].wave.format.cbSize) + ' bytes';
    edtLngth.text := IntToStr(DXWaveList1.items.Items[WaveCollect.ItemIndex].wave.format.nAvgBytesPerSec) + ' second(s)';
    edtFileName.text := WaveCollect.Items.Strings[WaveCollect.ItemIndex];
end;

function TfrmGameEdt.GetNodeType(  Node : TTreeNode  ) : eNodeType;
begin
   if(  Node = nil  ) then
   begin
      Result := ntUnknown;
      Exit;
   end;

      {Determine what type of node this is by looking at the
        node's ImageIndex}
   case Node.ImageIndex of
      IMG_NODE_ROOT : Result := ntRoot;
      IMG_NODE_FILE_CLOSED : Result := ntFile;
      IMG_NODE_FOLDER_CLOSED : Result := ntFolder;
   else
         {Node should be one of the above...}
      Result := ntUnknown;
   end;
end;



///////////////////////////////////////////////////////
// Check if a new node of type NewNodeType may be
//   created as a child off ParentNode
///////////////////////////////////////////////////////
function TfrmGameEdt.IsNodeAllowed(  ParentNode : TTreeNode;
                                NewNodesType : eNodeType
                              ) : boolean;
begin
   case GetNodeType(  ParentNode  ) of
      ntRoot :
      begin
            {A root may contain any type of node}
         Result := true;
      end;

      ntFolder :
      begin
            {Folder may contain any type of node}
         Result := true;
      end;

      ntFile :
      begin;
            {Files may have no sub-items}
         Result := false;
      end;
   else
         {Unknown node type, dont allow any operations}
      Result := false;
   end;
end;



///////////////////////////////////
// Adds the root to an empty tree
///////////////////////////////////
procedure TfrmGameEdt.AddRootNode;
begin
      {If the tree is empty}
   if(  tv_eg5.Items.Count = 0  ) then
   begin
     {Add the root node}
      with tv_eg5.Items.AddFirst(  nil,  'Untitled'  ) do
      begin
         Selected := true;

            {Set the roots image index}
         ImageIndex := IMG_NODE_ROOT;
            {Set the roots selected index. The same image is uses
               as for the ImageIndex}
         SelectedIndex := IMG_NODE_ROOT;
      end;
   end
end;


procedure TfrmGameEdt.but_RemoveClick(Sender: TObject);
begin
      {Make sure somthing is selected, before trying to
        delete it}
   if(  tv_eg5.Selected = nil  ) then
   begin
      ShowMessage(  'Nothing selected'  );
      Exit;
   end;

      {Dont allow user to delete the root node}
   if(  tv_eg5.Selected.Level = 0  ) then
   begin
      ShowMessage(  'Cant delete the root node'  );
      Exit;
   end;

   if(  tv_eg5.Selected.HasChildren ) then
          begin
               ShowMessage(  'You can only delete an empty folder'  );
               Exit;
          end;

      if(GetNodeType(tv_eg5.Selected) = ntFolder) then
      {Delete the node}
       tv_eg5.Selected.Delete;
end;

procedure TfrmGameEdt.but_AddFolderClick(Sender: TObject);
var
sText: string;
begin
//   AddNode(  ntFolder  );
      {If nothing is selected}
   if(  tv_eg5.Selected = nil  ) then
   begin
         {There is a root, so user must first select a node}
      ShowMessage(  'Select parent node'  );
      Exit;
   end
   else begin
         {Get a name for the new node}
      if(   not InputQuery(  'New Folder',  'Folder Name?',  sText  )   )  then
         Exit;
      if stext = '' then exit;
         {Check if this name is already in use}
      if(   IsDuplicateName(  tv_eg5.Selected.GetFirstChild,
                              sText,
                              true
                            )
         ) then
      begin
         ShowMessage(  'A node with this name already exists'  );
         Exit;
      end;

         {Check if adding this type of node is allowed}
      if(   not IsNodeAllowed(  tv_eg5.Selected,  ntFolder  )   ) then
      begin
         ShowMessage(  'Cant creat this type of node here'  );
         Exit;
      end;

         {Add the node}
      with tv_eg5.Items.AddChildFirst(  tv_eg5.Selected,  sText  ) do
      begin
                  {Set the image used when the node is not selected}
               ImageIndex := IMG_NODE_FOLDER_CLOSED;
                  {Image used when the node is selected}
               SelectedIndex := IMG_NODE_FOLDER_OPEN;
               MakeVisible;
      end;
   end;


end;

procedure TfrmGameEdt.but_AddFileClick(Sender: TObject);
begin
//   AddNode(  ntFile  );

   if mcroName.text = '' then exit;
      {If nothing is selected}

   if(  tv_eg5.Selected = nil  ) then
   begin
         {There is a root, so user must first select a node}
      ShowMessage(  'Select parent node'  );
      Exit;
   end
   else begin

         {Check if this name is already in use}
      if(   IsDuplicateName(  tv_eg5.Selected.GetFirstChild,
                              mcroName.text,
                              true
                            )
         ) then
      begin
         ShowMessage(  'A node with this name already exists'  );
         Exit;
      end;

         {Check if adding this type of node is allowed}
      if(   not IsNodeAllowed(  tv_eg5.Selected,  ntFile  )   ) then
      begin
         ShowMessage(  'Cant creat this type of node here'  );
         Exit;
      end;
      WriteMacro;
         {Add the node}
      with tv_eg5.Items.AddChildFirst(  tv_eg5.Selected,  mcroName.text ) do
      begin
           {Set the image used when the node is not selected}
           ImageIndex := IMG_NODE_FILE_CLOSED;
           {Image used when the node is selected}
           SelectedIndex := IMG_NODE_FILE_OPEN;
           MakeVisible;
      end;
      McroName.text := '';
      MacroText.lines.clear;

   end;


end;

procedure TfrmGameEdt.btnSoundAddClick(Sender: TObject);
var
  Item: TWaveCollectionItem;
begin
  Item := TWaveCollectionItem.Create(DXWaveList1.Items);
  Item.Name := edtFileName.text;
  Item.Looped := false;
  Item.Wave.LoadFromFile(OpenDialog2.fileName);
  WaveCollect.Items.add(edtFileName.text);

end;

procedure TfrmGameEdt.Button3Click(Sender: TObject);
begin
tv_eg5.SaveToFile(ExtractFilePath(Application.exeName)+'MacList.mcl');

end;

procedure TfrmGameEdt.tv_eg5DragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
   TargetNode : TTreeNode;
   SourceNode : TTreeNode;
begin
/////////////////////////////////////////
// Somthing has just been droped
/////////////////////////////////////////


   with tv_eg5 do
   begin
         {Get the node the item was dropped on}
      TargetNode := GetNodeAt(  X,  Y  );
         {Just to make things a bit easier}
      SourceNode := Selected;


         {Make sure somthing was droped onto}
      if(  TargetNode = nil  ) then
      begin
         EndDrag(  false  );
         Exit;
      end;

         {Dropping onto self or onto parent?}
      if(  (TargetNode = Selected) or
           (TargetNode = Selected.Parent)
        ) then
      begin
         MessageBeep(  MB_ICONEXCLAMATION  );
         ShowMessage(  'Destination node is the same as the source node'  );
         EndDrag(  false  );
         Exit;
      end;

         {No drag-drop of the root allowed}
      if(  SourceNode.Level = 0  ) then
      begin
         MessageBeep(  MB_ICONEXCLAMATION  );
         ShowMessage(  'Cant drag/drop the root'  );
         EndDrag(  false  );
         Exit;
      end;


         {Can't drop a parent onto a child}
      if(   IsAParentNode(  Selected,  TargetNode  )   ) then
      begin
         MessageBeep(  MB_ICONEXCLAMATION  );
         ShowMessage(  'Cant drop parent onto child'  );
         EndDrag(  false  );
         Exit;
      end;

         {Does a node with this name exists as a child of TargetNde}
      if(   IsDuplicateName(  TargetNode.GetFirstChild,  SourceNode.Text,  true  )   ) then
      begin
         MessageBeep(  MB_ICONEXCLAMATION  );
         ShowMessage(  'A node with this name already exists'  );
         EndDrag(  false  );
         Exit;
      end;

      //////////////////////////////////////////////////////////////
      // Nothing differant up to here.  Just the normal drag and
      //   drop checking.  Now the code to make sure that enforce
      //   "the rules".  Eg books may contain no sub-nodes
      //////////////////////////////////////////////////////////////

         {Use the IsNodeAllowed function to test if the node
           may be dropped here}
      if(  not IsNodeAllowed(   TargetNode,
                                GetNodeType(  SourceNode  )
                              )
         ) then
      begin
         ShowMessage(  'You cant drop this type of node here!'  );
         EndDrag(  false  );
         Exit;
      end;


         {Drag drop was valid so move the nodes}
      MoveTreeNode(  tv_eg5,  SourceNode,  TargetNode  );

         {Delete the old node}
      SourceNode.Delete;


         {Show the nodes that were just moved}
      TargetNode.Expand(  true  );
   end;
end;

procedure TfrmGameEdt.tv_eg5DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
////////////////////////////////////////
// Decide if drag-drop is to be allowed
/////////////////////////////////////////

   Accept := false;

      {Only accept drag and drop from a TTreeView}
   if(  Sender is TTreeView  ) then
         {Only accept from self}
      if(  TTreeView(Sender) = tv_eg5  ) then
         Accept := true;
end;

procedure TfrmGameEdt.writeMacro;
var
tmpIni: TbigIniFile;
mycount: integer;
i: integer;
begin
  tmpIni := TBigIniFile.create(ExtractFilePath(Application.exeName)+'darkcity.mrf');
  mycount := tmpIni.ReadInteger('FileInfo', 'count', 0);
  Inc(MyCount);
  tmpIni.WriteInteger('FileInfo', 'count', mycount);

  tmpIni.writestring('Macro'+IntToStr(mycount), 'Name', mcroName.text);
  tmpIni.WriteInteger('Macro'+IntToStr(mycount), 'LineCount', MacroText.Lines.count);

  for I := 0 to MacroText.Lines.count - 1 do
  begin
    tmpIni.writestring('Macro'+IntToStr(mycount), 'Line'+IntToStr(i), MacroText.Lines[i]);

  end;

tmpIni.free;
tmpIni := nil;

end;

procedure TfrmGameEdt.ReadMacro;
var
tmpIni: TBigIniFile;
mycount: integer;
i: integer;
Needed: integer;
begin
     Needed := 0;
  tmpIni := TBigIniFile.create(ExtractFilePath(Application.exeName)+'darkcity.mrf');
  mycount := tmpIni.ReadInteger('FileInfo', 'count', 0);
  Inc(MyCount);
  for i := 1 to mycount do
  begin
       if tmpIni.readstring('Macro'+IntToStr(i), 'Name', '') = tv_eg5.Selected.Text then
        needed := i;
  end;



  mcroName.text:=   tmpIni.readstring('Macro'+IntToStr(Needed), 'Name', '');

  mycount := tmpIni.readInteger('Macro'+IntToStr(needed), 'LineCount', 0);

  for I := 1 to Mycount do
  begin
       MacroText.Lines.add(tmpIni.readstring('Macro'+IntToStr(Needed), 'Line'+IntToStr(i), ''));

  end;

tmpIni.free;
tmpIni := nil;

end;

procedure TfrmGameEdt.tv_eg5DblClick(Sender: TObject);
begin
      if GetNodeType(tv_eg5.Selected)= ntFile then
            ReadMacro;

end;




function TfrmGameEdt.LoadName_callback(  sElementName : WideString;
                                    dwType : DWORD;
                                    pData : pointer
                                  ) : boolean;
var
   Node : TTreeNode;
   OldNode : TTreeNode;
begin
      {Continue enum}
   Result := true;

      {Only interested in storages}
   if(  dwType <> STGTY_STORAGE  ) then
      Exit;

      {Save the node that is currently selected}
   OldNode := tv_eg5.Selected;

      {Add a new node for this element}
   Node := tv_eg5.Items.AddChild(  tv_eg5.Selected,  sElementName  );
      {Select new node}
   Node.Selected := true;

      {Load data and all sub-elements}
   Load_CallBack(  Node,  pData  );

      {Select old node again}
   if(  OldNode <> nil  ) then
      OldNode.Selected := true;
end;





procedure TfrmGameEdt.Button4Click(Sender: TObject);
begin
  DXWaveList1.Items.Items[WaveCollect.ItemIndex].Wave.SaveToFile('c:\temp\'+WaveCollect.Items.Strings[WaveCollect.ItemIndex])
//DXWaveList1.Items.items[WaveCollect.ItemIndex].SaveToFile(WaveCollect.items(WaveCollect.ItemIndex))
end;

initialization
path := ExtractFilePath(Application.exeName);
changes := false;
end.
