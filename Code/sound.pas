unit sound;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,FMod,StrFunctions,
  cmpMidiData, cmpMidiPlayer, cmpTrackOutputs,cmpMidiIterator;

type
  TfrmSound = class(TDataModule)
    TrackOutputs1: TTrackOutputs;
    MidiPlayer1: TMidiPlayer;
    MidiData1: TMidiData;
    procedure FormDestroy(Sender: TObject);
    procedure MidiPlayer1Stop(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    DefSoundsList: TStringList;
    UserSoundList: TStringList;
    DirectSound: Boolean;
    MusicRepeat: Boolean;
    CurrentSong: String;
    procedure PlayWave(FileName: string);
    procedure PlayMP3(FileName: string; StopMidi, Loop: Boolean);
    procedure PlayMidi(FileName: string; MRepeat: Boolean);
    procedure PlayMusic(FileName: string; StopMidi: Boolean);
    procedure StopMP3;
    procedure StopMusic;

    procedure CloseMidiFile;
    procedure OpenMidiFile(const FileName : string);
    procedure Setup;

  end;

 function errorstring(errcode : FMOD_ERRORS) : string;

var
  frmSound: TfrmSound;
  fMidiPosition : TMidiPosition;
  mp3 : pFSOUND_STREAM;
  mdl: PFMUSIC_MODULE;

implementation

uses Main;

{$R *.DFM}

function errorstring(errcode : FMOD_ERRORS) : string;
begin
     case errcode of
          FMOD_ERR_NONE:		result:= 'No errors';
          FMOD_ERR_BUSY:		result:= 'Cannot call this command after FSOUND_Init.  Call FSOUND_Close first.';
          FMOD_ERR_UNINITIALIZED:	result:= 'This command failed because FSOUND_Init was not called';
          FMOD_ERR_PLAY:		result:= 'Playing the sound failed.';
          FMOD_ERR_INIT:		result:= 'Error initializing output device.';
          FMOD_ERR_ALLOCATED:		result:= 'The output device is already in use and cannot be reused.';
          FMOD_ERR_OUTPUT_FORMAT:	result:= 'Soundcard does not support the features needed for this soundsystem (16bit stereo output)';
          FMOD_ERR_COOPERATIVELEVEL:	result:= 'Error setting cooperative level for hardware.';
          FMOD_ERR_CREATEBUFFER:	result:= 'Error creating hardware sound buffer.';
          FMOD_ERR_FILE_NOTFOUND:	result:= 'File not found';
          FMOD_ERR_FILE_FORMAT:		result:= 'Unknown file format';
          FMOD_ERR_FILE_BAD:		result:= 'Error loading file';
          FMOD_ERR_MEMORY:		result:= 'Not enough memory ';
          FMOD_ERR_VERSION:		result:= 'The version number of this file format is not supported';
          FMOD_ERR_INVALID_MIXER:	result:= 'Incorrect mixer selected';
          FMOD_ERR_INVALID_PARAM:	result:= 'An invalid parameter was passed to this function';
          FMOD_ERR_NO_EAX:		result:= 'Tried to use an EAX command on a non EAX enabled channel or output.';
          FMOD_ERR_NO_EAX2:		result:= 'Tried to use an advanced EAX2 command on a non EAX2 enabled channel or output.';
          FMOD_ERR_CHANNEL_ALLOC:	result:= 'Failed to allocate a new channel';
          else				result:= 'Unknown error';
     end;
end;

procedure TfrmSound.FormDestroy(Sender: TObject);
var
I: integer;
begin
     try

        for i := 0 to DefSoundsList.Count -1 do
        FSOUND_Sample_Free(DefSoundsList.Objects[i]);

        DefSoundsList.clear;

        for i := 0 to UserSoundList.Count -1 do
        FSOUND_Sample_Free(UserSoundList.Objects[i]);

        UserSoundList.Clear;

     	FSOUND_Close();

     except
         on E: Exception do
         begin
//              Application.HandleException(E);
//              Application.Terminate;
         end;
     end;


end;

procedure TfrmSound.PlayWave(FileName: string);
begin

     if DefSoundsList.IndexOf(ExtractFileName(FileName)) <> -1 then
     begin
          FSOUND_PlaySound(FSOUND_FREE,DefSoundsList.objects[DefSoundsList.IndexOf(ExtractFileName(FileName))]);
          exit;
     end;

     if FileExists(fileName) then
     begin
        if UserSoundList.IndexOf(ExtractFileName(FileName)) <> -1 then
        begin
            FSOUND_PlaySound(FSOUND_FREE,UserSoundList.objects[UserSoundList.IndexOf(ExtractFileName(FileName))]);
        end
        else
           begin
                if UserSoundList.Count >= 20 then
                begin
                   FSOUND_Sample_Free(UserSoundList.Objects[0]);
                   UserSoundList.Delete(0);
                end;
                UserSoundList.Objects[UserSoundList.Add(ExtractFileName(FileName))] := FSOUND_Sample_LoadWav(FSOUND_FREE,pchar(fileName),FSOUND_Normal);
                FSOUND_PlaySound(FSOUND_FREE,UserSoundList.objects[UserSoundList.IndexOf(ExtractFileName(FileName))]);
           end;
     end;
end;

procedure TfrmSound.PlayMP3(FileName: string; StopMidi, Loop: Boolean);
begin
      StopMP3;
      
      if StopMidi and (LowerCase(StrTokenAt(CurrentSong,'.',1)) = 'mid') then
      begin
           MusicRepeat := false;
           CloseMidiFile;
           MidiPlayer1.Rewind;
      end;
      currentSong := ExtractFileName(fileName);


      if Loop then
         mp3 := FSOUND_Stream_OpenMpeg(pchar(FileName),FSOUND_LOOP_NORMAL)
      else
          mp3 := FSOUND_Stream_OpenMpeg(pchar(FileName),FSOUND_NORMAL);

      if mp3<>nil then
         FSOUND_Stream_Play(31,mp3);

end;

procedure TfrmSound.StopMP3;
begin
        if Assigned(mp3) then
        begin
             FSOUND_Stream_Stop(mp3);
             FSOUND_Stream_Close(mp3);
        end;

end;

procedure TfrmSound.PlayMusic(FileName: string; StopMidi: Boolean);
begin
      if StopMidi and (LowerCase(StrTokenAt(CurrentSong,'.',1)) = 'mid') then
      begin
           MusicRepeat := false;
           CloseMidiFile;
           MidiPlayer1.Rewind;
      end;

      CurrentSong := ExtractFileName(FileName);
      //MP3
      mdl := FMUSIC_LoadSong(Pchar(FileName));     {can be xm, s3m...}

      if mdl<>nil then
	FMUSIC_PlaySong(mdl);

end;

procedure TfrmSound.StopMusic;
begin
      if assigned(mdl) then
      begin
           FMUSIC_FreeSong(mdl);
           FMUSIC_StopSong(mdl);
      end;

end;


procedure TfrmSound.PlayMidi(FileName: string; MRepeat: Boolean);
begin
     MusicRepeat := false;
     CloseMidiFile;
     MidiPlayer1.Rewind;
     CurrentSong := ExtractFileName(FileName);
     OpenMidiFile(FileName);
     MidiData1.Active := true;
     TrackOutputs1.Active := true;
     MidiPlayer1.Play := true;

     if  FrmSound.MidiData1.Active then
         begin
              MidiPlayer1.Play := True;
              MusicRepeat := MRepeat;
         end;

end;

procedure TFrmSound.MidiPlayer1Stop(Sender: TObject);
begin
  if MusicRepeat then
  if MidiData1.Active then
  begin
    MidiPlayer1.Rewind;
    MidiPlayer1.Play := True
  end

end;

procedure TfrmSound.CloseMidiFile;
begin
  if LowerCase(StrTokenAt(CurrentSong,'.',1)) = 'mid' then
     begin
          MusicRepeat := false;
          MidiPlayer1.Stop;
          TrackOutputs1.Active := False;
          MidiData1.Active := False;
          CurrentSong := '';
     end;
end;

procedure TfrmSound.OpenMidiFile(const FileName : string);
begin
  CurrentSong := FileName;
  MidiData1.FileName := FileName;
  MidiData1.Active := True;
  TrackOutputs1.Active := True;
  fMidiPosition.Reset;
end;


procedure TfrmSound.Setup;
begin
     try
         if FMOD_VERSION > FSOUND_GetVersion then
         begin
              ShowMessage('Error : You are using the wrong DLL version!'  );
              exit;
         end;

        if DirectSound then
        begin
            if FSOUND_SetOutput(FSOUND_OUTPUT_DSOUND)=false then
               exit;
        end
        else
          begin
            if FSOUND_SetOutput(FSOUND_OUTPUT_WINMM)=false then
               exit;
            if FSOUND_SetDriver(0)=false then
               exit;
          end;

         if not FSOUND_Init(44100, 32, 0) then
         begin
              ShowMessage(errorstring(FSOUND_GetError()));
              FSOUND_Close();
              exit;
         end;

     except
     end;

     if FileExists(path+'sounds\connect.wav') then
        DefSoundsList.Objects[DefSoundsList.Add('connect.wav')] := FSOUND_Sample_LoadWav(FSOUND_FREE,pchar(path+'sounds\connect.wav'),FSOUND_Normal);
     if FileExists(path+'sounds\dice.wav') then
        DefSoundsList.Objects[DefSoundsList.Add('dice.wav')] := FSOUND_Sample_LoadWav(FSOUND_FREE,pchar(path+'sounds\dice.wav'),FSOUND_Normal);
     if FileExists(path+'sounds\disconnect.wav') then
        DefSoundsList.Objects[DefSoundsList.Add('disconnect.wav')] := FSOUND_Sample_LoadWav(FSOUND_FREE,pchar(path+'sounds\disconnect.wav'),FSOUND_Normal);
     if FileExists(path+'sounds\kick.wav') then
        DefSoundsList.Objects[DefSoundsList.Add('kick.wav')] := FSOUND_Sample_LoadWav(FSOUND_FREE,pchar(path+'sounds\kick.wav'),FSOUND_Normal);
     if FileExists(path+'sounds\lock.wav') then
        DefSoundsList.Objects[DefSoundsList.Add('lock.wav')] := FSOUND_Sample_LoadWav(FSOUND_FREE,pchar(path+'sounds\lock.wav'),FSOUND_Normal);
     if FileExists(path+'sounds\message.wav') then
        DefSoundsList.Objects[DefSoundsList.Add('message.wav')] := FSOUND_Sample_LoadWav(FSOUND_FREE,pchar(path+'sounds\message.wav'),FSOUND_Normal);
     if FileExists(path+'sounds\startup.wav') then
        DefSoundsList.Objects[DefSoundsList.Add('startup.wav')] := FSOUND_Sample_LoadWav(FSOUND_FREE,pchar(path+'sounds\startup.wav'),FSOUND_Normal);
     if FileExists(path+'sounds\unlock.wav') then
        DefSoundsList.Objects[DefSoundsList.Add('unlock.wav')] := FSOUND_Sample_LoadWav(FSOUND_FREE,pchar(path+'sounds\unlock.wav'),FSOUND_Normal);

      //midi
     Try
        fMidiPosition := TMidiPosition.Create (self);
        fMidiPosition.MidiData := FrmSound.MidiData1;

     except
     end;

end;

procedure TfrmSound.FormCreate(Sender: TObject);

begin
     DirectSound := false;
     DefSoundsList := TStringList.create;
     UserSoundList := TStringList.create;

end;


end.
