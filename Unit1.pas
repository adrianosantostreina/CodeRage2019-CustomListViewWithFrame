unit Unit1;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,

  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Layouts,
  FMX.StdCtrls,
  FMX.Controls.Presentation,

  System.IOUtils,

  Aguarde, UntFrameBase, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.Objects;

type
  TProcedureExcept = reference to procedure (const AExcpection : string);

  TFrmPrincipal = class(TForm)
    ToolBar1: TToolBar;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    vertList: TVertScrollBox;
    FrameBase1: TFrameBase;
    FDConnection1: TFDConnection;
    QryUsuarios: TFDQuery;
    QryUsuariosID: TIntegerField;
    QryUsuariosNOME: TStringField;
    QryUsuariosAPELIDO: TStringField;
    QryUsuariosDT_NASCIMENTO: TSQLTimeStampField;
    QryUsuariosCOMPROU: TStringField;
    QryUsuariosFOTO: TBlobField;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    QryAuxiliar: TFDQuery;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    Rectangle1: TRectangle;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FDConnection1BeforeConnect(Sender: TObject);
  private
    procedure CustomThread(
      AOnStart,
      AOnProcess,
      AOnComplete: TProc;
      AOnError: TProcedureExcept;
      ADoCompletWithError: Boolean = True);
    procedure ClearList(Sender: TObject; AVertScroll: TVertScrollBox);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

procedure TFrmPrincipal.Button1Click(Sender: TObject);
const
  LCheck          = 'M9,20.42L2.79,14.21L5.62,11.38L9,14.77L18.88,4.88L21.71,7.71L9,20.42Z';
  LCheckColor     = $FF0C47E1;
  LUnCheck        = 'M19,13H13V19H11V13H5V11H11V5H13V11H19V13Z';
  LUnCheckColor   = $FFE1290C;

var
  LFrame : TFrameBase;
begin
  CustomThread(
    procedure ()
    begin
      //OnStart
      TAguarde.Show(Self, 'Clearing list...');
      Self.vertList.Visible := False;
      Self.vertList.BeginUpdate;
      Self.ClearList(Sender, Self.vertList);
    end,

    procedure ()
    begin
      //OnProcess
      QryUsuarios.Active := False;
      QryUsuarios.Active := True;
      QryUsuarios.First;

      while not QryUsuarios.EOF do
      begin
        TThread.Synchronize(
          TThread.CurrentThread,
          procedure ()
          begin
            //
          end
        );

        LFrame                      := TFrameBase.Create(vertList);
        LFrame.Parent               := vertList;
        LFrame.Name                 := Format('frame%6.6d', [QryUsuariosID.AsInteger]);
        LFrame.Tag                  := QryUsuariosID.AsInteger;
        LFrame.Identify             := QryUsuariosID.AsInteger;

        LFrame.Margins.Bottom       := 4;
        LFrame.Margins.Left         := 4;
        LFrame.Margins.Right        := 4;
        LFrame.Margins.Top          := 4;

        LFrame.lblTitulo.Text       := QryUsuariosNOME.AsString;
        //LFrame.lblTitulo.OnClick

        LFrame.lblDetail1.Text      := QryUsuariosAPELIDO.AsString;
        //LFrame.lblDetail1.OnClick

        LFrame.lblDetail2.Text      := DAteToStr(QryUsuariosDT_NASCIMENTO.AsDateTime);

        if QryUsuariosCOMPROU.AsString.Equals('1') then
        begin
          LFrame.lblDetail3.Text    := 'Já cliente';
          LFrame.pthIcon.Data.Data  := LCheck;
          LFrame.pthIcon.Fill.Color := LCheckColor;
        end
        else
        begin
          LFrame.lblDetail3.Text    := 'Não cliente';
          LFrame.pthIcon.Data.Data  := LUnCheck;
          LFrame.pthIcon.Fill.Color := LUnCheckColor;
        end;

        TThread.Synchronize(
          TThread.CurrentThread,
          procedure ()
          begin
            LFrame.cirPhoto.Fill.Bitmap.Bitmap.Assign(QryUsuariosFOTO);
            LFrame.cirPhoto.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
            //LFrame.cirPhoto.OnClick

            vertList.AddObject(LFrame);

            LFrame.Align := TAlignLayout.Top;
            LFrame.Position.Y := (vertList.Content.ChildrenCount-1) + LFrame.Height;
          end
        );
        QryUsuarios.Next;
      end;
    end,

    procedure ()
    begin
      //OnComplete
      TAguarde.Hide;
      Self.vertList.Visible := True;
      Self.vertList.EndUpdate;
      Self.vertList.ScrollTo(0, 0);
    end,

    procedure (const AException : string)
    begin
      //OnError
      ShowMessage('Error');
    end
  );
end;

procedure TFrmPrincipal.Button2Click(Sender: TObject);
begin
  ClearList(Sender, vertList);
end;

procedure TFrmPrincipal.ClearList(Sender: TObject; AVertScroll: TVertScrollBox);
var
  LThread : TThread;
begin
  LThread :=
    TThread.CreateAnonymousThread(
      procedure ()
      begin
        AVertScroll.BeginUpdate;
        TThread.Synchronize(TThread.CurrentThread,
          procedure ()
          var
            I      : Integer;
            lFrame : TFrame;
          begin
            for I := Pred(AVertScroll.Content.ChildrenCount) downto 0 do
            begin
              if (AVertScroll.Content.Children[I] is TFrame) then
              begin
                lFrame := (AVertScroll.Content.Children[I] as TFrame);
                lFrame.DisposeOf;
                lFrame := nil;
              end;
            end;
          end
        );
        AVertScroll.EndUpdate;
      end
    );
  LThread.Start;
end;

procedure TFrmPrincipal.CustomThread(
  AOnStart,
  AOnProcess,
  AOnComplete : TProc;
  AOnError: TProcedureExcept;
  ADoCompletWithError: Boolean = True);
var
  LThread : TThread;
begin
  LThread :=
    TThread.CreateAnonymousThread(
      procedure ()
      var
        LDoComplete : Boolean;
      begin
        try
          try
            //OnStart
            LDoComplete := True;
            if Assigned(AOnStart) then
            begin
              TThread.Synchronize(
                TThread.CurrentThread,
                procedure ()
                begin
                  AOnStart;
                end
              );
            end;

            //OnProcess
            if Assigned(AOnProcess) then
              AOnProcess;

          //OnError
          except on E:Exception do
            begin
              LDoComplete := ADoCompletWithError;
              if Assigned(AOnError) then
              begin
                TThread.Synchronize(
                  TThread.CurrentThread,
                  procedure ()
                  begin
                    AOnError(E.Message);
                  end
                );
              end;

            end;
          end;
        finally
          //OnComplete
          if Assigned(AOnComplete) then
          begin
            TThread.Synchronize(
              TThread.CurrentThread,
              procedure ()
              begin
                AOnComplete;
              end
            );
          end;
        end;
      end
    );

  LThread.FreeOnTerminate := True;
  LThread.Start;
end;

procedure TFrmPrincipal.FDConnection1BeforeConnect(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
    FDConnection1.Params.Values['Database'] :=
      'C:\Users\adrianosantos\Downloads\1. Testar Delphi\07ED-Threads e Listas Personalizadas\Listagem.db';
  {$ELSE}
    FDConnection1.Params.Values['OpenMode'] := 'ReadWrite';
    FDConnection1.Params.Values['Database'] :=
      System.IOUtils.TPath.Combine(System.IOUtils.TPath.GetDocumentsPath,'Listagem.db');
  {$ENDIF}
end;

end.
