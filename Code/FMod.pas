//==========================================================================================
// FMOD Main header file. Copyright (c), FireLight Multimedia 2000.
//==========================================================================================
// History
//
// 2000/11/13 by Steve 'Sly' Williams
// - Updated to version 3.22
// - PChar parameters changed to const PChar
// - Added FSOUND_PlaySound3DAttrib()
// - Added FSOUND_Stream_PlayAttrib()
//
// 2000/06/03 by Steve 'Sly' Williams
// - Re-formatted to standard code style.
// - Replaced pointers to single-byte structures with plain pointers.
//==========================================================================================

unit FMOD;

interface

uses
  Windows;

//===============================================================================================
//= FMOD DEFINED TYPES
//===============================================================================================

type
  PFSOUND_VECTOR = ^FSOUND_VECTOR;
  FSOUND_VECTOR = record
    x: Single;
    y: Single;
    z: Single;
  end;

  PFSOUND_SAMPLE = Pointer;
  PFSOUND_STREAM = Pointer;
  PFSOUND_DSPUNIT = Pointer;
  PFSOUND_MATERIAL = Pointer;
  PFSOUND_GEOMLIST = Pointer;
  PFMUSIC_MODULE = Pointer;

  PPointer = ^Pointer;
  PDWORD = ^DWORD;
  PULONG = ^ULONG;
  PSingle = ^Single;

  // callback types
  FSOUND_STREAMCALLBACK = procedure (Stream: PFSOUND_STREAM; Buff: Pointer; Length, Param: DWORD); cdecl;
  FSOUND_DSPCALLBACK = function (OriginalBuffer: Pointer; NewBuffer: Pointer; Length, Param: DWORD): Pointer; cdecl;
  FMUSIC_CALLBACK = procedure (mdl: PFMUSIC_MODULE; Param: Byte); cdecl;

  FSOUND_OPENCALLBACK = function (Name: PChar): ULONG; cdecl;
  FSOUND_CLOSECALLBACK = procedure (Handle: ULONG); cdecl;
  FSOUND_READCALLBACK = function (Buffer: Pointer; Size: DWORD; Handle: ULONG): DWORD; cdecl;
  FSOUND_SEEKCALLBACK = procedure (Handle: ULONG; Pos: DWORD; Mode: ByteBool); cdecl;
  FSOUND_TELLCALLBACK = function (Handle: ULONG): DWORD; cdecl;

  FMOD_ERRORS =
  (
    FMOD_ERR_NONE,                                      // No errors
    FMOD_ERR_BUSY,                                      // Cannot call this command after FSOUND_Init.  Call FSOUND_Close first.
    FMOD_ERR_UNINITIALIZED,                             // This command failed because FSOUND_Init was not called
    FMOD_ERR_INIT,                                      // Error initializing output device.
    FMOD_ERR_ALLOCATED,                                 // Error initializing output device, but more specifically, the output device is already in use and cannot be reused.
    FMOD_ERR_PLAY,                                      // Playing the sound failed.
    FMOD_ERR_OUTPUT_FORMAT,                             // Soundcard does not support the features needed for this soundsystem (16bit stereo output)
    FMOD_ERR_COOPERATIVELEVEL,                          // Error setting cooperative level for hardware.
    FMOD_ERR_CREATEBUFFER,                              // Error creating hardware sound buffer.
    FMOD_ERR_FILE_NOTFOUND,                             // File not found
    FMOD_ERR_FILE_FORMAT,                               // Unknown file format
    FMOD_ERR_FILE_BAD,                                  // Error loading file
    FMOD_ERR_MEMORY,                                    // Not enough memory
    FMOD_ERR_VERSION,                                   // The version number of this file format is not supported
    FMOD_ERR_INVALID_MIXER,                             // Incorrect mixer selected
    FMOD_ERR_INVALID_PARAM,                             // An invalid parameter was passed to this function
    FMOD_ERR_NO_EAX,                                    // Tried to use an EAX command on a non EAX enabled channel or output.
    FMOD_ERR_NO_EAX2,                                   // Tried to use an advanced EAX2 command on a non EAX2 enabled channel or output.
    FMOD_ERR_CHANNEL_ALLOC,                             // Failed to allocate a new channel
    FMOD_ERR_RECORD                                     // Recording is not supported on this machine
  );

  //  These output types are used with FSOUND_SetOutput, to choose which output driver to use.
  //
  //  FSOUND_OUTPUT_A3D will cause FSOUND_Init to FAIL if you have not got a vortex
  //  based A3D card.  The suggestion for this is to immediately try and reinitialize FMOD with
  //  FSOUND_OUTPUT_DSOUND, and if this fails, try initializing FMOD with FSOUND_OUTPUT_WAVEOUT.
  //
  //  FSOUND_OUTPUT_DSOUND will not support hardware 3d acceleration if the sound card driver
  //  does not support DirectX 6 Voice Manager Extensions.
  FSOUND_OUTPUTTYPES =
  (
    FSOUND_OUTPUT_NOSOUND,                              // NoSound driver, all calls to this succeed but do nothing.
    FSOUND_OUTPUT_WINMM,                                // Windows Multimedia driver.
    FSOUND_OUTPUT_DSOUND,                               // DirectSound driver.  You need this to get EAX or EAX2 support.
    FSOUND_OUTPUT_A3D                                   // A3D driver.  You need this to get geometry and EAX reverb support.
  );

  //  These mixer types are used with FSOUND_SetMixer, to choose which mixer to use, or to act
  //  upon for other reasons using FSOUND_GetMixer.
  FSOUND_MIXERTYPES =
  (
    FSOUND_MIXER_AUTODETECT,                            // This enables autodetection of the fastest mixer based on your cpu.
    FSOUND_MIXER_BLENDMODE,                             // This enables the standard non mmx, blendmode mixer.
    FSOUND_MIXER_MMXP5,                                 // This enables the mmx, pentium optimized blendmode mixer.
    FSOUND_MIXER_MMXP6,                                 // This enables the mmx, ppro/p2/p3 optimized mixer.

    FSOUND_MIXER_QUALITY_AUTODETECT,                    // This enables autodetection of the fastest quality mixer based on your cpu.
    FSOUND_MIXER_QUALITY_FPU,                           // This enables the interpolating FPU mixer.
    FSOUND_MIXER_QUALITY_MMXP5,                         // This enables the interpolating p5 MMX mixer.
    FSOUND_MIXER_QUALITY_MMXP6,                         // This enables the interpolating ppro/p2/p3 MMX mixer.
    FSOUND_MIXER_QUALITY_FPU_VOLUMERAMP                 // Enables the interpolating 'de-clicking' FPU mixer.
  );

  //  These definitions describe the type of song being played.
  FMUSIC_TYPES =
  (
    FMUSIC_TYPE_NONE,
    FMUSIC_TYPE_MOD,                                    // Protracker / Fasttracker
    FMUSIC_TYPE_S3M,                                    // ScreamTracker 3
    FMUSIC_TYPE_XM,                                     // FastTracker 2
    FMUSIC_TYPE_IT                                      // Impulse Tracker.
  );

  // These are environment types defined for use with the FSOUND_Reverb API.
  FSOUND_REVERB_ENVIRONMENTS =
  (
    FSOUND_ENVIRONMENT_GENERIC,
    FSOUND_ENVIRONMENT_PADDEDCELL,
    FSOUND_ENVIRONMENT_ROOM,
    FSOUND_ENVIRONMENT_BATHROOM,
    FSOUND_ENVIRONMENT_LIVINGROOM,
    FSOUND_ENVIRONMENT_STONEROOM,
    FSOUND_ENVIRONMENT_AUDITORIUM,
    FSOUND_ENVIRONMENT_CONCERTHALL,
    FSOUND_ENVIRONMENT_CAVE,
    FSOUND_ENVIRONMENT_ARENA,
    FSOUND_ENVIRONMENT_HANGAR,
    FSOUND_ENVIRONMENT_CARPETEDHALLWAY,
    FSOUND_ENVIRONMENT_HALLWAY,
    FSOUND_ENVIRONMENT_STONECORRIDOR,
    FSOUND_ENVIRONMENT_ALLEY,
    FSOUND_ENVIRONMENT_FOREST,
    FSOUND_ENVIRONMENT_CITY,
    FSOUND_ENVIRONMENT_MOUNTAINS,
    FSOUND_ENVIRONMENT_QUARRY,
    FSOUND_ENVIRONMENT_PLAIN,
    FSOUND_ENVIRONMENT_PARKINGLOT,
    FSOUND_ENVIRONMENT_SEWERPIPE,
    FSOUND_ENVIRONMENT_UNDERWATER,
    FSOUND_ENVIRONMENT_DRUGGED,
    FSOUND_ENVIRONMENT_DIZZY,
    FSOUND_ENVIRONMENT_PSYCHOTIC,

    FSOUND_ENVIRONMENT_COUNT
  );

