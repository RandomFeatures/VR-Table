library DiceManager;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  View-Project Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the DELPHIMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using DELPHIMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  Sharemem,
  SysUtils,
  Classes,
  Plgcommon in 'Plgcommon.pas',
  Dice in 'Dice.pas' {frmDice},
  main in 'main.pas',
  cfg in 'cfg.pas' {frmCfg};

{$E plg}

exports
    DescribePlugin, Configure, InitPlugin, ReceivedMsg, StatusChange, LoadMenu, ShowDiceM;

begin

end.
