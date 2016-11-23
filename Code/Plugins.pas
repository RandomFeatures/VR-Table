unit Plugins;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, Buttons, Main, Common, strFunctions, Wordcap,DirScanner,
  ExtCtrls;

const
    cPLUGIN_MASK    = '*.plg';

type
  TfrmPlugin = class(TForm)
    MSOfficeCaption1: TMSOfficeCaption;
    Button1: TButton;
    Panel1: TPanel;
    lbPlugins: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lAuthor: TLabel;
    lVersion: TLabel;
    lCopyright: TLabel;
    ldesc: TLabel;
    Label9: TLabel;
    procedure Exit1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lbPluginsClick(Sender: TObject);
    procedure lbPluginsDblClick(Sender: TObject);
  private
    { Private declarations }
    procedure LoadPlugin(Filename: string);
    procedure LoadPlugins;
    procedure PlugMnuClickEvent(Sender: TObject);
//    procedure PlugInClick(Sender: TObject);

  public
    { Public declarations }
    PluginList: TList;

    function RcvdMsgToPlugins(TheMsg: string): Boolean;


  end;

var
  frmPlugin: TfrmPlugin;
  RvMsg : TPluginRcvdMsg;
  LibHandle: integer;
  PluginMnuFuncList: TList;
// PluginHandles: TStrings;
type
TtmpMnuFunction  = procedure; stdcall;




implementation

uses chat, macros;


type
  //plug in object
    TPlugIn = class
    Name: String;
    Address: THandle;
    Call: Pointer;
    DescribeProc: TPluginDescribe;
    InitProc: TPluginInit;
    LoadMnu: TPluginLoadMnu;
    Configure: TPluginConfig;
    ID: string;
    Version: string;
    Author: string;
    Copyright: string;
    Description: String;
  end;




{$R *.DFM}

