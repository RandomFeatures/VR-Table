program GameEditor;

uses
  Forms,
  main in 'main.pas' {frmGameEdt};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmGameEdt, frmGameEdt);
  Application.Run;
end.
