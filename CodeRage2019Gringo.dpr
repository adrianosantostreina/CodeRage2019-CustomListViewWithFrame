program CodeRage2019Gringo;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit1 in 'Unit1.pas' {FrmPrincipal},
  Aguarde in 'Aguarde.pas',
  UntFrameBase in 'UntFrameBase.pas' {FrameBase: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
