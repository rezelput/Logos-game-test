program Logos;

uses
  Forms,
  LogosUnit in 'LogosUnit.pas' {logos_form},
  ProtokolUnit in 'ProtokolUnit.pas' {frmProtokol},
  ReadyUnit in 'ReadyUnit.pas' {frmReady};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'XorGame';
  Application.CreateForm(Tlogos_form, logos_form);
  Application.CreateForm(TfrmProtokol, frmProtokol);
  Application.CreateForm(TfrmReady, frmReady);
  Application.Run;
end.
