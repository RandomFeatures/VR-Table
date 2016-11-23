program TV_FolderFile;

uses
  Forms,
  TV_FolderFile_U1 in 'TV_FolderFile_U1.pas' {Form1},
  TreeUtils in 'TreeUtils.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
