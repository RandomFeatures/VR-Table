unit sysMessages;

interface

uses
  Windows, SysUtils,Controls, Forms, 
  StdCtrls, Wordcap, Classes;

type
  TfrmSysMsg = class(TForm)
    MSOfficeCaption1: TMSOfficeCaption;
    mmoSysMsg: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSysMsg: TfrmSysMsg;

implementation

uses Main;

{$R *.DFM}

procedure TfrmSysMsg.Button1Click(Sender: TObject);
begin
close;
MainForm.SystemMessages1.checked := false;
end;

procedure TfrmSysMsg.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key=VK_ESCAPE then
    Close;
end;

end.
 