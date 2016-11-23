unit Notes;

interface

uses
  Windows, Forms, Dialogs, StdActns, ActnList, Menus, ToolWin, Wordcap, ImgList,
  Classes, Controls, StdCtrls, ComCtrls;

type
  TfrmNotes = class(TForm)
    ToolBar1: TToolBar;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    N1: TMenuItem;
    Print1: TMenuItem;
    N2: TMenuItem;
    Exit1: TMenuItem;
    ActionList1: TActionList;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    Edit1: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Memo1: TMemo;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    ImageList1: TImageList;
    ActNew: TAction;
    ActOpen: TAction;
    ActSave: TAction;
    ActPrint: TAction;
    ActExit: TAction;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ActSaveAs: TAction;
    MSOfficeCaption1: TMSOfficeCaption;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure ActExitExecute(Sender: TObject);
    procedure ActNewExecute(Sender: TObject);
    procedure ActOpenExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure ActSaveAsExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmNotes: TfrmNotes;

implementation

{$R *.DFM}

procedure TfrmNotes.ActExitExecute(Sender: TObject);
begin
Close;
end;

procedure TfrmNotes.ActNewExecute(Sender: TObject);
begin
Memo1.Lines.Clear;
SaveDialog1.FileName := 'Untitled.txt';
OpenDialog1.FileName := '';
end;

procedure TfrmNotes.ActOpenExecute(Sender: TObject);
begin
if OpenDialog1.Execute then
   begin
        Memo1.Lines.LoadFromFile(OpenDialog1.FileName);
        SaveDialog1.FileName := OpenDialog1.FileName;
   end;
end;

procedure TfrmNotes.ActSaveExecute(Sender: TObject);
begin
if SaveDialog1.FileName <> 'Untitled.txt' then
   Memo1.Lines.SaveToFile(SaveDialog1.FileName)
else
    ActSaveAsExecute(nil);

end;

procedure TfrmNotes.ActSaveAsExecute(Sender: TObject);
begin
if SaveDialog1.Execute then
   begin
        Memo1.Lines.SaveToFile(SaveDialog1.FileName);
   end;
end;

procedure TfrmNotes.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key=VK_ESCAPE then
    Close;

end;

end.
