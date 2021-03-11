unit untControlePostagem;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, RxTickCross, RaApplication, RaBase,
  RaControlsVCL, untFrameDefault;

type

  { TfrmControlePostagem }

  TfrmControlePostagem = class(TFrameDefault)
    btnExcluir: TRaButton;
    btnGravar: TRaButton;
    RaApplicationEvents1: TRaApplicationEvents;
    edtNrProcesso: TRaEdit;
    edtDtInicio: TRaEdit;
    edtDtFechamento: TRaEdit;
    RaEdit4: TRaEdit;
    RaEdit5: TRaEdit;
    lblProcesso: TRaLabel;
    lblHrInicio: TRaLabel;
    RaIntervalTimer1: TRaIntervalTimer;
    RaLabel3: TRaLabel;
    RaLabel4: TRaLabel;
    RaLabel5: TRaLabel;
    RaLabel6: TRaLabel;
    RaLabel7: TRaLabel;
    RaPanel1: TRaPanel;
    RaPanel2: TRaPanel;
    RaPanel3: TRaPanel;
    RaPanel4: TRaPanel;
    edtPeso: TRaEdit;
    RxTickCross1: TRxTickCross;
    procedure btnExcluirClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure RaApplicationEvents1ScreenResize(Sender: TObject);
    procedure RaIntervalTimer1Tick(Sender: TObject);
  private
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmControlePostagem: TfrmControlePostagem;

implementation

uses untprincipal;

{ TfrmControlePostagem }

procedure TfrmControlePostagem.RaApplicationEvents1ScreenResize(Sender: TObject);
begin
  RaPanel1.Left := Round((RaPanel1.Width - RaApplication.Application.ScreenWidth) / 2);
end;

procedure TfrmControlePostagem.RaIntervalTimer1Tick(Sender: TObject);
var
  Arq:TStringList;
begin
  Arq := TStringList.Create;
  Arq.LoadFromFile('peso.txt');
  edtPeso.text := Arq.Text;
  Arq.Free;
end;

constructor TfrmControlePostagem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  RaPanel1.Left := Round((RaPanel1.Width - RaApplication.Application.ScreenWidth) / 2);
end;

procedure TfrmControlePostagem.btnExcluirClick(Sender: TObject);
begin
 edtDtFechamento.text := formatdatetime('dd/mm/yyyy hh:nn:ss',now);
 RxTickCross1.checked := false;
end;

procedure TfrmControlePostagem.btnGravarClick(Sender: TObject);
var
  i:integer;
begin
 inc(i);
 edtPeso.text :=  frmPrincipal.parametro;
 edtNrProcesso.text := inttostr(i);
 edtDtInicio.text := formatdatetime('dd/mm/yyyy hh:nn:ss',now);
 RxTickCross1.checked := true;
end;


initialization
  {$I untcontrolepostagem.lrs}
  RegisterClass(TfrmControlePostagem);

finalization
  UnRegisterClass(TfrmControlePostagem);
end.