const
  FMOD_VERSION  = 3.22;

  // DSP unit priorities for system units.
  // Use FSOUND_DSP_DEFAULTPRIORITY_USER to put DSP effects in.
  FSOUND_DSP_DEFAULTPRIORITY_CLEARUNIT        = 0;      // DSP CLEAR unit - done first
  FSOUND_DSP_DEFAULTPRIORITY_SFXUNIT          = 100;    // DSP SFX unit - done second
  FSOUND_DSP_DEFAULTPRIORITY_MUSICUNIT        = 200;    // DSP MUSIC unit - done third
  FSOUND_DSP_DEFAULTPRIORITY_USER             = 300;    // User priority, use this as reference
  FSOUND_DSP_DEFAULTPRIORITY_CLIPANDCOPYUNIT  = 1000;   // DSP CLIP AND COPY unit - last

  //  Driver description bitfields.  Use FSOUND_Driver_GetCaps to determine if a driver enumerated
  //  has the settings you are after.  The enumerated driver depends on the output mode, see
  //  FSOUND_OUTPUTTYPES
  FSOUND_CAPS_HARDWARE              = $1;               // This driver supports hardware accelerated 3d sound.
  FSOUND_CAPS_EAX                   = $2;               // This driver supports EAX reverb
  FSOUND_CAPS_GEOMETRY_OCCLUSIONS   = $4;               // This driver supports (A3D) geometry occlusions
  FSOUND_CAPS_GEOMETRY_REFLECTIONS  = $8;               // This driver supports (A3D) geometry reflections
  FSOUND_CAPS_EAX2                  = $10;              // This driver supports EAX2/A3D3 reverb

  //  Sample description bitfields, OR them together for loading and describing samples.
  FSOUND_LOOP_OFF     = $01;                            // For non looping samples.
  FSOUND_LOOP_NORMAL  = $02;                            // For forward looping samples.
  FSOUND_LOOP_BIDI    = $04;                            // For bidirectional looping samples.  (no effect if in hardware).
  FSOUND_8BITS        = $08;                            // For 8 bit samples.
  FSOUND_16BITS       = $10;                            // For 16 bit samples.
  FSOUND_MONO         = $20;                            // For mono samples.
  FSOUND_STEREO       = $40;                            // For stereo samples.
  FSOUND_UNSIGNED     = $80;                            // For source data containing unsigned samples.
  FSOUND_SIGNED       = $100;                           // For source data containing signed data.
  FSOUND_DELTA        = $200;                           // For source data stored as delta values.
  FSOUND_IT214        = $400;                           // For source data stored using IT214 compression.
  FSOUND_IT215        = $800;                           // For source data stored using IT215 compression.
  FSOUND_HW3D         = $1000;                          // Attempts to make samples use 3d hardware acceleration. (if the card supports it)
  FSOUND_2D           = $2000;                          // Ignores any 3d processing.  overrides FSOUND_HW3D.  Located in software.
  FSOUND_STREAMABLE   = $4000;                          // For realtime streamable samples.  If you dont supply this sound may come out corrupted.

  FSOUND_NORMAL       = $29;                            // (FSOUND_LOOP_OFF + FSOUND_8BITS + FSOUND_MONO)

  // Playback method for a CD Audio track, using FSOUND_CD_Play
  FSOUND_CD_PLAYCONTINUOUS  = 0;                        // Starts from the current track and plays to end of CD.
  FSOUND_CD_PLAYONCE        = 1;                        // Plays the specified track then stops.
  FSOUND_CD_PLAYLOOPED      = 2;                        // Plays the specified track looped, forever until stopped manually.
  FSOUND_CD_PLAYRANDOM      = 3;                        // Plays tracks in random order

  // Miscellaneous values for FMOD functions.
  FSOUND_FREE       = $FFFFFFFF;                        // value to play on any free channel, or to allocate a sample in a free sample slot.
  FSOUND_UNMANAGED  = $FFFFFFFE;                        // value to allocate a sample that is NOT managed by FSOUND or placed in a sample slot.
  FSOUND_STEREOPAN  = $FFFFFFFF;                        // value for FSOUND_SetPan so that stereo sounds are not played at half volume.  See FSOUND_SetPan for more on this.
  FSOUND_REVERBMIX_USEDISTANCE =  -1.0;                 // used with FSOUND_Reverb_SetMix to attenuate reverb by distance automatically
  FSOUND_REVERB_IGNOREPARAM = $FF676981;                // used with FSOUND_Reverb_SetEnvironment or FSOUND_Reverb_SetEnvironmentAdvanced to ignore parameters.

  // A set of predefined environment PARAMETERS, created by Creative Labs
  // These can be placed directly into the FSOUND_Reverb_SetEnvironment call (in the C version)
{
  FSOUND_PRESET_GENERIC         = FSOUND_ENVIRONMENT_GENERIC,0.5,   1.493,  0.5;
  FSOUND_PRESET_PADDEDCELL      = FSOUND_ENVIRONMENT_PADDEDCELL,0.25,  0.1,    0.0;
  FSOUND_PRESET_ROOM            = FSOUND_ENVIRONMENT_ROOM,0.417, 0.4,    0.666;
  FSOUND_PRESET_BATHROOM        = FSOUND_ENVIRONMENT_BATHROOM,0.653, 1.499,  0.166;
  FSOUND_PRESET_LIVINGROOM      = FSOUND_ENVIRONMENT_LIVINGROOM,0.208, 0.478,  0.0;
  FSOUND_PRESET_STONEROOM       = FSOUND_ENVIRONMENT_STONEROOM,0.5,   2.309,  0.888;
  FSOUND_PRESET_AUDITORIUM      = FSOUND_ENVIRONMENT_AUDITORIUM,0.403, 4.279,  0.5;
  FSOUND_PRESET_CONCERTHALL     = FSOUND_ENVIRONMENT_CONCERTHALL,0.5,   3.961,  0.5;
  FSOUND_PRESET_CAVE            = FSOUND_ENVIRONMENT_CAVE,0.5,   2.886,  1.304;
  FSOUND_PRESET_ARENA           = FSOUND_ENVIRONMENT_ARENA,0.361, 7.284,  0.332;
  FSOUND_PRESET_HANGAR          = FSOUND_ENVIRONMENT_HANGAR,0.5,   10.0,   0.3;
  FSOUND_PRESET_CARPETEDHALLWAY = FSOUND_ENVIRONMENT_CARPETEDHALLWAY,0.153, 0.259,  2.0;
  FSOUND_PRESET_HALLWAY         = FSOUND_ENVIRONMENT_HALLWAY,0.361, 1.493,  0.0;
  FSOUND_PRESET_STONECORRIDOR   = FSOUND_ENVIRONMENT_STONECORRIDOR,0.444, 2.697,  0.638;
  FSOUND_PRESET_ALLEY           = FSOUND_ENVIRONMENT_ALLEY,0.25,  1.752,  0.776;
  FSOUND_PRESET_FOREST          = FSOUND_ENVIRONMENT_FOREST,0.111, 3.145,  0.472;
  FSOUND_PRESET_CITY            = FSOUND_ENVIRONMENT_CITY,0.111, 2.767,  0.224;
  FSOUND_PRESET_MOUNTAINS       = FSOUND_ENVIRONMENT_MOUNTAINS,0.194, 7.841,  0.472;
  FSOUND_PRESET_QUARRY          = FSOUND_ENVIRONMENT_QUARRY,1.0,   1.499,  0.5;
  FSOUND_PRESET_PLAIN           = FSOUND_ENVIRONMENT_PLAIN,0.097, 2.767,  0.224;
  FSOUND_PRESET_PARKINGLOT      = FSOUND_ENVIRONMENT_PARKINGLOT,0.208, 1.652,  1.5;
  FSOUND_PRESET_SEWERPIPE       = FSOUND_ENVIRONMENT_SEWERPIPE,0.652, 2.886,  0.25;
  FSOUND_PRESET_UNDERWATER      = FSOUND_ENVIRONMENT_UNDERWATER,1.0,   1.499,  0.0;
  FSOUND_PRESET_DRUGGED         = FSOUND_ENVIRONMENT_DRUGGED,0.875, 8.392,  1.388;
  FSOUND_PRESET_DIZZY           = FSOUND_ENVIRONMENT_DIZZY,0.139, 17.234, 0.666;
  FSOUND_PRESET_PSYCHOTIC       = FSOUND_ENVIRONMENT_PSYCHOTIC,0.486, 7.563,  0.806;
}
  // Geometry flags, used as the mode flag in FSOUND_Geometry_AddPolygon
  FSOUND_GEOMETRY_NORMAL            = $0;               // Default geometry type.  Occluding polygon
  FSOUND_GEOMETRY_REFLECTIVE        = $01;              // This polygon is reflective
  FSOUND_GEOMETRY_OPENING           = $02;              // Overlays a transparency over the previous polygon.  The 'openingfactor' value supplied is copied internally.
  FSOUND_GEOMETRY_OPENING_REFERENCE = $04;              // Overlays a transparency over the previous polygon.  The 'openingfactor' supplied is pointed to (for access when building a list)

//===============================================================================================
//= function PROTOTYPES
//===============================================================================================

// ==================================
// Initialization / Global functions.
// ==================================

// Pre FSOUND_Init functions. These can't be called after FSOUND_Init is called (they will fail)
function FSOUND_SetOutput(OutputType: FSOUND_OUTPUTTYPES): ByteBool; stdcall;
function FSOUND_SetDriver(Driver: DWORD): ByteBool; stdcall;
function FSOUND_SetMixer(Mixer: FSOUND_MIXERTYPES): ByteBool; stdcall;
function FSOUND_SetBufferSize(Len_ms: DWORD): ByteBool; stdcall;
function FSOUND_SetHWND(HWnd: Pointer): ByteBool; stdcall;
function FSOUND_SetMinHardwareChannels(Min: DWORD): ByteBool; stdcall;
function FSOUND_SetMaxHardwareChannels(Max: DWORD): ByteBool; stdcall;

