unit untprincipal;

interface

{$DEFINE RAUDUS}

uses
  Classes, SysUtils, Controls, contnrs, SyncObjs, Graphics,
  {$IFDEF RAUDUS}
  RaApplication, RaBase, RaControlsVCL,
  {$ENDIF}
  Forms, StdCtrls, ExtCtrls, FileUtil, LResources, ExtDlgs, Menus,
  RxExtDatePicker, RxTinyMCE, RxPublisherView, RxTickCross, RxTheme,
  RxJqDatePicker, uBootStrapEdit, untFrameDefault, uFormDefault,
  dSQLdbBroker, objMenu, objDynamicForm,
  TypInfo;

type
  TLayout = (loFixe, loFluid);
  TResise = (rsDesktop, lsTablet, rsMobile);

  { TfrmPrincipal }
  TfrmPrincipal = class(TRaFormCompatible)
    btnSair: TRaButton;
    CenterPanel: TRaScrollBox;
    container: TRaPanel;
    edtBusca1: TRaEdit;
    fraContainer: TRaFrameHolder;
    lblHora: TRaLabel;
    lbxInformativo: TRaListBox;
    pnlInformativo: TRaPanel;
    pnlTopoAlerta1: TRaPanel;
    RaBitButton2: TRaBitButton;
    CloseFrame: TRaButton;
    RaButton2: TRaButton;
    RaImage1: TRaImage;
    RaIntervalTimer1: TRaIntervalTimer;
    RaOverlay1: TRaOverlay;
    RaPanel1: TRaPanel;
    TopPanel_cfg: TRaPanel;
    RaPanel4: TRaPanel;
    TbcPrincipal: TRaTabControl;
    TbsPrincipal: TRaTabSheet;
    RaWwwPublisher1: TRaWwwPublisher;
    SiderPanel_cfg: TRaScrollBox;
    LinhaTop: TRaPanel;
    procedure btnFecharClick(Sender: TObject);
    procedure btnRelatoriosClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure CloseFrameClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnMaximizarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RaBitButton1Click(Sender: TObject);
    procedure RaBitButton2Click(Sender: TObject);
    procedure btnCadPessoaClick(Sender: TObject);
    procedure RaButton1Click(Sender: TObject);
    procedure RaButton2Click(Sender: TObject);
    procedure RaButton7Click(Sender: TObject);
    procedure RaIntervalTimer1Tick(Sender: TObject);
  private
    vForm: TDynamicForm;
    FFrameCount: integer;
    idControl: longint;

    procedure btnBuscaClick(Sender: TObject);
    procedure LoadSetting;
  public
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses untLogin, untPesquisa, libBusca, untMeuLayout, objMeuLayout;

procedure TfrmPrincipal.btnFecharClick(Sender: TObject);
begin
end;

procedure TfrmPrincipal.btnRelatoriosClick(Sender: TObject);
begin
end;

procedure TfrmPrincipal.btnSairClick(Sender: TObject);
begin
  Close;
  vForm.LoadForm('TfrmLogin', Self, True, []);
end;

procedure TfrmPrincipal.CloseFrameClick(Sender: TObject);
var
  fra: TFrameDefault;
  pnl: TRaFrameHolder;
  SuperOwner: TComponent;
  i, ii: integer;
begin
  ii := 0;
  SuperOwner :=
{$IFDEF RAUDUS}
    RaApplication.Application.OwningComponent;
{$ELSE}
  Forms.Application;
{$ENDIF}
  //  pnlAlerta.Visible := true;

  fra := TFrameDefault(TRaButton(Sender).Parent.Parent);
  Writeln(' name: ' + fra.Name);
  pnl := TRaFrameHolder(fra.Parent.Parent);//.Free;
  Writeln(' destruir : ' + pnl.Name);
  pnl.Free;
end;

procedure TfrmPrincipal.FormActivate(Sender: TObject);
var
  FConfig: TDynamicForm;
  parametro:string;
