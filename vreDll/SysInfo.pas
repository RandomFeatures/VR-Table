unit SysInfo;

interface

uses
  Windows, SysUtils, Forms,
  StdCtrls,Winsock, Wordcap, ExtCtrls, Classes, Controls;

type
  TfrmSysInfo = class(TForm)
    MSOfficeCaption1: TMSOfficeCaption;
    GradPan1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSysInfo: TfrmSysInfo;
  PCName: String;
implementation



{$R *.DFM}


// returns ISP assigned IP
function LocalIP : string;
type
    TaPInAddr = array [0..10] of PInAddr;
    PaPInAddr = ^TaPInAddr;
var
    phe  : PHostEnt;
    pptr : PaPInAddr;
    Buffer : array [0..63] of char;
    I    : Integer;
    GInitData      : TWSADATA;

begin
    WSAStartup($101, GInitData);
    Result := '';
    GetHostName(Buffer, SizeOf(Buffer));
    PCName := Buffer;
    phe :=GetHostByName(buffer);
    if phe = nil then Exit;
    pptr := PaPInAddr(Phe^.h_addr_list);
    I := 0;
    while pptr^[I] <> nil do begin
      result:=StrPas(inet_ntoa(pptr^[I]^));
      Inc(I);
    end;
    WSACleanup;
end;



 //Hide Taskbar Icon
{  ShowWindow( Application.Handle, SW_HIDE );
  SetWindowLong( Application.Handle, GWL_EXSTYLE,
                 GetWindowLong(Application.Handle, GWL_EXSTYLE) or
                 WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW);
  ShowWindow( Application.Handle, SW_SHOW );}



procedure TfrmSysInfo.FormShow(Sender: TObject);
begin
Label1.Caption:=LocalIP;
Label2.Caption:=PCName;
//Label3.Caption := 'Group '+IntToStr(MainForm.VRLocalPlayer.Group);

end;



procedure TfrmSysInfo.Button1Click(Sender: TObject);
begin
     close;
 //    MainForm.SystemInformation1.checked := false;

end;

procedure TfrmSysInfo.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key=VK_ESCAPE then
    Close;

end;

end.
 