// Main initialization / closedown functions
function FSOUND_Init(MixRate, MaxChannels, VcmMode: DWORD): ByteBool; stdcall;
procedure FSOUND_Close; stdcall;

// Runtime
procedure FSOUND_SetSFXMasterVolume(Volume: DWORD); stdcall;
procedure FSOUND_SetPanSeperation(PanSep: Single); stdcall;

// Error functions
function FSOUND_GetError: FMOD_ERRORS; stdcall;

// ===================================
// Sample management / load functions.
// ===================================

// File functions
function FSOUND_Sample_LoadWav(Index: DWORD; const Filename: PChar; Mode: ULONG): PFSOUND_SAMPLE; stdcall;
function FSOUND_Sample_LoadMpeg(Index: DWORD; const Filename: PChar; Mode: ULONG): PFSOUND_SAMPLE; stdcall;
function FSOUND_Sample_LoadRaw(Index: DWORD; const Filename: PChar; Mode: ULONG): PFSOUND_SAMPLE; stdcall;
function FSOUND_Sample_LoadWavMemory(Index: DWORD; Data: Pointer; Mode: ULONG; Length: DWORD): PFSOUND_SAMPLE; stdcall;
function FSOUND_Sample_LoadMpegMemory(Index: DWORD; Data: Pointer; Mode: ULONG; Length: DWORD): PFSOUND_SAMPLE; stdcall;

// Sample management functions
function FSOUND_Sample_Alloc(Index, Length: DWORD; Mode: ULONG; DefFreq, DefVol, DefPan, DefPri: DWORD): PFSOUND_SAMPLE; stdcall;
procedure FSOUND_Sample_Free(SPtr: PFSOUND_SAMPLE); stdcall;
function FSOUND_Sample_Upload(SPtr: PFSOUND_SAMPLE; SrcData: Pointer; Mode: ULONG): ByteBool; stdcall;
function FSOUND_Sample_Lock(SPtr: PFSOUND_SAMPLE; Offset, Length: DWORD; Ptr1, Ptr2: PPointer; Len1, Len2: PULONG): ByteBool; stdcall;
function FSOUND_Sample_Unlock(SPtr: PFSOUND_SAMPLE; Ptr1, Ptr2: Pointer; Len1, Len2: DWORD): ByteBool; stdcall;

// Sample control functions
function FSOUND_Sample_SetLoopMode(SPtr: PFSOUND_SAMPLE; LoopMode: ULONG): ByteBool; stdcall;
function FSOUND_Sample_SetLoopPoints(SPtr: PFSOUND_SAMPLE; LoopStart, LoopEnd: DWORD): ByteBool; stdcall;
function FSOUND_Sample_SetDefaults(SPtr: PFSOUND_SAMPLE; DefFreq, DefVol, DefPan, DefPri: DWORD): ByteBool; stdcall;
function FSOUND_Sample_SetMinMaxDistance(SPtr: PFSOUND_SAMPLE; Min, Max: Single): ByteBool; stdcall;

// ============================
// Channel control functions.
// ============================

// Playing and stopping sounds.
function FSOUND_PlaySound(Channel: DWORD; SPtr: PFSOUND_SAMPLE): DWORD; stdcall;
function FSOUND_PlaySoundAttrib(Channel: DWORD; SPtr: PFSOUND_SAMPLE; Freq, Vol, Pan: DWORD): DWORD; stdcall;
function FSOUND_PlaySound3DAttrib(Channel: DWORD; SPtr: PFSOUND_SAMPLE; Freq, Vol, Pan: DWORD; Pos, Vel: PFSOUND_VECTOR): DWORD; stdcall;
function FSOUND_3D_PlaySound(Channel: DWORD; SPtr: PFSOUND_SAMPLE; Pos: PFSOUND_VECTOR; Vel: PFSOUND_VECTOR): DWORD; stdcall;

function FSOUND_StopSound(Channel: DWORD): ByteBool; stdcall;
procedure FSOUND_StopAllChannels; stdcall;

// functions to control playback of a channel.
function FSOUND_SetFrequency(Channel: DWORD; Freq: DWORD): ByteBool; stdcall;
function FSOUND_SetVolume(Channel: DWORD; Vol: DWORD): ByteBool; stdcall;
function FSOUND_SetVolumeAbsolute(Channel: DWORD; Vol: DWORD): ByteBool; stdcall;
function FSOUND_SetPan(Channel: DWORD; Pan: DWORD): ByteBool; stdcall;
function FSOUND_SetSurround(Channel: DWORD; Surround: ByteBool): ByteBool; stdcall;
function FSOUND_SetMute(Channel: DWORD; Mute: ByteBool): ByteBool; stdcall;
function FSOUND_SetPriority(Channel: DWORD; Priority: DWORD): ByteBool; stdcall;
function FSOUND_SetReserved(Channel: DWORD; Reserved: ByteBool): ByteBool; stdcall;
function FSOUND_SetPaused(Channel: DWORD; Paused: ByteBool): ByteBool; stdcall;
function FSOUND_MixBuffers(DestBuffer, SrcBuffer: Pointer; Len, Freq, Vol, Pan: DWORD; Mode: ULONG): ByteBool; stdcall;

// ================================
// Information retrieval functions.
// ================================

// System information
function FSOUND_GetVersion: Single; stdcall;
function FSOUND_GetOutput: FSOUND_OUTPUTTYPES; stdcall;
function FSOUND_GetDriver: DWORD; stdcall;
function FSOUND_GetMixer: FSOUND_MIXERTYPES; stdcall;
function FSOUND_GetNumDrivers: DWORD; stdcall;
function FSOUND_GetDriverName(Id: DWORD): PChar; stdcall;
function FSOUND_GetDriverCaps(Id: DWORD; Caps: PULONG): ByteBool; stdcall;

function FSOUND_GetOutputRate: DWORD; stdcall;
function FSOUND_GetMaxChannels: DWORD; stdcall;
function FSOUND_GetMaxSamples: DWORD; stdcall;
function FSOUND_GetSFXMasterVolume: DWORD; stdcall;
function FSOUND_GetNumHardwareChannels: DWORD; stdcall;
function FSOUND_GetChannelsPlaying: DWORD; stdcall;
function FSOUND_GetCPUUsage: Single; stdcall;

// Channel information
function FSOUND_IsPlaying(Channel: DWORD): ByteBool; stdcall;
function FSOUND_GetFrequency(Channel: DWORD): DWORD; stdcall;
function FSOUND_GetVolume(Channel: DWORD): DWORD; stdcall;
function FSOUND_GetPan(Channel: DWORD): DWORD; stdcall;
function FSOUND_GetSurround(Channel: DWORD): ByteBool; stdcall;
function FSOUND_GetMute(Channel: DWORD): ByteBool; stdcall;
function FSOUND_GetPriority(Channel: DWORD): DWORD; stdcall;
function FSOUND_GetReserved(Channel: DWORD): ByteBool; stdcall;
function FSOUND_GetPaused(Channel: DWORD): ByteBool; stdcall;
function FSOUND_GetCurrentPosition(Channel: DWORD): ULONG; stdcall;
function FSOUND_GetCurrentSample(Channel: DWORD): PFSOUND_SAMPLE; stdcall;
function FSOUND_GetCurrentVU(Channel: DWORD): Single; stdcall;

// Sample information
function FSOUND_Sample_Get(sampno: DWORD): PFSOUND_SAMPLE; stdcall;
function FSOUND_Sample_GetLength(sptr: PFSOUND_SAMPLE): ULONG; stdcall;
function FSOUND_Sample_GetLoopPoints(sptr: PFSOUND_SAMPLE; loopstart, loopend: PDWORD): ByteBool; stdcall;
function FSOUND_Sample_GetDefaults(sptr: PFSOUND_SAMPLE; deffreq, defvol, defpan, defpri: PDWORD): ByteBool; stdcall;
function FSOUND_Sample_GetMode(sptr: PFSOUND_SAMPLE): ULONG; stdcall;

// ===================
// 3D sound functions.
// ===================
// see also FSOUND_3D_PlaySound (above)
// see also FSOUND_Sample_SetMinMaxDistance (above)
procedure FSOUND_3D_Update; stdcall;
function FSOUND_3D_SetAttributes(Channel: DWORD; pos, vel: PFSOUND_VECTOR): ByteBool; stdcall;
function FSOUND_3D_GetAttributes(Channel: DWORD; pos, vel: PFSOUND_VECTOR): ByteBool; stdcall;
procedure FSOUND_3D_Listener_SetAttributes(pos, vel: PFSOUND_VECTOR; fx, fy, fz, tx, ty, tz: Single); stdcall;
procedure FSOUND_3D_Listener_GetAttributes(pos, vel: PFSOUND_VECTOR; fx, fy, fz, tx, ty, tz: PSingle); stdcall;
procedure FSOUND_3D_Listener_SetDopplerFactor(scale: Single); stdcall;
procedure FSOUND_3D_Listener_SetDistanceFactor(scale: Single); stdcall;
procedure FSOUND_3D_Listener_SetRolloffFactor(scale: Single); stdcall;

// ===================
// Geometry functions.
// ===================