{procedure TfrmPlugin.LoadPlugins;
var
	Files: TStrings;
  i: Integer;
  TestPlugIn : TTestPlugIn;
  NewMenu: TMenuItem;
begin
	Files := TStringList.Create;
  Plugin := TList.Create;
  //Search what ever is in the app's dir
	SearchFileExt(ExtractFilepath(Application.Exename) + '\', '.dll', Files);
	for i := 0 to Files.Count-1 do
  begin
  	//create a new plug in
    TestPlugIn := TTestPlugIn.Create;
		TestPlugIn.Address := LoadLibrary(PChar(Files[i]));
    //Initialize the plugin give your app instance (and the handle if necessary)
    PlugInInit(GetProcAddress(TestPlugIn.Address, 'Init'))(HInstance);
    //get the a menu item
    TestPlugIn.Name := GetNameFunction(GetProcAddress(TestPlugIn.Address, 'GetName'));
    //get the function insert text
    TestPlugIn.Call := GetProcAddress(TestPlugIn.Address, 'InsertText');
    PlugIn.Add(TestPlugIn);
		//add the plug menu item
    NewMenu := TMenuItem.Create(Self);
    NewMenu.Caption := TestPlugIn.Name;
    NewMenu.OnClick := PlugInClick;
    NewMenu.Tag := i;
//    PlugIn1.Add(NewMenu);
    MainForm.MainMenu1.Items[NewMenu.Tag].Add(NewMenu);
  end;
  Files.Free;
end;
}

procedure TfrmPlugin.Exit1Click(Sender: TObject);
begin
    frmPlugin.Close;
    MainForm.PluginInformation1.checked := false;
end;


procedure TfrmPlugin.LoadPlugins;
var
   path: string;
   oDirScan: TDirectoryScanner;
begin
    path := ExtractFilePath(Application.Exename)+'Plugin\';

    oDirScan := TDirectoryScanner.Create;
    oDirScan.Extension := 'plg';              //scan for all files w/ this extension
    oDirScan.OnFoundFile := LoadPlugin;        //call this proc for each file found
    oDirScan.ProcessDirectory(Path);  //go!
    oDirScan.Free;

end;

procedure TfrmPlugin.LoadPlugin(FileName: String);
var
    MyMenuItemsList : TStrings;
    MyNewMenuItem: TMenuItem;
    iCount: integer;
    mnuCaption :string;
    ClickEvntPointer :PChar;
    mnuName :string;
    mnuLocation :integer;
    iPlugin: TPlugin;
//    path : string;
begin
    MyMenuItemsList := TStringList.create;

//    path := ExtractFilePath(Application.Exename)+'Plugin\';
    LibHandle := LoadLibrary(Pchar(FileName));

    if LibHandle <> 0 then
       begin
            iPlugin := TPlugin.Create;
            iPlugin.Address := LibHandle;

            // Find DescribePlugin
            iPlugin.DescribeProc := GetProcAddress(LibHandle, cPLUGIN_DESCRIBE);
            if assigned(iPlugin.DescribeProc) then
               begin
                    try
                        // Call DescribePlugin
                        iPlugin.DescribeProc(iPlugin.version,iPlugin.Name,iPlugin.ID,iPlugin.Description,iPlugin.Author,iPlugin.CopyRight);
                        lbPlugins.items.Add(iPlugin.Name);
                        // Find InitPlugin
                        iPlugin.InitProc := GetProcAddress(LibHandle, cPLUGIN_INIT);
                        if assigned(iPlugin.InitProc) then
                           begin
                                //Call InitPlugin
                                iPlugin.InitProc(Mainform.DXPlay1, Application.Handle);
                           end;
                   except

                    on E: Exception do Showmessage('1'+E.Message);
                   end;

                   try
                       iPlugin.LoadMnu := GetProcAddress(LibHandle, cPLUGIN_LOADMNU);
                       if assigned(iPlugin.LoadMnu) then
                           begin
                                //Call InitPlugin
                                iPlugin.LoadMnu(MyMenuItemsList);
                           end;
                   except
                     on E: Exception do Showmessage('2' + E.Message);
                   end;

                   try
                       iPlugin.Configure := GetProcAddress(LibHandle, cPLUGIN_Config);
                   except
                     on E: Exception do Showmessage('2.5' + E.Message);
                   end;

                   try
                       if MyMenuItemsList.Count <> 0 then
                       for iCount := 0 to MyMenuItemsList.Count - 1 do
                           begin
                              mnuCaption := StrTokenAt(MyMenuItemsList.Strings[iCount], ',', 0);
                              if PluginMnuFuncList.Count < 10 then
                                 mnuName := 'xMnu'+IntToStr(PluginMnuFuncList.Count)
                              else
                                 mnuName := 'xxMnu'+IntToStr(PluginMnuFuncList.Count);

                              mnuLocation := StrToInt(StrTokenAt(MyMenuItemsList.Strings[iCount], ',', 2));
                              if mnuLocation = 7 then MainForm.Plugins1.visible := true;

                              ClickEvntPointer := StrNew(PChar(StrTokenAt(MyMenuItemsList.Strings[iCount], ',', 1)));

                              PluginMnuFuncList.Add(GetProcAddress(LibHandle,ClickEvntPointer));

                              StrDispose(ClickEvntPointer);

                              MyNewMenuItem := TMenuItem.Create(Self);
                              MyNewMenuItem.caption := mnuCaption;
                              MyNewMenuItem.Name := mnuName;
                              MyNewMenuItem.OnClick := PlugMnuClickEvent;

                              MainForm.MainMenu1.Items[mnuLocation].Add(MyNewMenuItem);

                           //   MyNewMenuItem.free;
                          //    MyNewMenuItem := nil;
                           end;
                   except

                       on E: Exception do Showmessage('3'+E.Message);
                   end;

//                    RvMsg :=  GetProcAddress(LibHandle, cPLUGIN_RCVDMSG);
//                    StatChang := GetProcAddress(LibHandle, cPLUGIN_STSCHNG);
               end;
         PlugInList.Add(iPlugin);
//         freeLibrary(LibHandle);
     end;

end;

procedure TfrmPlugin.FormCreate(Sender: TObject);
begin
    PluginList := TList.create;
    PluginMnuFuncList := TList.create;
    LoadPlugins;

end;

procedure TfrmPlugin.PlugMnuClickEvent(Sender: TObject);
var
doClick : TtmpMnuFunction;
FuncIndex: Integer;
begin
 if strLeft((Sender as TMenuItem).Name, 2) = 'xx' then
    FuncIndex := StrToInt(strRight((Sender as TMenuItem).Name, 2))
 else
    FuncIndex := StrToInt(strLastCh((Sender as TMenuItem).Name));


 doClick := PluginMnuFuncList.Items[FuncIndex];
 if Assigned(doClick) then doClick;

end;


procedure TfrmPlugin.FormDestroy(Sender: TObject);
var
i: integer;
begin
     for i := 0 to PluginList.count -1 do
         freeLibrary(TPlugin(PluginList.Items[i]).address);

     while PluginList.Count > 0 do
     begin
          TObject(PluginList.Items[PluginList.Count - 1]).Free;
          PluginList.Delete(PluginList.Count - 1);
     end;

     while PluginMnuFuncList.Count > 0 do
     begin
        //  TObject(PluginMnuFuncList.Items[PluginMnuFuncList.Count - 1]).Free;
          PluginMnuFuncList.Delete(PluginMnuFuncList.Count - 1);
     end;

     PluginList.Free;
     PluginList := nil;
     PluginMnuFuncList.free;
     PluginMnuFuncList := nil;
  //   PluginHandles.free;
  //   PluginHandles := nil;

end;

function TfrmPlugin.RcvdMsgToPlugins(TheMsg: string): Boolean;
var
i : integer;
begin
     Result := true; //dont care
     for i := 0 to PluginList.count - 1 do
     begin

         RvMsg :=  GetProcAddress(TPlugin(Pluginlist.Items[i]).Address, cPLUGIN_RCVDMSG);
         if Not(RvMsg(TheMsg)) then Result := false;
     end;

end;

procedure TfrmPlugin.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key=VK_ESCAPE then
    Close;
end;

procedure TfrmPlugin.lbPluginsClick(Sender: TObject);
var
i: integer;
begin
     if lbPlugins.ItemIndex <> -1 then
     begin
         for i := 0 to PluginList.Count -1 do
         begin
             if TPlugin(PluginList.Items[i]).name = lbPlugins.Items.Strings[lbPlugins.ItemIndex] then
             begin
                 lAuthor.caption := TPlugin(PluginList.Items[i]).author;
                 lVersion.caption := TPlugin(PluginList.Items[i]).Version;
                 lCopyRight.caption := TPlugin(PluginList.Items[i]).CopyRight;
                 lDesc.caption := TPlugin(PluginList.Items[i]).Description;
             end;
         end;

     end;



end;

procedure TfrmPlugin.lbPluginsDblClick(Sender: TObject);
var
I: integer;
begin
     if lbPlugins.ItemIndex <> -1 then
     begin
         for i := 0 to PluginList.Count -1 do
         begin
             if TPlugin(PluginList.Items[i]).name = lbPlugins.Items.Strings[lbPlugins.ItemIndex] then
             begin
                 TPlugin(PluginList.Items[i]).Configure;
             end;
         end;

     end;

end;

end.
