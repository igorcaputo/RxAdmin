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
    edtRgLidos: TRaEdit;
    edtCodBarra: TRaEdit;
    lblProcesso: TRaLabel;
    lblHrInicio: TRaLabel;
    RaIntervalTimer1: TRaIntervalTimer;
    RaLabel3: TRaLabel;
    RaLabel4: TRaLabel;
    lbLidos: TRaLabel;
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
    procedure edtCodBarraChange(Sender: TObject);
    procedure edtCodBarraEnter(Sender: TObject);
    procedure edtCodBarraExit(Sender: TObject);
    procedure RaIntervalTimer1Tick(Sender: TObject);
  private
    xCount:integer;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmControlePostagem: TfrmControlePostagem;

implementation

uses untprincipal, utils;

{ TfrmControlePostagem }

procedure TfrmControlePostagem.RaApplicationEvents1ScreenResize(Sender: TObject);
var
  x: integer;
begin
  try

    for x := 0 to (Self.ComponentCount) - 1 do
    begin
      if (Pos('_lbl', TComponent(Self.Components[x]).Name) > 0) then
        if (Self.Components[x] is TRaLabel) then
        begin
          writeln(TComponent(Self.Components[x]).Name);
          TComponent(Self.Components[x]).Free;
        end;
    end;

  finally
  end;
  RaPanel1.Left := Round((RaPanel1.Width - RaApplication.Application.ScreenWidth) / 2);
end;

procedure TfrmControlePostagem.edtCodBarraChange(Sender: TObject);
var
a: TRaLabel;
begin
 inc(xCount);
 a:= TRaLabel.Create(Self);
 a.Parent := RaPanel2;
 a.Left := 0;
 a.Width := 0;
 a.Name:= '_lbl' + inttostr(xCount);
 a.Caption := '<audio controls autoplay><source src="alerta.mp3" type="audio/mpeg"></audio>';
 sleep(10);
// a.free;
 edtCodBarra.Text := '';
 lbLidos.Caption := PadL(inttostr(xCount),3);
end;

procedure TfrmControlePostagem.edtCodBarraEnter(Sender: TObject);

begin
end;

procedure TfrmControlePostagem.edtCodBarraExit(Sender: TObject);
begin
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
 edtRgLidos.text := lbLidos.caption;
 lbLidos.caption := 'XXX';
 edtCodBarra.readOnly := true;
end;

procedure TfrmControlePostagem.btnGravarClick(Sender: TObject);
var
  i:integer;
begin
 inc(i);
 xCount :=0;
 //edtPeso.text :=  frmPrincipal.parametro;
 edtNrProcesso.text := inttostr(i);
 edtDtInicio.text := formatdatetime('dd/mm/yyyy hh:nn:ss',now);
 edtDtFechamento.text := '';
 edtRgLidos.text :='';
 RxTickCross1.checked := true;
 edtCodBarra.readOnly := false;
end;


initialization
  {$I untcontrolepostagem.lrs}
  RegisterClass(TfrmControlePostagem);

finalization
  UnRegisterClass(TfrmControlePostagem);
end.