// scene/polygon functions
function FSOUND_Geometry_AddPolygon(p1,p2,p3,p4,normal: PFSOUND_VECTOR; mode: ULONG; openingfactor: PSingle): ByteBool; stdcall;
function FSOUND_Geometry_AddList(geomlist: PFSOUND_GEOMLIST): DWORD; stdcall;

// polygon list functions
function FSOUND_Geometry_List_Create(boundingvolume: ByteBool): PFSOUND_GEOMLIST; stdcall;
function FSOUND_Geometry_List_Free(geomlist: PFSOUND_GEOMLIST): ByteBool; stdcall;
function FSOUND_Geometry_List_Begin(geomlist: PFSOUND_GEOMLIST): ByteBool; stdcall;
function FSOUND_Geometry_List_End(geomlist: PFSOUND_GEOMLIST): ByteBool; stdcall;
function FSOUND_Geometry_List_Add(geomlist: PFSOUND_GEOMLIST): ByteBool; stdcall;

// material functions
function FSOUND_Geometry_Material_Create: PFSOUND_MATERIAL; stdcall;
function FSOUND_Geometry_Material_Free(material: PFSOUND_MATERIAL): ByteBool; stdcall;
function FSOUND_Geometry_Material_SetAttributes(material: PFSOUND_MATERIAL; reflectancegain, reflectancefreq, transmittancegain, transmittancefreq: Single): ByteBool; stdcall;
function FSOUND_Geometry_Material_GetAttributes(material: PFSOUND_MATERIAL; reflectancegain, reflectancefreq, transmittancegain, transmittancefreq: PSingle): ByteBool; stdcall;
function FSOUND_Geometry_Material_Set(material: PFSOUND_MATERIAL): ByteBool; stdcall;

// occlusion (supported in software, eax, eax2, a3d3)
function FSOUND_Geometry_SetOcclusionFactor(factor: Single): ByteBool; stdcall;

// ==============================================
// Reverb functions. (eax, eax2, a3d 3.0 reverb)
// ==============================================

// eax1, eax2, a3d 3.0 (use FSOUND_REVERB_PRESETS if you like), (eax2 support through emulation/parameter conversion)
function FSOUND_Reverb_SetEnvironment(env: FSOUND_REVERB_ENVIRONMENTS; vol, decay, damp: Single): ByteBool; stdcall;
// eax2, a3d 3.0 only, does not work on eax1
function FSOUND_Reverb_SetEnvironmentAdvanced(
        env: FSOUND_REVERB_ENVIRONMENTS;
        Room: DWORD;                                  // [-10000, 0]     default: -10000 mB
        RoomHF: DWORD;                                // [-10000, 0]     default: 0 mB
        RoomRolloffFactor: Single;                    // [0.0, 10.0]     default: 0.0
        DecayTime: Single;                            // [0.1, 20.0]     default: 1.0 s
        DecayHFRatio: Single;                         // [0.1, 2.0]      default: 0.5
        Reflections: DWORD;                           // [-10000, 1000]  default: -10000 mB
        ReflectionsDelay: Single;                     // [0.0, 0.3]      default: 0.02 s
        Reverb: DWORD;                                // [-10000, 2000]  default: -10000 mB
        ReverbDelay: Single;                          // [0.0, 0.1]      default: 0.04 s
        EnvironmentSize: Single;                      // [0.0, 100.0]    default: 100.0 %
        EnvironmentDiffusion: Single;                 // [0.0, 100.0]    default: 100.0 %
        AirAbsorptionHF: Single): ByteBool; stdcall;  // [20.0, 20000.0] default: 5000.0 Hz

function FSOUND_Reverb_SetMix(Channel: DWORD; mix: Single): ByteBool; stdcall;

// information functions
function FSOUND_Reverb_GetEnvironment(env: PDWORD; vol, decay, damp: PSingle): ByteBool; stdcall;
function FSOUND_Reverb_GetEnvironmentAdvanced(
        env: PDWORD;
        Room: PDWORD;
        RoomHF: PDWORD;
        RoomRolloffFactor: PSingle;
        DecayTime: PSingle;
        DecayHFRatio: PSingle;
        Reflections: PDWORD;
        ReflectionsDelay: PSingle;
        Reverb: PDWORD;
        ReverbDelay: PSingle;
        EnvironmentSize: PSingle;
        EnvironmentDiffusion: PSingle;
        AirAbsorptionHF: PSingle): ByteBool; stdcall;
function FSOUND_Reverb_GetMix(Channel: DWORD; mix: PSingle): ByteBool; stdcall;

// =========================
// File Streaming functions.
// =========================

function FSOUND_Stream_Create(callback: FSOUND_STREAMCALLBACK; length: DWORD; mode: ULONG; samplerate, userdata: DWORD): PFSOUND_STREAM; stdcall;
function FSOUND_Stream_Open(const filename: PChar; mode: ULONG; samplerate: DWORD): PFSOUND_STREAM; stdcall;
function FSOUND_Stream_OpenWav(const filename: PChar; mode: ULONG): PFSOUND_STREAM; stdcall;
function FSOUND_Stream_OpenMpeg(const filename: PChar; mode: ULONG): PFSOUND_STREAM; stdcall;
function FSOUND_Stream_Play(Channel: DWORD; Stream: PFSOUND_STREAM): DWORD; stdcall;
function FSOUND_Stream_PlayAttrib(Channel: DWORD; Stream: PFSOUND_STREAM; Freq, Vol, Pan: DWORD; Pos, Vel: PFSOUND_VECTOR): DWORD; stdcall;
function FSOUND_Stream_Stop(stream: PFSOUND_STREAM): ByteBool; stdcall;
function FSOUND_Stream_Close(stream: PFSOUND_STREAM): ByteBool; stdcall;

function FSOUND_Stream_SetPaused(stream: PFSOUND_STREAM; paused: ByteBool): ByteBool; stdcall;
function FSOUND_Stream_GetPaused(stream: PFSOUND_STREAM): ByteBool; stdcall;
function FSOUND_Stream_SetPosition(stream: PFSOUND_STREAM; position: DWORD): ByteBool; stdcall;
function FSOUND_Stream_GetPosition(stream: PFSOUND_STREAM): DWORD; stdcall;
function FSOUND_Stream_GetTime(stream: PFSOUND_STREAM): DWORD; stdcall;
function FSOUND_Stream_GetLength(stream: PFSOUND_STREAM): DWORD; stdcall;

// ===================
// CD audio functions.
// ===================

function FSOUND_CD_Play(track: DWORD): ByteBool; stdcall;
procedure FSOUND_CD_SetPlayMode(mode: ByteBool); stdcall;
function FSOUND_CD_Stop: ByteBool; stdcall;
function FSOUND_CD_SetPaused(paused: ByteBool): ByteBool; stdcall;
function FSOUND_CD_GetPaused: ByteBool; stdcall;
function FSOUND_CD_GetTrack: DWORD; stdcall;
function FSOUND_CD_GetNumTracks: DWORD; stdcall;
function FSOUND_CD_Eject: ByteBool; stdcall;

// ==============
// DSP functions.
// ==============

// DSP Unit control and information functions.
function FSOUND_DSP_Create(callback:FSOUND_DSPCALLBACK; priority, param: DWORD): PFSOUND_DSPUNIT; stdcall;
procedure FSOUND_DSP_Free(unt: PFSOUND_DSPUNIT); stdcall;

procedure FSOUND_DSP_SetPriority(unt: PFSOUND_DSPUNIT; priority: DWORD); stdcall;
function FSOUND_DSP_GetPriority(unt: PFSOUND_DSPUNIT): DWORD; stdcall;

procedure FSOUND_DSP_SetActive(unt: PFSOUND_DSPUNIT; active: ByteBool); stdcall;
function FSOUND_DSP_GetActive(unt: PFSOUND_DSPUNIT): ByteBool; stdcall;

// functions to get hold of FSOUND 'system DSP unit' handles.
function FSOUND_DSP_GetClearUnit: PFSOUND_DSPUNIT; stdcall;
function FSOUND_DSP_GetSFXUnit: PFSOUND_DSPUNIT; stdcall;
function FSOUND_DSP_GetMusicUnit: PFSOUND_DSPUNIT; stdcall;
function FSOUND_DSP_GetClipAndCopyUnit: PFSOUND_DSPUNIT; stdcall;

// misc DSP functions
procedure FSOUND_DSP_ClearMixBuffer; stdcall;
function FSOUND_DSP_GetBufferLength: DWORD; stdcall;

// =========================
// Recording functions
// =========================

// recording initialization
function FSOUND_Record_SetDriver(outputtype: DWORD): ByteBool; stdcall;

// information functions.
function FSOUND_Record_GetCaps(modes: PULONG): ByteBool; stdcall;
function FSOUND_Record_GetNumDrivers: DWORD; stdcall;
function FSOUND_Record_GetDriverName(id: DWORD): PChar; stdcall;
function FSOUND_Record_GetDriver: DWORD; stdcall;

// recording functionality.  Only one recording session will work at a time
function FSOUND_Record_StartSample(sptr: PFSOUND_SAMPLE; loop: ByteBool): ByteBool; stdcall;
function FSOUND_Record_Stop: ByteBool; stdcall;
function FSOUND_Record_GetPosition: DWORD; stdcall;

// =========================
// File system override
// =========================

