unit Options;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ExtCtrls, StdCtrls, Wordcap, ExtDlgs;

type
  TfrmOptions = class(TForm)
    fontcolor: TColorDialog;
    MSOfficeCaption1: TMSOfficeCaption;
    GradPan1: TPanel;
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    Bevel3: TBevel;
    btnFontColor: TSpeedButton;
    btnFontBold: TSpeedButton;
    btnFontItalic: TSpeedButton;
    btnfontUnderline: TSpeedButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    edtChrDesc: TEdit;
    button1: TButton;
    Label3: TLabel;
    cbFontSize: TComboBox;
    edtChrName: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure btnFontColorClick(Sender: TObject);
    procedure btnFontBoldClick(Sender: TObject);
    procedure btnFontItalicClick(Sender: TObject);
    procedure btnfontUnderlineClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmOptions: TfrmOptions;

implementation

uses Plugins, macros, chat, Main;

{$R *.DFM}

procedure TfrmOptions.Button1Click(Sender: TObject);
begin
     //fix
     ModalResult := mrOk;
end;

procedure TfrmOptions.btnFontColorClick(Sender: TObject);
begin
fontColor.execute;
edtChrName.Font.color := fontcolor.color;
edtChrDesc.Font.color := fontcolor.color;

end;

procedure TfrmOptions.btnFontBoldClick(Sender: TObject);
begin
     if btnfontBold.down then
        begin
             edtChrName.Font.Style := edtChrName.Font.Style + [fsBold];
             edtChrDesc.Font.Style := edtChrDesc.Font.Style + [fsBold];
        end
     else
         begin
              edtChrName.Font.Style := edtChrName.Font.Style - [fsBold];
              edtChrDesc.Font.Style := edtChrDesc.Font.Style - [fsBold];
         end;

end;

procedure TfrmOptions.btnFontItalicClick(Sender: TObject);
begin
     if btnfontItalic.down then
        begin
             edtChrName.Font.Style := edtChrName.Font.Style + [fsItalic];
             edtChrDesc.Font.Style := edtChrDesc.Font.Style + [fsItalic];
        end
     else
         begin
              edtChrName.Font.Style := edtChrName.Font.Style - [fsItalic];
              edtChrDesc.Font.Style := edtChrDesc.Font.Style - [fsItalic];
         end;

end;

procedure TfrmOptions.btnfontUnderlineClick(Sender: TObject);
begin
     if btnfontUnderline.down then
        begin
             edtChrName.Font.Style := edtChrName.Font.Style + [fsUnderline];
             edtChrDesc.Font.Style := edtChrDesc.Font.Style + [fsUnderline];
        end
     else
         begin
              edtChrName.Font.Style := edtChrName.Font.Style - [fsUnderline];
              edtChrDesc.Font.Style := edtChrDesc.Font.Style - [fsUnderline];
         end;

end;

procedure TfrmOptions.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key=VK_ESCAPE then
    Close;
end;

procedure TfrmOptions.FormCreate(Sender: TObject);
begin
    cbFontSize.ItemIndex := 8;
end;

end.
