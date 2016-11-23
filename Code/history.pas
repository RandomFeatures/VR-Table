unit history;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, ComCtrls, VREPlayer;

type
  TfrmDialog = class(TForm)
    SaveDialog1: TSaveDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Memo1: TMemo;
    Button2: TButton;
    Button1: TButton;
    TabSheet2: TTabSheet;
    mmorcvmsg: TMemo;
    Button3: TButton;
    Button4: TButton;
    btnNext: TButton;
    TabSheet3: TTabSheet;
    mmoPrvMsg: TMemo;
    btnSend: TButton;
    btnCancle: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure btnCancleClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDialog: TfrmDialog;

implementation

uses main, plyLst;

{$R *.DFM}

procedure TfrmDialog.Button1Click(Sender: TObject);
begin
     memo1.clear;
     modalresult := mrOk;

end;

procedure TfrmDialog.Button2Click(Sender: TObject);
begin
  SaveDialog1.InitialDir:= path + 'ChatLogs';
  SaveDialog1.FileName := 'Untitled.txt';
  if SaveDialog1.execute then
    Memo1.Lines.SaveToFile(SaveDialog1.FileName);
end;

procedure TfrmDialog.Button3Click(Sender: TObject);
var
  frmMsg: TfrmDialog;

begin
     frmMsg := TfrmDialog.Create(Self);
     frmMsg.PageControl1.ActivePage := frmMsg.TabSheet3;
     frmMsg.Caption := 'Private Message for ' + frmPlayerList.PlayrList.Selected.Caption;
     if frmMsg.ShowModal = mrOk then
     if label1.Caption = 'All Players' then
        frmPlayerList.SendPrivateMessage('DPID_ALLPLAYERS',pMsg)
     else
         frmPlayerList.SendPrivateMessage(label1.caption,pMsg);

     frmMsg.Free;
     frmMsg := nil;
     if btnNext.enabled = false then
     Button4Click(Sender);

end;

procedure TfrmDialog.Button4Click(Sender: TObject);
begin
mmorcvmsg.clear;
modalresult := mrOk;

end;

procedure TfrmDialog.btnNextClick(Sender: TObject);
var
i: integer;
begin
  i := frmPlayerList.playerList.IndexOf(frmPlayerList.playrList.ItemFocused.Caption);

  mmorcvmsg.text := TVrePlayer(frmPlayerList.PlayerList.Objects[i]).Player_Messages.Strings[0];

  TVrePlayer(frmPlayerList.PlayerList.Objects[i]).Player_Messages.Delete(0);
  if TVrePlayer(frmPlayerList.PlayerList.Objects[i]).Player_Messages.Count = 0 then
     TVrePlayer(frmPlayerList.PlayerList.Objects[i]).Message_Waiting := false;
  btnNext.enabled :=TVrePlayer(frmPlayerList.PlayerList.Objects[i]).Message_Waiting;

end;

procedure TfrmDialog.btnSendClick(Sender: TObject);
begin
     pMsg := mmoPrvMsg.text;
     mmoPrvMsg.clear;
     modalresult := mrOk;

end;

procedure TfrmDialog.btnCancleClick(Sender: TObject);
begin
     mmoPrvMsg.clear;
     modalresult := mrCancel;

end;

procedure TfrmDialog.FormShow(Sender: TObject);
var
I: integer;
MoreMsg : boolean;
begin
     if PageControl1.ActivePage = TabSheet2 then
        begin
             MoreMsg := false;
             caption := 'Received Message from ' + FrmPlayerList.PlayrList.Selected.Caption;

             i := frmPlayerList.playerList.IndexOf(FrmPlayerList.playrList.ItemFocused.Caption);
             MoreMsg :=TVrePlayer(frmPlayerList.PlayerList.Objects[i]).Message_Waiting;

             if MoreMsg then btnNext.enabled := true
                else
                    btnNext.enabled := false;
             Button3.Enabled := true;
             Button4.Enabled := true;
             Button4.setfocus;
        end;
     if PageControl1.ActivePage = TabSheet3 then
     begin
          mmoPrvMsg.setfocus;
          btnSend.Enabled := true;
          btnCancle.Enabled := true;
     end;
     if PageControl1.ActivePage = TabSheet1 then
        begin
             Button2.Enabled := true;
             Button1.Enabled := true;
             Button1.setfocus;
        end;


end;

procedure TfrmDialog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key=VK_ESCAPE then
    Close;
end;

end.
 