procedure FSOUND_File_SetCallbacks(
        OpenCallback: FSOUND_OPENCALLBACK;
        CloseCallback: FSOUND_CLOSECALLBACK;
        ReadCallback: FSOUND_READCALLBACK;
        SeekCallback: FSOUND_SEEKCALLBACK;
        TellCallback: FSOUND_TELLCALLBACK); stdcall;

// =============================================================================================
// FMUSIC API
// =============================================================================================

// Song management / playback functions.
// =====================================
function FMUSIC_LoadSong(const name: PChar): PFMUSIC_MODULE; stdcall;
function FMUSIC_LoadSongMemory(data: Pointer; length: DWORD): PFMUSIC_MODULE; stdcall;
function FMUSIC_FreeSong(mdl: PFMUSIC_MODULE): ByteBool; stdcall;
function FMUSIC_PlaySong(mdl: PFMUSIC_MODULE): ByteBool; stdcall;
function FMUSIC_StopSong(mdl: PFMUSIC_MODULE): ByteBool; stdcall;
procedure FMUSIC_StopAllSongs; stdcall;
function FMUSIC_SetZxxCallback(mdl: PFMUSIC_MODULE; callback: FMUSIC_CALLBACK): ByteBool; stdcall;
function FMUSIC_SetRowCallback(mdl: PFMUSIC_MODULE; callback: FMUSIC_CALLBACK; rowstep:DWORD): ByteBool; stdcall;
function FMUSIC_SetOrderCallback(mdl: PFMUSIC_MODULE; callback: FMUSIC_CALLBACK; orderstep:DWORD): ByteBool; stdcall;
function FMUSIC_OptimizeChannels(mdl: PFMUSIC_MODULE; maxchannels, minvolume: DWORD): ByteBool; stdcall;


// Runtime song functions.
// =======================
function FMUSIC_SetOrder(mdl: PFMUSIC_MODULE; order: DWORD): ByteBool; stdcall;
function FMUSIC_SetPaused(mdl: PFMUSIC_MODULE; pause: ByteBool): ByteBool; stdcall;
function FMUSIC_SetMasterVolume(mdl: PFMUSIC_MODULE; volume: DWORD): ByteBool; stdcall;
function FMUSIC_SetPanSeperation(mdl: PFMUSIC_MODULE; pansep: Single): ByteBool; stdcall;

// Static song information functions.
// ==================================
function FMUSIC_GetName(mdl: PFMUSIC_MODULE): PChar; stdcall;
function FMUSIC_GetType(mdl: PFMUSIC_MODULE): FMUSIC_TYPES; stdcall;
function FMUSIC_UsesLinearFrequencies(mdl: PFMUSIC_MODULE): ByteBool; stdcall;
function FMUSIC_GetNumOrders(mdl: PFMUSIC_MODULE): DWORD; stdcall;
function FMUSIC_GetNumPatterns(mdl: PFMUSIC_MODULE): DWORD; stdcall;
function FMUSIC_GetNumInstruments(mdl: PFMUSIC_MODULE): DWORD; stdcall;
function FMUSIC_GetNumSamples(mdl: PFMUSIC_MODULE): DWORD; stdcall;
function FMUSIC_GetNumChannels(mdl: PFMUSIC_MODULE): DWORD; stdcall;
function FMUSIC_GetSample(mdl: PFMUSIC_MODULE; sampno: DWORD): PFSOUND_SAMPLE; stdcall;
function FMUSIC_GetPatternLength(mdl: PFMUSIC_MODULE; orderno: DWORD): DWORD; stdcall;

// Runtime song information.
// =========================
function FMUSIC_IsFinished(mdl: PFMUSIC_MODULE): ByteBool; stdcall;
function FMUSIC_IsPlaying(mdl: PFMUSIC_MODULE): ByteBool; stdcall;
function FMUSIC_GetMasterVolume(mdl: PFMUSIC_MODULE): DWORD; stdcall;
function FMUSIC_GetGlobalVolume(mdl: PFMUSIC_MODULE): DWORD; stdcall;
function FMUSIC_GetOrder(mdl: PFMUSIC_MODULE): DWORD; stdcall;
function FMUSIC_GetPattern(mdl: PFMUSIC_MODULE): DWORD; stdcall;
function FMUSIC_GetSpeed(mdl: PFMUSIC_MODULE): DWORD; stdcall;
function FMUSIC_GetBPM(mdl: PFMUSIC_MODULE): DWORD; stdcall;
function FMUSIC_GetRow(mdl: PFMUSIC_MODULE): DWORD; stdcall;
function FMUSIC_GetPaused(mdl: PFMUSIC_MODULE): ByteBool; stdcall;
function FMUSIC_GetTime(mdl: PFMUSIC_MODULE): ULONG; stdcall;

implementation

const
  FMOD_DLL = 'fmod.dll';

// ==================================
// Initialization / Global functions.
// ==================================

// Pre FSOUND_Init functions. These can't be called after FSOUND_Init is called (they will fail)
function FSOUND_SetOutput(OutputType: FSOUND_OUTPUTTYPES): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_SetOutput@4';
function FSOUND_SetDriver(Driver: DWORD): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_SetDriver@4';
function FSOUND_SetMixer(Mixer: FSOUND_MIXERTYPES): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_SetMixer@4';
function FSOUND_SetBufferSize(Len_ms: DWORD): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_SetBufferSize@4';
function FSOUND_SetHWND(HWnd: Pointer): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_SetHWND@4';
function FSOUND_SetMinHardwareChannels(Min: DWORD): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_SetMinHardwareChannels@4'
function FSOUND_SetMaxHardwareChannels(Max: DWORD): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_SetMaxHardwareChannels@4'

// Main initialization / closedown functions
function FSOUND_Init(MixRate, MaxChannels, VcmMode: DWORD): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Init@12';
procedure FSOUND_Close; stdcall; external FMOD_DLL name '_FSOUND_Close@0';

// Runtime
procedure FSOUND_SetSFXMasterVolume(Volume: DWORD); stdcall; external FMOD_DLL name '_FSOUND_SetSFXMasterVolume@4';
procedure FSOUND_SetPanSeperation(PanSep: Single); stdcall; external FMOD_DLL name '_FSOUND_SetPanSeperation@4';

// Error functions
function FSOUND_GetError: FMOD_ERRORS; stdcall; external FMOD_DLL name '_FSOUND_GetError@0';

// ===================================
// Sample management / load functions.
// ===================================

// File functions
function FSOUND_Sample_LoadWav(index: DWORD; const filename: PChar; mode: ULONG): PFSOUND_SAMPLE; stdcall; external FMOD_DLL name '_FSOUND_Sample_LoadWav@12';
function FSOUND_Sample_LoadMpeg(index: DWORD; const filename: PChar; mode: ULONG): PFSOUND_SAMPLE; stdcall; external FMOD_DLL name '_FSOUND_Sample_LoadMpeg@12';
function FSOUND_Sample_LoadRaw(index: DWORD; const filename: PChar; mode: ULONG): PFSOUND_SAMPLE; stdcall; external FMOD_DLL name '_FSOUND_Sample_LoadRaw@12';
function FSOUND_Sample_LoadWavMemory(index: DWORD; data: Pointer; mode: ULONG; length: DWORD): PFSOUND_SAMPLE; stdcall; external FMOD_DLL name '_FSOUND_Sample_LoadWavMemory@16';
function FSOUND_Sample_LoadMpegMemory(index: DWORD; data: Pointer; mode: ULONG; length: DWORD): PFSOUND_SAMPLE; stdcall; external FMOD_DLL name '_FSOUND_Sample_LoadMpegMemory@16';

// Sample management functions
function FSOUND_Sample_Alloc(index, length: DWORD; mode: ULONG; deffreq, defvol, defpan, defpri: DWORD): PFSOUND_SAMPLE; stdcall; external FMOD_DLL name '_FSOUND_Sample_Alloc@28';
procedure FSOUND_Sample_Free(sptr: PFSOUND_SAMPLE); stdcall; external FMOD_DLL name '_FSOUND_Sample_Free@4';
function FSOUND_Sample_Upload(sptr: PFSOUND_SAMPLE; srcdata: Pointer; mode: ULONG): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Sample_Upload@12';
function FSOUND_Sample_Lock(sptr: PFSOUND_SAMPLE; offset, length: DWORD; ptr1, ptr2: PPointer; len1, len2: PULONG): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Sample_Lock@28';
function FSOUND_Sample_Unlock(sptr: PFSOUND_SAMPLE; ptr1, ptr2: Pointer; len1, len2: DWORD): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Sample_Unlock@20';

// Sample control functions
function FSOUND_Sample_SetLoopMode(sptr: PFSOUND_SAMPLE; loopmode: ULONG): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Sample_SetLoopMode@8';
function FSOUND_Sample_SetLoopPoints(sptr: PFSOUND_SAMPLE; loopstart, loopend: DWORD): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Sample_SetLoopPoints@12';
function FSOUND_Sample_SetDefaults(sptr: PFSOUND_SAMPLE; deffreq, defvol, defpan, defpri: DWORD): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Sample_SetDefaults@20';
//procedure FSOUND_Sample_UseMulaw(mulaw: ByteBool); stdcall; external FMOD_DLL name '_FSOUND_Sample_UseMulaw@4';
function FSOUND_Sample_SetMinMaxDistance(sptr: PFSOUND_SAMPLE; min, max: Single): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Sample_SetMinMaxDistance@12';

// ============================
// Channel control functions.
// ============================

