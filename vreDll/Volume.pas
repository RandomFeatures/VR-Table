unit Volume;

interface

uses
  Windows,  SysUtils, Controls, Forms,
  cmpMidiMixer, StdCtrls, Buttons, Wordcap, Classes, ComCtrls;

type
  TfrmVolume = class(TForm)
    MidiMixer1: TMidiMixer;
    GroupBox1: TGroupBox;
    tbLeftVolume: TTrackBar;
    tbRightVolume: TTrackBar;
    tbVolume: TTrackBar;
    tbPan: TTrackBar;
    Label3: TLabel;
    Label4: TLabel;
    GroupBox2: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    tbLeftGVolume: TTrackBar;
    tbRightGVolume: TTrackBar;
    tbGVolume: TTrackBar;
    tbGPan: TTrackBar;
    btnGMute: TSpeedButton;
    btnMute: TSpeedButton;
    tbTreble: TTrackBar;
    tbBass: TTrackBar;
    Label9: TLabel;
    Label10: TLabel;
    Button1: TButton;
    MSOfficeCaption1: TMSOfficeCaption;
    procedure FormShow(Sender: TObject);
    procedure tbLeftVolumeChange(Sender: TObject);
    procedure tbRightVolumeChange(Sender: TObject);
    procedure MidiMixer1ControlChange(sender: TObject;
      control: TMixerControlType);
    procedure tbVolumeChange(Sender: TObject);
    procedure tbLeftGVolumeChange(Sender: TObject);
    procedure tbRightGVolumeChange(Sender: TObject);
    procedure tbGVolumeChange(Sender: TObject);
    procedure btnGMuteClick(Sender: TObject);
    procedure btnMuteClick(Sender: TObject);
    procedure tbTrebleChange(Sender: TObject);
    procedure tbBassChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    function CalcPanAndVolume (l, r : Integer; var pan, volume : Integer) : boolean;
    procedure CalcLRFromPanAndVolume (pan, volume : Integer; var l, r : Integer);
  public
    { Public declarations }
  end;

var
  frmVolume: TfrmVolume;

implementation



{$R *.DFM}

function TfrmVolume.CalcPanAndVolume (l, r : Integer; var pan, volume : Integer) : boolean;
var
  panRange : Integer;
begin
  volume := l;
  panRange := (tbPan.Max - tbPan.Min) div 2;
  if r > volume then volume := r;
  result := volume <> 0;
  if result then
    pan := (r - l) * panRange div volume
  else
    pan := 0
end;

procedure TfrmVolume.CalcLRFromPanAndVolume (pan, volume : Integer; var l, r : Integer);
var
  panRange : Integer;
begin
  panRange := (tbPan.Max - tbPan.Min) div 2;
  if pan < 0 then
  begin
    l := volume;
    r := (pan + panRange) * volume div PanRange
  end
  else
  begin
    r := volume;
    l := (panRange - pan) * volume div panRange
  end
end;

procedure TfrmVolume.FormShow(Sender: TObject);
var
  lValue, rValue, min, max, pan, volume : Integer;
begin
  with MidiMixer1 do
  begin
    Active := True;
    if ControlSupported [mtMidiVolume] then
    begin
      max := ControlMax [mtMidiVolume];
      min := ControlMin [mtMidiVolume];
      lValue := ControlValue [mtMidiVolume, mcLeft];
      rValue := ControlValue [mtMidiVolume, mcRight];

      tbLeftVolume.Min := min;
      tbLeftVolume.Max := max;

      tbRightVolume.Min := min;
      tbRightVolume.Max := max;

      tbVolume.Min := min;
      tbVolume.Max := max;

      tbLeftVolume.Position := max - lValue;
      tbRightVolume.Position := max - rValue;
      CalcPanAndVolume (lValue, rValue, pan, volume);
      tbPan.Position := pan;
      tbVolume.Position := max - volume
    end
    else
    begin
      tbLeftVolume.Enabled := False;
      tbrightVolume.Enabled := False;
    end;

    if ControlSupported [mtAudioVolume] then
    begin
      max := ControlMax [mtAudioVolume];
      min := ControlMin [mtAudioVolume];
      lValue := ControlValue [mtAudioVolume, mcLeft];
      rValue := ControlValue [mtAudioVolume, mcRight];

      tbLeftGVolume.Min := min;
      tbLeftGVolume.Max := max;

      tbRightGVolume.Min := min;
      tbRightGVolume.Max := max;

      tbGVolume.Min := min;
      tbGVolume.Max := max;

      tbLeftGVolume.Position := max - lValue;
      tbRightGVolume.Position := max - rValue;
      CalcPanAndVolume (lValue, rValue, pan, volume);
      tbGPan.Position := pan;
      tbGVolume.Position := max - volume
    end
    else
    begin
      tbLeftGVolume.Enabled := False;
      tbrightGVolume.Enabled := False;
    end;

    if ControlSupported [mtAudioMute] then
      btnGMute.Down := ControlValue [mtAudioMute, mcLeft] <> ControlMin [mtAudioMute]
    else
      btnGMute.Enabled := False;

    if ControlSupported [mtMidiMute] then
      btnMute.Down := ControlValue [mtMidiMute, mcLeft] <> ControlMin [mtMidiMute]
    else
      btnMute.Enabled := False;

    if ControlSupported [mtAudioTreble] then
    begin
      tbTreble.Min := ControlMin [mtAudioTreble];
      max := ControlMax [mtAudioTreble];
      tbTreble.Max := max;
      tbTreble.Position := max - ControlValue [mtAudioTreble, mcLeft];
    end
    else
      tbTreble.Enabled := False;

    if ControlSupported [mtAudioBass] then
    begin              
      tbBass.Min := ControlMin [mtAudioBass];
      max := ControlMax [mtAudioBass];
      tbBass.Max := max;
      tbBass.Position := max - ControlValue [mtAudioBass, mcLeft];
    end
    else
      tbBass.Enabled := False;
  end
