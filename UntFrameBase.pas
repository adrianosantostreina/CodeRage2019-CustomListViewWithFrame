unit UntFrameBase;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Objects,
  FMX.Layouts;

type
  TFrameBase = class(TFrame)
    lytBack: TLayout;
    Rectangle1: TRectangle;
    Layout1: TLayout;
    Layout2: TLayout;
    lytBtnCenter: TLayout;
    pthIconNext: TPath;
    speBtnNext: TSpeedButton;
    lytTextos: TLayout;
    lblTitulo: TLabel;
    lblDetail1: TLabel;
    lblDetail2: TLabel;
    lytBottom: TLayout;
    lblDetail3: TLabel;
    lytIcon: TLayout;
    pthIcon: TPath;
    speTPath: TSpeedButton;
    cirPhoto: TCircle;
  private
    { Private declarations }
    FIdentify : Integer;
  public
    { Public declarations }
    property Identify : integer read FIdentify write FIdentify;
  end;

implementation

{$R *.fmx}

end.