// Playing and stopping sounds.
function FSOUND_PlaySound(Channel: DWORD; sptr: PFSOUND_SAMPLE): DWORD; stdcall; external FMOD_DLL name '_FSOUND_PlaySound@8';
function FSOUND_PlaySoundAttrib(Channel: DWORD; sptr: PFSOUND_SAMPLE; freq, vol, pan: DWORD): DWORD; stdcall; external FMOD_DLL name '_FSOUND_PlaySoundAttrib@20';
function FSOUND_PlaySound3DAttrib(Channel: DWORD; SPtr: PFSOUND_STREAM; Freq, Vol, Pan: DWORD; Pos, Vel: PFSOUND_VECTOR): DWORD; stdcall; external FMOD_DLL name '_FSOUND_PlaySound3DAttrib@28';
function FSOUND_3D_PlaySound(Channel: DWORD; sptr: PFSOUND_SAMPLE; pos:PFSOUND_VECTOR; vel:PFSOUND_VECTOR): DWORD; stdcall; external FMOD_DLL name '_FSOUND_3D_PlaySound@16';
function FSOUND_StopSound(Channel: DWORD): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_StopSound@4';
procedure FSOUND_StopAllChannels; stdcall; external FMOD_DLL name '_FSOUND_StopAllChannels@0';

// functions to control playback of a channel.
function FSOUND_SetFrequency(Channel: DWORD; freq: DWORD): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_SetFrequency@8';
function FSOUND_SetVolume(Channel: DWORD; vol: DWORD): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_SetVolume@8';
function FSOUND_SetVolumeAbsolute(Channel: DWORD; vol: DWORD): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_SetVolumeAbsolute@8';
function FSOUND_SetPan(Channel: DWORD; pan: DWORD): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_SetPan@8';
function FSOUND_SetSurround(Channel: DWORD; surround: ByteBool): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_SetSurround@8';
function FSOUND_SetMute(Channel: DWORD; mute: ByteBool): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_SetMute@8';
function FSOUND_SetPriority(Channel: DWORD; priority: DWORD): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_SetPriority@8';
function FSOUND_SetReserved(Channel: DWORD; reserved: ByteBool): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_SetReserved@8';
function FSOUND_SetPaused(Channel: DWORD; paused: ByteBool): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_SetPaused@8';
function FSOUND_MixBuffers(destbuffer, srcbuffer: Pointer; len, freq, vol, pan: DWORD; mode: ULONG): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_MixBuffers@28';

// ================================
// Information retrieval functions.
// ================================

// System information
function FSOUND_GetVersion: Single; stdcall; external FMOD_DLL name '_FSOUND_GetVersion@0';
function FSOUND_GetOutput: FSOUND_OUTPUTTYPES; stdcall; external FMOD_DLL name '_FSOUND_GetOutput@0';
function FSOUND_GetDriver: DWORD; stdcall; external FMOD_DLL name '_FSOUND_GetDriver@0';
function FSOUND_GetMixer: FSOUND_MIXERTYPES; stdcall; external FMOD_DLL name '_FSOUND_GetMixer@0';
function FSOUND_GetNumDrivers: DWORD; stdcall; external FMOD_DLL name '_FSOUND_GetNumDrivers@0';
function FSOUND_GetDriverName(id: DWORD): PChar; stdcall; external FMOD_DLL name '_FSOUND_GetDriverName@4';
function FSOUND_GetDriverCaps(id: DWORD; caps: PULONG): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_GetDriverCaps@8';

function FSOUND_GetOutputRate: DWORD; stdcall; external FMOD_DLL name '_FSOUND_GetOutputRate@0';
function FSOUND_GetMaxChannels: DWORD; stdcall; external FMOD_DLL name '_FSOUND_GetMaxChannels@0';
function FSOUND_GetMaxSamples: DWORD; stdcall; external FMOD_DLL name '_FSOUND_GetMaxSamples@0';
function FSOUND_GetSFXMasterVolume: DWORD; stdcall; external FMOD_DLL name '_FSOUND_GetSFXMasterVolume@0';
function FSOUND_GetNumHardwareChannels: DWORD; stdcall; external FMOD_DLL name '_FSOUND_GetNumHardwareChannels@0';
function FSOUND_GetChannelsPlaying: DWORD; stdcall; external FMOD_DLL name '_FSOUND_GetChannelsPlaying@0';
function FSOUND_GetCPUUsage: Single; stdcall; external FMOD_DLL name '_FSOUND_GetCPUUsage@0';

// Channel information
function FSOUND_IsPlaying(Channel: DWORD): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_IsPlaying@4';
function FSOUND_GetFrequency(Channel: DWORD): DWORD; stdcall; external FMOD_DLL name '_FSOUND_GetFrequency@4';
function FSOUND_GetVolume(Channel: DWORD): DWORD; stdcall; external FMOD_DLL name '_FSOUND_GetVolume@4';
function FSOUND_GetPan(Channel: DWORD): DWORD; stdcall; external FMOD_DLL name '_FSOUND_GetPan@4';
function FSOUND_GetSurround(Channel: DWORD): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_GetSurround@4';
function FSOUND_GetMute(Channel: DWORD): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_GetMute@4';
function FSOUND_GetPriority(Channel: DWORD): DWORD; stdcall; external FMOD_DLL name '_FSOUND_GetPriority@4';
function FSOUND_GetReserved(Channel: DWORD): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_GetReserved@4';
function FSOUND_GetPaused(Channel: DWORD): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_GetPaused@4';
function FSOUND_GetCurrentPosition(Channel: DWORD): ULONG; stdcall; external FMOD_DLL name '_FSOUND_GetCurrentPosition@4';
function FSOUND_GetCurrentSample(Channel: DWORD): PFSOUND_SAMPLE; stdcall; external FMOD_DLL name '_FSOUND_GetCurrentSample@4';
function FSOUND_GetCurrentVU(Channel: DWORD): Single; stdcall; external FMOD_DLL name '_FSOUND_GetCurrentVU@4';

// Sample information
function FSOUND_Sample_Get(sampno: DWORD): PFSOUND_SAMPLE; stdcall; external FMOD_DLL name '_FSOUND_Sample_Get@4';
function FSOUND_Sample_GetLength(sptr: PFSOUND_SAMPLE): ULONG; stdcall; external FMOD_DLL name '_FSOUND_Sample_GetLength@4';
function FSOUND_Sample_GetLoopPoints(sptr: PFSOUND_SAMPLE; loopstart, loopend: PDWORD): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Sample_GetLoopPoints@12';
function FSOUND_Sample_GetDefaults(sptr: PFSOUND_SAMPLE; deffreq, defvol, defpan, defpri: PDWORD): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Sample_GetDefaults@20';
function FSOUND_Sample_GetMode(sptr: PFSOUND_SAMPLE): ULONG; stdcall; external FMOD_DLL name '_FSOUND_Sample_GetMode@4';
//function FSOUND_Sample_IsUsingMulaw: ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Sample_IsUsingMulaw@0';

// ===================
// 3D sound functions.
// ===================
// see also FSOUND_3D_PlaySound (above)
// see also FSOUND_Sample_SetMinMaxDistance (above)
procedure FSOUND_3D_Update; stdcall; external FMOD_DLL name '_FSOUND_3D_Update@0';
function FSOUND_3D_SetAttributes(Channel: DWORD; pos, vel: PFSOUND_VECTOR): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_3D_SetAttributes@12';
function FSOUND_3D_GetAttributes(Channel: DWORD; pos, vel: PFSOUND_VECTOR): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_3D_GetAttributes@12';
procedure FSOUND_3D_Listener_SetAttributes(pos, vel: PFSOUND_VECTOR; fx, fy, fz, tx, ty, tz: Single); stdcall; external FMOD_DLL name '_FSOUND_3D_Listener_SetAttributes@32';
procedure FSOUND_3D_Listener_GetAttributes(pos, vel: PFSOUND_VECTOR; fx, fy, fz, tx, ty, tz: PSingle); stdcall; external FMOD_DLL name '_FSOUND_3D_Listener_GetAttributes@32';
procedure FSOUND_3D_Listener_SetDopplerFactor(scale: Single); stdcall; external FMOD_DLL name '_FSOUND_3D_Listener_SetDopplerFactor@4';
procedure FSOUND_3D_Listener_SetDistanceFactor(scale: Single); stdcall; external FMOD_DLL name '_FSOUND_3D_Listener_SetDistanceFactor@4';
procedure FSOUND_3D_Listener_SetRolloffFactor(scale: Single); stdcall; external FMOD_DLL name '_FSOUND_3D_Listener_SetRolloffFactor@4';

// ===================
// Geometry functions.
// ===================

// scene/polygon functions
function FSOUND_Geometry_AddPolygon(p1, p2, p3, p4, normal: PFSOUND_VECTOR; mode: ULONG; openingfactor: PSingle): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Geometry_AddPolygon@28';
function FSOUND_Geometry_AddList(geomlist: PFSOUND_GEOMLIST): DWORD; stdcall; external FMOD_DLL name '_FSOUND_Geometry_AddList@4';