end;

procedure TfrmVolume.tbLeftVolumeChange(Sender: TObject);
begin
  with MidiMixer1 do
    ControlValue [mtMidiVolume, mcLeft] := ControlMax [mtMidiVolume] - tbLeftVolume.Position
end;

procedure TfrmVolume.tbRightVolumeChange(Sender: TObject);
begin
  with MidiMixer1 do
    ControlValue [mtMidiVolume, mcRight] := ControlMax [mtMidiVolume] - tbRightVolume.Position
end;

procedure TfrmVolume.MidiMixer1ControlChange(sender: TObject;
  control: TMixerControlType);
var
  lValue, rValue, max, min, pan, volume : Integer;
begin
  with MidiMixer1 do
  begin
    lValue := ControlValue [control, mcLeft];
    rValue := ControlValue [control, mcRight];
    max := ControlMax [control];
    min := ControlMin [control];

    case control of
      mtMidiVolume, mtAudioVolume :
        begin
          if CalcPanAndVolume (lValue, rValue, pan, volume) then
          case control of
            mtMidiVolume : tbPan.Position := pan;
            mtAudioVolume : tbGPan.Position := pan;
          end;

          case control of
            mtMidiVolume :
              begin
                tbLeftVolume.Position := max - lValue;
                tbRightVolume.Position := max - rValue;
                tbVolume.Position := max - volume
              end;
            mtAudioVolume :
              begin
                tbLeftGVolume.Position := max - lValue;
                tbRightGVolume.Position := max - rValue;
                tbGVolume.Position := max - volume
              end;
          end
        end;

      mtAudioMute : btnGMute.Down := lValue <> min;
      mtMidiMute  : btnMute.Down := lValue <> min;
      mtAudioTreble : tbTreble.Position := max - lValue;
      mtAudioBass   : tbBass.Position := max - lValue
    end
  end
end;

procedure TfrmVolume.tbVolumeChange(Sender: TObject);
var
  max, l, r : Integer;
  values : TChannelValues;
begin
  with MidiMixer1 do
  begin
    max := ControlMax [mtMidiVolume];
    CalcLRFromPanAndVolume (tbPan.Position, max - tbVolume.Position, l, r);
    values [mcLeft] := l;
    values [mcRight] := r;
    ControlValues [mtMidiVolume] := values
  end
end;

procedure TfrmVolume.tbLeftGVolumeChange(Sender: TObject);
begin
  with MidiMixer1 do
    ControlValue [mtAudioVolume, mcLeft] := ControlMax [mtAudioVolume] - tbLeftGVolume.Position
end;

procedure TfrmVolume.tbRightGVolumeChange(Sender: TObject);
begin
  with MidiMixer1 do
    ControlValue [mtAudioVolume, mcRight] := ControlMax [mtAudioVolume] - tbRightGVolume.Position
end;

procedure TfrmVolume.tbGVolumeChange(Sender: TObject);
var
  max, l, r : Integer;
  values : TChannelValues;
begin
  with MidiMixer1 do
  begin
    max := ControlMax [mtAudioVolume];
    CalcLRFromPanAndVolume (tbGPan.Position, max - tbGVolume.Position, l, r);
    values [mcLeft] := l;
    values [mcRight] := r;
    ControlValues [mtAudioVolume] := values
  end
end;

procedure TfrmVolume.btnGMuteClick(Sender: TObject);
begin
  with MidiMixer1 do
    case btnGMute.Down of
      False : ControlValue [mtAudioMute, mcLeft] := ControlMin [mtAudioMute];
      True  : ControlValue [mtAudioMute, mcLeft] := ControlMax [mtAudioMute]
    end
end;

procedure TfrmVolume.btnMuteClick(Sender: TObject);
begin
  with MidiMixer1 do
    case btnMute.Down of
      False : ControlValue [mtMidiMute, mcLeft] := ControlMin [mtMidiMute];
      True  : ControlValue [mtMidiMute, mcLeft] := ControlMax [mtMidiMute]
    end
end;

procedure TfrmVolume.tbTrebleChange(Sender: TObject);
var
  values : TChannelValues;
begin
  with MidiMixer1 do
  begin
    values [mcLeft] := ControlMax [mtAudioTreble] - tbTreble.Position;
    values [mcRight] := values [mcLeft];
    ControlValues [mtAudioTreble] := values
  end
end;

procedure TfrmVolume.tbBassChange(Sender: TObject);
var
  values : TChannelValues;
begin
  with MidiMixer1 do
  begin
    values [mcLeft] := ControlMax [mtAudioBass] - tbBass.Position;
    values [mcRight] := values [mcLeft];
    ControlValues [mtAudioBass] := values
  end
end;

procedure TfrmVolume.Button1Click(Sender: TObject);
begin
Close;
//MainForm.Volume1.checked := false;

end;

procedure TfrmVolume.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key=VK_ESCAPE then
    Close;

end;

end.