begin

  parametro:=RaApplication.Application.GateQueryParams;

  if frmPrincipal = nil then
    exit;
  //  frmPrincipal.Top := headerpanel.Height + 1;
  //  frmPrincipal.Left := CenterPanel.Left;
  frmPrincipal.BringToFront;

  FConfig := TDynamicForm.Create;
  FConfig.LoadSetting(Self);
  FConfig.Free;



end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
var
  txtCaption: string;
  Menu: TMenu;

begin
  RaIntervalTimer1.Enabled := True;
  FFrameCount := 0;
  vForm := TDynamicForm.Create;
  vForm.Form := frmPrincipal;
  vForm.TabControl := TbcPrincipal;
  vForm.CenterPanel := CenterPanel;
  vForm.FrameCount := FFrameCount;
  vForm.Tipo := 1;

  Menu := TMenu.Create;
  Menu.Form := Self;
  Menu.TabControl := TbcPrincipal;
  Menu.SideBar := SiderPanel_cfg;
  Menu.CarregaMenu;
end;

procedure TfrmPrincipal.btnMaximizarClick(Sender: TObject);
begin
  case SiderPanel_cfg.Visible of
    True:
      SiderPanel_cfg.Visible := False;
    False:
      SiderPanel_cfg.Visible := True;
  end;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  LoadSetting;
end;

procedure TfrmPrincipal.RaBitButton1Click(Sender: TObject);
begin

end;

procedure TfrmPrincipal.RaBitButton2Click(Sender: TObject);
begin
  case SiderPanel_cfg.Visible of
    True: SiderPanel_cfg.Visible := False;
    False: SiderPanel_cfg.Visible := True;
  end;
end;

procedure TfrmPrincipal.btnCadPessoaClick(Sender: TObject);
begin
  Inc(FFrameCount);
  vForm.NewFrame('TfrmCadPessoa', 'Cadastro de fornecedor', CenterPanel);
end;

procedure TfrmPrincipal.RaButton1Click(Sender: TObject);

begin
end;

procedure TfrmPrincipal.RaButton2Click(Sender: TObject);
begin
  RaOverlay1.Left := RaApplication.Application.EventRectangle.Left;
  RaOverlay1.Top := RaApplication.Application.EventRectangle.Bottom;
  RaOverlay1.Show;
end;

procedure TfrmPrincipal.RaButton7Click(Sender: TObject);
begin
end;

procedure TfrmPrincipal.RaIntervalTimer1Tick(Sender: TObject);
begin
  lblHora.Caption := DateTimeToStr(now);
end;

procedure TfrmPrincipal.btnBuscaClick(Sender: TObject);
begin
  vForm.NewFrame((Sender as TRaButton).Name, (Sender as TRaButton).Caption, CenterPanel);
end;

procedure TfrmPrincipal.LoadSetting;
var
  x: integer;
  FColor: TColor;
  MeuLayoutOpf: TMeuLayoutOpf;
begin
  try
    MeuLayoutOpf := TMeuLayoutOpf.Create;

    for x := 0 to (Self.ComponentCount) - 1 do
    begin
      if (Pos('_cfg', TComponent(Self.Components[x]).Name) > 0) then
        if (Self.Components[x] is TRaPanel) then
        begin
          writeln(TComponent(Self.Components[x]).Name);
          MeuLayoutOpf.Entity.Id := MeuLayoutOpf.GetId(TComponent(Self.Components[x]).Name);
          if (MeuLayoutOpf.Entity.Id > 0) then
          begin
            MeuLayoutOpf.Get;

            FColor := StringToColor(MeuLayoutOpf.Entity.Cor);
            (Self.Components[x] as TRaPanel).color := FColor;
          end;
        end;
    end;

  finally
    MeuLayoutOpf.Free;
  end;
end;

initialization
  {$I untprincipal.lrs}
  RegisterClass(TfrmPrincipal);

finalization
  UnRegisterClass(TfrmPrincipal);
end.