// polygon list functions
function FSOUND_Geometry_List_Create(boundingvolume: ByteBool): PFSOUND_GEOMLIST; stdcall; external FMOD_DLL name '_FSOUND_Geometry_List_Create@4';
function FSOUND_Geometry_List_Free(geomlist: PFSOUND_GEOMLIST): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Geometry_List_Free@4';
function FSOUND_Geometry_List_Begin(geomlist: PFSOUND_GEOMLIST): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Geometry_List_Begin@4';
function FSOUND_Geometry_List_End(geomlist: PFSOUND_GEOMLIST): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Geometry_List_End@4';
function FSOUND_Geometry_List_Add(geomlist: PFSOUND_GEOMLIST): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Geometry_List_Add@4';

// material functions
function FSOUND_Geometry_Material_Create: PFSOUND_MATERIAL; stdcall; external FMOD_DLL name '_FSOUND_Geometry_Material_Create@0';
function FSOUND_Geometry_Material_Free(material: PFSOUND_MATERIAL): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Geometry_Material_Free@4';
function FSOUND_Geometry_Material_SetAttributes(material: PFSOUND_MATERIAL; reflectancegain, reflectancefreq, transmittancegain, transmittancefreq: Single): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Geometry_Material_SetAttributes@20';
function FSOUND_Geometry_Material_GetAttributes(material: PFSOUND_MATERIAL; reflectancegain, reflectancefreq, transmittancegain, transmittancefreq: PSingle): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Geometry_Material_GetAttributes@20';
function FSOUND_Geometry_Material_Set(material: PFSOUND_MATERIAL): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Geometry_Material_Set@4';

// occlusion (supported in software, eax, eax2, a3d3)
function FSOUND_Geometry_SetOcclusionFactor(factor: Single): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Geometry_SetOcclusionFactor@4';

// ==============================================
// Reverb functions. (eax, eax2, a3d 3.0 reverb)
// ==============================================

// eax1, eax2, a3d 3.0 (use FSOUND_REVERB_PRESETS if you like), (eax2 support through emulation/parameter conversion)
function FSOUND_Reverb_SetEnvironment(env: FSOUND_REVERB_ENVIRONMENTS; vol, decay, damp: Single): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Reverb_SetEnvironment@16';
// eax2, a3d 3.0 only, does not work on eax1
function FSOUND_Reverb_SetEnvironmentAdvanced(
        env: FSOUND_REVERB_ENVIRONMENTS;
        Room: DWORD;          // [-10000, 0]     default: -10000 mB
        RoomHF: DWORD;          // [-10000, 0]     default: 0 mB
        RoomRolloffFactor: Single;    // [0.0, 10.0]     default: 0.0
        DecayTime: Single;        // [0.1, 20.0]     default: 1.0 s
        DecayHFRatio: Single;     // [0.1, 2.0]      default: 0.5
        Reflections: DWORD;     // [-10000, 1000]  default: -10000 mB
        ReflectionsDelay: Single;   // [0.0, 0.3]      default: 0.02 s
        Reverb: DWORD;          // [-10000, 2000]  default: -10000 mB
        ReverbDelay: Single;      // [0.0, 0.1]      default: 0.04 s
        EnvironmentSize: Single;    // [0.0, 100.0]    default: 100.0 %
        EnvironmentDiffusion: Single; // [0.0, 100.0]    default: 100.0 %
        AirAbsorptionHF: Single):   // [20.0, 20000.0] default: 5000.0 Hz
          ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Reverb_SetEnvironmentAdvanced@52';

function FSOUND_Reverb_SetMix(Channel: DWORD; Mix: Single): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Reverb_SetMix@8';

// information functions
function FSOUND_Reverb_GetEnvironment(Env: PDWORD; Vol, Decay, Damp: PSingle): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Reverb_GetEnvironment@16';
function FSOUND_Reverb_GetEnvironmentAdvanced(
        Env: PDWORD;
        Room: PDWORD;
        RoomHF: PDWORD;
        RoomRolloffFactor: PSingle;
        DecayTime: PSingle;
        DecayHFRatio: PSingle;
        Reflections: PDWORD;
        ReflectionsDelay: PSingle;
        Reverb: PDWORD;
        ReverbDelay: PSingle;
        EnvironmentSize: PSingle;
        EnvironmentDiffusion: PSingle;
        AirAbsorptionHF: PSingle): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Reverb_GetEnvironmentAdvanced@52';
function FSOUND_Reverb_GetMix(Channel: DWORD; mix: PSingle): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Reverb_GetMix@8';

// =========================
// File Streaming functions.
// =========================

function FSOUND_Stream_Create(callback: FSOUND_STREAMCALLBACK; length: DWORD; mode: ULONG; samplerate, userdata: DWORD): PFSOUND_STREAM; stdcall; external FMOD_DLL name '_FSOUND_Stream_Create@20';
function FSOUND_Stream_Open(const filename: PChar; mode: ULONG; samplerate: DWORD): PFSOUND_STREAM; stdcall; external FMOD_DLL name '_FSOUND_Stream_Open@12';
function FSOUND_Stream_OpenWav(const filename: PChar; mode: ULONG): PFSOUND_STREAM; stdcall; external FMOD_DLL name '_FSOUND_Stream_OpenWav@8';
function FSOUND_Stream_OpenMpeg(const filename: PChar; mode: ULONG): PFSOUND_STREAM; stdcall; external FMOD_DLL name '_FSOUND_Stream_OpenMpeg@8';
function FSOUND_Stream_Play(Channel: DWORD; stream: PFSOUND_STREAM): DWORD; stdcall; external FMOD_DLL name '_FSOUND_Stream_Play@8';
function FSOUND_Stream_PlayAttrib(Channel: DWORD; Stream: PFSOUND_STREAM; Freq, Vol, Pan: DWORD; Pos, Vel: PFSOUND_VECTOR): DWORD; stdcall; external FMOD_DLL name '_FSOUND_Stream_PlayAttrib@28';
function FSOUND_Stream_Stop(stream: PFSOUND_STREAM): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Stream_Stop@4';
function FSOUND_Stream_Close(stream: PFSOUND_STREAM): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Stream_Close@4';

function FSOUND_Stream_SetPaused(stream: PFSOUND_STREAM; paused: ByteBool): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Stream_SetPaused@8';
function FSOUND_Stream_GetPaused(stream: PFSOUND_STREAM): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Stream_GetPaused@4';
function FSOUND_Stream_SetPosition(stream: PFSOUND_STREAM; position: DWORD): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Stream_SetPosition@8';
function FSOUND_Stream_GetPosition(stream: PFSOUND_STREAM): DWORD; stdcall; external FMOD_DLL name '_FSOUND_Stream_GetPosition@4';
function FSOUND_Stream_GetTime(stream: PFSOUND_STREAM): DWORD; stdcall; external FMOD_DLL name '_FSOUND_Stream_GetTime@4';
function FSOUND_Stream_GetLength(stream: PFSOUND_STREAM): DWORD; stdcall; external FMOD_DLL name '_FSOUND_Stream_GetLength@4';

// ===================
// CD audio functions.
// ===================

function FSOUND_CD_Play(track: DWORD): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_CD_Play@4';
procedure FSOUND_CD_SetPlayMode(mode: ByteBool); stdcall; external FMOD_DLL name '_FSOUND_CD_SetPlayMode@4';
function FSOUND_CD_Stop: ByteBool; stdcall; external FMOD_DLL name '_FSOUND_CD_Stop@0';
function FSOUND_CD_SetPaused(paused: ByteBool): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_CD_SetPaused@4';
function FSOUND_CD_GetPaused: ByteBool; stdcall; external FMOD_DLL name '_FSOUND_CD_GetPaused@0';
function FSOUND_CD_GetTrack: DWORD; stdcall; external FMOD_DLL name '_FSOUND_CD_GetTrack@0';
function FSOUND_CD_GetNumTracks: DWORD; stdcall; external FMOD_DLL name '_FSOUND_CD_GetNumTracks@0';
function FSOUND_CD_Eject: ByteBool; stdcall; external FMOD_DLL name '_FSOUND_CD_Eject@0';

// ==============
// DSP functions.
// ==============

// DSP Unit control and information functions.
function FSOUND_DSP_Create(callback:FSOUND_DSPCALLBACK; priority, param: DWORD): PFSOUND_DSPUNIT; stdcall; external FMOD_DLL name '_FSOUND_DSP_Create@12';
procedure FSOUND_DSP_Free(unt: PFSOUND_DSPUNIT); stdcall; external FMOD_DLL name '_FSOUND_DSP_Free@4';

procedure FSOUND_DSP_SetPriority(unt: PFSOUND_DSPUNIT; priority: DWORD); stdcall; external FMOD_DLL name '_FSOUND_DSP_SetPriority@8';
function FSOUND_DSP_GetPriority(unt: PFSOUND_DSPUNIT): DWORD; stdcall; external FMOD_DLL name '_FSOUND_DSP_GetPriority@4';

procedure FSOUND_DSP_SetActive(unt: PFSOUND_DSPUNIT; active: ByteBool); stdcall; external FMOD_DLL name '_FSOUND_DSP_SetActive@8';
function FSOUND_DSP_GetActive(unt: PFSOUND_DSPUNIT): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_DSP_GetActive@4';

// functions to get hold of FSOUND 'system DSP unit' handles.
function FSOUND_DSP_GetClearUnit: PFSOUND_DSPUNIT; stdcall; external FMOD_DLL name '_FSOUND_DSP_GetClearUnit@0';
function FSOUND_DSP_GetSFXUnit: PFSOUND_DSPUNIT; stdcall; external FMOD_DLL name '_FSOUND_DSP_GetSFXUnit@0';
function FSOUND_DSP_GetMusicUnit: PFSOUND_DSPUNIT; stdcall; external FMOD_DLL name '_FSOUND_DSP_GetMusicUnit@0';
function FSOUND_DSP_GetClipAndCopyUnit: PFSOUND_DSPUNIT; stdcall; external FMOD_DLL name '_FSOUND_DSP_GetClipAndCopyUnit@0';

