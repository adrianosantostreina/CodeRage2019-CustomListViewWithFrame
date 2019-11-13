unit Aguarde;

interface

uses
  System.SysUtils,
  System.UITypes,

  FMX.Types,
  FMX.Controls,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Effects,
  FMX.Layouts,
  FMX.Forms,
  FMX.Graphics,
  FMX.Ani,
  FMX.VirtualKeyboard,
  FMX.Platform;

type
  TAguarde = class
  private
    class var
      Layout    : TLayout;
      Fundo     : TRectangle;
      Arco      : TArc;
      Mensagem  : TLabel;
      Animacao  : TFloatAnimation;
  public
    class procedure Show(const AForm: TForm; const AMSG: string);
    class procedure Hide;
  end;

implementation

{ TAguarde }

class procedure TAguarde.Hide;
begin
  if Assigned(Layout) then
  begin
    try
      if Assigned(Mensagem) then
        Mensagem.DisposeOf;

      if Assigned(Animacao) then
        Animacao.DisposeOf;

      if Assigned(Arco) then
        Arco.DisposeOf;

      if Assigned(Fundo) then
        Fundo.DisposeOf;

      if Assigned(Layout) then
        Layout.DisposeOf;

    except
    end;
  end;

  Mensagem := nil;
  Animacao := nil;
  Arco     := nil;
  Layout   := nil;
  Fundo    := nil;
end;

class procedure TAguarde.Show(const AForm: TForm; const AMSG: string);
var
  FService: IFMXVirtualKeyboardService;
begin
  //Fundo preto
  Fundo                             := TRectangle.Create(AForm);
  Fundo.Opacity                     := 0;
  Fundo.Parent                      := AForm;
  Fundo.Visible                     := true;
  Fundo.Align                       := TAlignLayout.Contents;
  Fundo.Fill.Color                  := TAlphaColorRec.Black;
  Fundo.Fill.Kind                   := TBrushKind.Solid;
  Fundo.Stroke.Kind                 := TBrushKind.None;
  Fundo.Visible                     := True;

  //Texto e Arco
  Layout                            := TLayout.Create(AForm);
  Layout.Opacity                    := 0;
  Layout.Parent                     := AForm;
  Layout.Visible                    := true;
  Layout.Align                      := TAlignLayout.Contents;
  Layout.Width                      := 250;
  Layout.Height                     := 78;
  Layout.Visible                    := True;

  //Animaão
  Arco                              := TArc.Create(AForm);
  Arco.Visible                      := true;
  Arco.Parent                       := Layout;
  Arco.Align                        := TAlignLayout.Center;
  Arco.Margins.Bottom               := 55;
  Arco.Width                        := 25;
  Arco.Height                       := 25;
  Arco.EndAngle                     := 280;
  Arco.Stroke.Color                 := $FFFEFFFF;
  Arco.Stroke.Thickness             := 2;
  Arco.Position.X                   := Trunc((Layout.Width - Arco.Width) / 2);
  Arco.Position.Y                   := 0;

  //
  Animacao                          := TFloatAnimation.Create(AForm);
  Animacao.Parent                   := Arco;
  Animacao.StartValue               := 0;
  Animacao.StopValue                := 360;
  Animacao.Duration                 := 0.8;
  Animacao.Loop                     := True;
  Animacao.PropertyName             := 'RotationAngle';
  Animacao.AnimationType            := TAnimationType.InOut;
  Animacao.Interpolation            := TInterpolationType.Linear;
  Animacao.Start;

  //Label do texto...
  Mensagem                          := TLabel.Create(AForm);
  Mensagem.Parent                   := Layout;
  Mensagem.Align                    := TAlignLayout.Center;
  Mensagem.Margins.Top              := 60;
  Mensagem.Font.Size                := 13;
  Mensagem.Height                   := 70;
  Mensagem.Width                    := AForm.Width - 100;
  Mensagem.FontColor                := $FFFEFFFF;
  Mensagem.TextSettings.HorzAlign   := TTextAlign.Center;
  Mensagem.TextSettings.VertAlign   := TTextAlign.Leading;
  Mensagem.StyledSettings           := [TStyledSetting.Family, TStyledSetting.Style];
  Mensagem.Text                     := AMSG;
  Mensagem.VertTextAlign            := TTextAlign.Leading;
  Mensagem.Trimming                 := TTextTrimming.None;
  Mensagem.TabStop                  := false;
  Mensagem.SetFocus;

  //controles...
  Fundo.AnimateFloat('Opacity', 0.7);
  Layout.AnimateFloat('Opacity', 1);
  Layout.BringToFront;

  //Esconder teclado
  TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService,
    IInterface(FService));

  if (FService <> nil) then
    FService.HideVirtualKeyboard;

  FService := nil;
end;

end.

