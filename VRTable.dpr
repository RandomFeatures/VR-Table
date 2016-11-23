program VRTable;

uses
  Sharemem,
  Forms,
  SysUtils,
  Main in 'Main.pas' {MainForm},
  Options in 'Options.pas' {frmOptions},
  chat in 'chat.pas' {frmChat},
  plyLst in 'plyLst.pas' {frmPlayerList},
  macros in 'macros.pas' {frmMacro},
  Imageview in 'Imageview.pas' {frmImageView},
  Plugins in 'Plugins.pas' {frmPlugin},
  common in 'common.pas',
  ImgSnd in 'ImgSnd.pas' {frmImgSnd},
  preferences in 'preferences.pas' {frmPref},
  history in 'history.pas' {frmDialog},
  splash in 'splash.pas' {frmSplash},
  sysMessages in 'sysMessages.pas' {frmSysMsg},
  connect in 'connect.pas' {frmConnect},
  Notes in 'Notes.pas' {frmNotes},
  about in 'about.pas' {frmAbout},
  sound in 'sound.pas' {frmSound: TDataModule},
  character in 'character.pas' {frmCharacter};

  var
  SplashScreen : TfrmSplash;

{$R *.RES}

begin
 try
    Application.Initialize;
    Application.Title := 'The Game Master''s Table';
    Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TfrmOptions, frmOptions);
  Application.CreateForm(TfrmChat, frmChat);
  Application.CreateForm(TfrmPlayerList, frmPlayerList);
  Application.CreateForm(TfrmMacro, frmMacro);
  Application.CreateForm(TfrmPlugin, frmPlugin);
  Application.CreateForm(TfrmImgSnd, frmImgSnd);
  Application.CreateForm(TfrmPref, frmPref);
  Application.CreateForm(TfrmSysMsg, frmSysMsg);
  Application.CreateForm(TfrmNotes, frmNotes);
  Application.CreateForm(TfrmSound, frmSound);
  Application.CreateForm(TfrmCharacter, frmCharacter);
  FrmSound.Setup;
    SplashScreen := TfrmSplash.Create(Application);
    SplashScreen.Show;
    SplashScreen.Update;


  repeat
      Application.ProcessMessages;
      until SplashScreen.CloseQuery;
    SplashScreen.Close;
  finally
    SplashScreen.Free;
  end;
  Application.Run;
end.