// misc DSP functions
procedure FSOUND_DSP_ClearMixBuffer; stdcall; external FMOD_DLL name '_FSOUND_DSP_ClearMixBuffer@0';
function FSOUND_DSP_GetBufferLength: DWORD; stdcall; external FMOD_DLL name '_FSOUND_DSP_GetBufferLength@0';

// =========================
// Recording functions
// =========================

// recording initialization
function FSOUND_Record_SetDriver(outputtype: DWORD): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Record_SetDriver@4';

// information functions.
function FSOUND_Record_GetCaps(modes: PULONG): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Record_GetCaps@4';
function FSOUND_Record_GetNumDrivers: DWORD; stdcall; external FMOD_DLL name '_FSOUND_Record_GetNumDrivers@0';
function FSOUND_Record_GetDriverName(id: DWORD): PChar; stdcall; external FMOD_DLL name '_FSOUND_Record_GetDriverName@4';
function FSOUND_Record_GetDriver: DWORD; stdcall; external FMOD_DLL name '_FSOUND_Record_GetDriver@0';

// recording functionality.  Only one recording session will work at a time
function FSOUND_Record_StartSample(sptr: PFSOUND_SAMPLE; loop: ByteBool): ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Record_StartSample@8';
function FSOUND_Record_Stop: ByteBool; stdcall; external FMOD_DLL name '_FSOUND_Record_Stop@0';
function FSOUND_Record_GetPosition: DWORD; stdcall; external FMOD_DLL name '_FSOUND_Record_GetPosition@0';

// =========================
// File system override
// =========================

procedure FSOUND_File_SetCallbacks(OpenCallback: FSOUND_OPENCALLBACK;
                                   CloseCallback: FSOUND_CLOSECALLBACK;
                                   ReadCallback: FSOUND_READCALLBACK;
                                   SeekCallback: FSOUND_SEEKCALLBACK;
                                   TellCallback: FSOUND_TELLCALLBACK); stdcall; external FMOD_DLL name '_FSOUND_File_SetCallbacks@20';

// =============================================================================================
// FMUSIC API
// =============================================================================================

// Song management / playback functions.
// =====================================
function FMUSIC_LoadSong(const name: PChar): PFMUSIC_MODULE; stdcall; external FMOD_DLL name '_FMUSIC_LoadSong@4';
function FMUSIC_LoadSongMemory(data: Pointer; length: DWORD): PFMUSIC_MODULE; stdcall; external FMOD_DLL name '_FMUSIC_LoadSongMemory@8';
function FMUSIC_FreeSong(mdl: PFMUSIC_MODULE): ByteBool; stdcall; external FMOD_DLL name '_FMUSIC_FreeSong@4';
function FMUSIC_PlaySong(mdl: PFMUSIC_MODULE): ByteBool; stdcall; external FMOD_DLL name '_FMUSIC_PlaySong@4';
function FMUSIC_StopSong(mdl: PFMUSIC_MODULE): ByteBool; stdcall; external FMOD_DLL name '_FMUSIC_StopSong@4';
procedure FMUSIC_StopAllSongs; stdcall; external FMOD_DLL name '_FMUSIC_StopAllSongs@0';
function FMUSIC_SetZxxCallback(mdl: PFMUSIC_MODULE; callback: FMUSIC_CALLBACK): ByteBool; stdcall; external FMOD_DLL name '_FMUSIC_SetZxxCallback@8';
function FMUSIC_SetRowCallback(mdl: PFMUSIC_MODULE; callback: FMUSIC_CALLBACK; rowstep:DWORD): ByteBool; stdcall; external FMOD_DLL name '_FMUSIC_SetRowCallback@12';
function FMUSIC_SetOrderCallback(mdl: PFMUSIC_MODULE; callback: FMUSIC_CALLBACK; orderstep:DWORD): ByteBool; stdcall; external FMOD_DLL name '_FMUSIC_SetOrderCallback@12';

function FMUSIC_OptimizeChannels(mdl: PFMUSIC_MODULE; maxchannels, minvolume: DWORD): ByteBool; stdcall; external FMOD_DLL name '_FMUSIC_OptimizeChannels@12';

// Runtime song functions.
// =======================
function FMUSIC_SetOrder(mdl: PFMUSIC_MODULE; order: DWORD): ByteBool; stdcall; external FMOD_DLL name '_FMUSIC_SetOrder@8';
function FMUSIC_SetPaused(mdl: PFMUSIC_MODULE; pause: ByteBool): ByteBool; stdcall; external FMOD_DLL name '_FMUSIC_SetPaused@8';
function FMUSIC_SetMasterVolume(mdl: PFMUSIC_MODULE; volume: DWORD): ByteBool; stdcall; external FMOD_DLL name '_FMUSIC_SetMasterVolume@8';
function FMUSIC_SetPanSeperation(mdl: PFMUSIC_MODULE; pansep: Single): ByteBool; stdcall; external FMOD_DLL name '_FMUSIC_SetPanSeperation@8';

// Static song information functions.
// ==================================
function FMUSIC_GetName(mdl: PFMUSIC_MODULE): PChar; stdcall; external FMOD_DLL name '_FMUSIC_GetName@4';
function FMUSIC_GetType(mdl: PFMUSIC_MODULE): FMUSIC_TYPES; stdcall; external FMOD_DLL name '_FMUSIC_GetType@4';
function FMUSIC_UsesLinearFrequencies(mdl: PFMUSIC_MODULE): ByteBool; stdcall; external FMOD_DLL name '_FMUSIC_UsesLinearFrequencies@4';
//function FMUSIC_UsesMulaw(mdl: PFMUSIC_MODULE): ByteBool; stdcall; external FMOD_DLL name '_FMUSIC_UsesMulaw@4';
function FMUSIC_GetNumOrders(mdl: PFMUSIC_MODULE): DWORD; stdcall; external FMOD_DLL name '_FMUSIC_GetNumOrders@4';
function FMUSIC_GetNumPatterns(mdl: PFMUSIC_MODULE): DWORD; stdcall; external FMOD_DLL name '_FMUSIC_GetNumPatterns@4';
function FMUSIC_GetNumInstruments(mdl: PFMUSIC_MODULE): DWORD; stdcall; external FMOD_DLL name '_FMUSIC_GetNumInstruments@4';
function FMUSIC_GetNumSamples(mdl: PFMUSIC_MODULE): DWORD; stdcall; external FMOD_DLL name '_FMUSIC_GetNumSamples@4';
function FMUSIC_GetNumChannels(mdl: PFMUSIC_MODULE): DWORD; stdcall; external FMOD_DLL name '_FMUSIC_GetNumChannels@4';
function FMUSIC_GetSample(mdl: PFMUSIC_MODULE; sampno: DWORD): PFSOUND_SAMPLE; stdcall; external FMOD_DLL name '_FMUSIC_GetSample@8';
function FMUSIC_GetPatternLength(mdl: PFMUSIC_MODULE; orderno: DWORD): DWORD; stdcall; external FMOD_DLL name '_FMUSIC_GetPatternLength@8';

// Runtime song information.
// =========================
function FMUSIC_IsFinished(mdl: PFMUSIC_MODULE): ByteBool; stdcall; external FMOD_DLL name '_FMUSIC_IsFinished@4';
function FMUSIC_IsPlaying(mdl: PFMUSIC_MODULE): ByteBool; stdcall; external FMOD_DLL name '_FMUSIC_IsPlaying@4';
function FMUSIC_GetMasterVolume(mdl: PFMUSIC_MODULE): DWORD; stdcall; external FMOD_DLL name '_FMUSIC_GetMasterVolume@4';
function FMUSIC_GetGlobalVolume(mdl: PFMUSIC_MODULE): DWORD; stdcall; external FMOD_DLL name '_FMUSIC_GetGlobalVolume@4';
function FMUSIC_GetOrder(mdl: PFMUSIC_MODULE): DWORD; stdcall; external FMOD_DLL name '_FMUSIC_GetOrder@4';
function FMUSIC_GetPattern(mdl: PFMUSIC_MODULE): DWORD; stdcall; external FMOD_DLL name '_FMUSIC_GetPattern@4';
function FMUSIC_GetSpeed(mdl: PFMUSIC_MODULE): DWORD; stdcall; external FMOD_DLL name '_FMUSIC_GetSpeed@4';
function FMUSIC_GetBPM(mdl: PFMUSIC_MODULE): DWORD; stdcall; external FMOD_DLL name '_FMUSIC_GetBPM@4';
function FMUSIC_GetRow(mdl: PFMUSIC_MODULE): DWORD; stdcall; external FMOD_DLL name '_FMUSIC_GetRow@4';
function FMUSIC_GetPaused(mdl: PFMUSIC_MODULE): ByteBool; stdcall; external FMOD_DLL name '_FMUSIC_GetPaused@4';
function FMUSIC_GetTime(mdl: PFMUSIC_MODULE): ULONG; stdcall; external FMOD_DLL name '_FMUSIC_GetTime@4';

end.
