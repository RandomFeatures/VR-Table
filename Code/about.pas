unit about;

interface

uses
  Windows, Forms, SysUtils, Controls, Classes, Wordcap, Graphics, ExtCtrls;

 Type
    TfrmAbout = class(TForm)
    MSOfficeCaption1: TMSOfficeCaption;
    Image1: TImage;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DXTimerActivate(Sender: TObject);
    procedure DXTimerDeactivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
  end;

var
  frmAbout: TfrmAbout;

implementation

uses Main;

{$R *.DFM}

procedure TfrmAbout.DXTimerActivate(Sender: TObject);
begin
//  Caption := Application.Title;
end;

procedure TfrmAbout.DXTimerDeactivate(Sender: TObject);
begin
 // Caption := Application.Title + ' [Pause]';
end;

procedure TfrmAbout.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {  Application end  }
  if Key=VK_ESCAPE then
  begin
      close;
       //DXTimer.Enabled := false;
      // ModalResult := mrOk;
  end;
end;

procedure TfrmAbout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     try
        ModalResult := mrOk;
     except
     end;
end;

end.
