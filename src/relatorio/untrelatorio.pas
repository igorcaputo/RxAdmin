unit untRelatorio;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, SysUtils, FileUtil, LResources, RaApplication, RaBase, Controls,
  RaControlsVCL, RxJqDatePicker, RxPublisherView, db , dSQLdbBroker, sqlite3conn, dUtils,
  Graphics;

type
  TRetornoArray = array of string;
  TNotifyEvent = procedure(Sender: TObject) of object;

type
  { TfrmRelatorio }

  TfrmRelatorio = class(TFrame)
    btnFechar: TRaButton;
    btnImprimir: TRaBitButton;
    pnlRelatorio: TRaScrollBox;
    pnlTopo: TRaPanel;
    pnlCentral: TRaPanel;
    pnlRotape: TRaPanel;
    procedure btnImprimirClick(Sender: TObject);
    procedure FrameResize(Sender: TObject);
  private
    vBusca:string;
    procedure btnBuscaClick(Sender: TObject);
    procedure onExit(Sender: TObject);
    procedure onShow(Sender: TObject);
  public
    procedure CriaLabel(ANome, ACaption, AVisible: string; var ATop: integer; AParent: TWinControl);
    procedure CriaBusca(ANome, AVisible, ABusca: string; var ATop: integer; vWidth: integer; AParent: TWinControl);
    procedure CriaComboBox(ANome, ACaption, AVisible: string; var ATop: integer; AParent: TWinControl);
    procedure CriaEdit(ANome, ACaption, AVisible: string; var ATop: integer; vWidth: integer; AParent: TWinControl);
    procedure CampoDE_ATE(ANome, AVisible: string; var ATop: integer; AParent: TWinControl);
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmRelatorio: TfrmRelatorio;

const
  QRY_BUSCA = 'SELECT SBC_CODIGO AS Codigo, SBC_CONSULTA AS Consulta, SBC_RETORNO as Retorno FROM SISBUSCA_SBC INNER JOIN RELPARAMETRO_RPR ON (SBC_CODIGO=RPR_BUSCA) WHERE RPR_CODIGO=';

implementation

uses untPrincipal, objGeradorRelatorio, libGeradorRelatorio, libBusca, objBusca, untDm,
     lr_e_pdf,  untPreview, dbutils;

{ TfrmRelatorio }

procedure TfrmRelatorio.btnBuscaClick(Sender: TObject);
var
  VRetorno: TRetornoArray;
  SuperOwner: TComponent;
  i: integer;
  xEdit: TRaEdit;

  con: TdSQLdbConnector;
  qry: TdSQLdbQuery;
  VSisBusca: TSisBusca;

begin
  con := dbutils.con;
  qry := TdSQLdbQuery.Create(con);
  try
    con.Connect;

    writeln((Sender as TRaButton).Name );
    qry.SQL.Text := QRY_BUSCA + QuotedStr(Copy((Sender as TRaButton).Name,4,Length((Sender as TRaButton).Name)));
    writeln(qry.SQL.Text);
    VSisBusca := TSisBusca.Create;

    qry.Open;
    qry.First;
    while not qry.EOF do
    begin
      dUtils.dGetFields(VSisBusca, qry.Fields);

      VRetorno := TRetornoArray.Create;
      SetLength(VRetorno, 1);
      VRetorno[0] := VSisBusca.Retorno;

      SuperOwner := Owner;
      for i := SuperOwner.ComponentCount - 1 downto 0 do
      begin
        if SuperOwner.Components[i] <> Self then
        begin
          if SuperOwner.Components[i] is TRaEdit then
          begin
            if (Sender as TRaBitButton).Name = 'bsc' +
              TRaEdit(SuperOwner.Components[i]).Name then
            begin
              xEdit := TRaEdit(SuperOwner.Components[i]);
              Pesquisa(True, VSisBusca.Consulta, 'Produto', VRetorno, xEdit, xEdit);
              TRaEdit(SuperOwner.Components[i]).Text := Self.Name;
            end;
          end;
        end;
      end;
      qry.Next;
    end;
  finally
    con.Disconnect;
    con.FreeOnRelease;
    qry.FreeOnRelease;
  end;
end;

procedure TfrmRelatorio.onExit(Sender: TObject);
begin
end;

procedure TfrmRelatorio.onShow(Sender: TObject);
var
  VRelParametro: TRelParametro;
  VConsulta: TRelConsulta;
  a, I: integer;

  con: TdSQLdbConnector;
  qry: TdSQLdbQuery;

begin
  con := dbutils.con;
  qry := TdSQLdbQuery.Create(con);

  try
    con.Connect;

    qry.SQL.Text := SQL_RELPARAMETRO;
    VRelParametro := TRelParametro.Create;

    a := 30;
    i := 0;

    qry.Open;
    qry.First;
    while not qry.EOF do
    begin
      Inc(i);
      a := 30 + VRelParametro.Ordem * 22;
      dUtils.dGetFields(VRelParametro, qry.Fields);

      if (VRelParametro.Tipo = 'tpEdit') then
      begin
        CriaLabel('lbl' + VRelParametro.Codigo, VRelParametro.Nome,
          VRelParametro.Visivel, a, pnlRelatorio);

        if VRelParametro.Busca <> '' then
          CriaBusca('bsc' + VRelParametro.Codigo, VRelParametro.Visivel, VRelParametro.Busca, a, VRelParametro.Tamanho, pnlRelatorio);

        CriaEdit(VRelParametro.Codigo, VRelParametro.Nome, VRelParametro.Visivel,
          a, VRelParametro.Tamanho, pnlRelatorio);
      end;

      if (VRelParametro.Tipo = 'tpDate') then
      begin
        CriaLabel('lbl' + VRelParametro.Codigo, VRelParametro.Nome,
          VRelParametro.Visivel, a, pnlRelatorio);
        CampoDE_ATE(VRelParametro.Codigo, VRelParametro.Visivel, a, pnlRelatorio);
      end;

      if (VRelParametro.Tipo = 'tpComboBox') then
      begin
        CriaLabel('lbl' + VRelParametro.Codigo, VRelParametro.Nome,
          VRelParametro.Visivel, a, pnlRelatorio);
        CriaComboBox(VRelParametro.Codigo, VRelParametro.Nome,
          VRelParametro.Visivel, a, pnlRelatorio);
      end;

      qry.Next;
    end;
  finally
    con.Disconnect;
    con.FreeOnRelease;
  end;
end;

procedure TfrmRelatorio.FrameResize(Sender: TObject);
begin
  btnImprimir.Left := (frmPrincipal.fraContainer.Width - btnImprimir.Width) div 2;
end;

procedure TfrmRelatorio.btnImprimirClick(Sender: TObject);
var
  con, conAux: TdSQLdbConnector;
  qry, qryAux: TdSQLdbQuery;
  VRelatorio: TRelatorio;
  VConsulta:TRelConsulta;

  SuperOwner: TComponent;
  i: integer;

  appFile: TFileStream;
  app: string;
  arqpdf: string;
  RxPublisherView1: TRxPublisherView;
  RaStreamPublisher1: TRaStreamPublisher;

begin
  con := dbutils.con;
  conAux := dbutils.con;
  qryAux := TdSQLdbQuery.Create(conAux);
  VRelatorio := TRelatorio.Create;
  VConsulta:= TRelConsulta.Create;

  try
    conAux.Connect;
    qryAux.SQL.Text := 'SELECT REL_DRIVE as Drive, REL_HOSTNAME as Hostname, REL_DATABASE as Database, REL_USERNAME as Username, REL_PASSWORD as Password FROM RELATORIO_REL';

    qryAux.Open;
    qryAux.First;
    while not qryAux.EOF do
    begin
      dUtils.dGetFields(VRelatorio, qryAux.Fields);
      writeln('Driver: ' + VRelatorio.Drive);
      writeln('Hostname: ' +VRelatorio.Hostname);
      writeln('Database: ' +VRelatorio.Database);
      writeln('Username: ' +VRelatorio.Username);
      writeln('Password: ' +VRelatorio.Password);
      con.Driver := VRelatorio.Drive;
      con.Host := VRelatorio.Hostname;
      con.Database := VRelatorio.Database;
      con.User := VRelatorio.Username;
      con.Password := '';//VRelatorio.Password;
      con.Connect;
      qryAux.Next;
    end;

    qry := TdSQLdbQuery.Create(con);
  finally
    qry.SQL.Clear;
    qry.SQL.Add('SELECT * FROM RELATORIO_REL WHERE REL_CODIGO =:igor2');
  end;

  SuperOwner := Owner;
  for i := SuperOwner.ComponentCount - 1 downto 0 do
  begin
    if SuperOwner.Components[i] <> Self then
    begin

      if SuperOwner.Components[i] is TRaEdit then
       if TRaEdit(SuperOwner.Components[i]).Text <> '' then
        if qry.Params.FindParam(SuperOwner.Components[i].Name) <> nil then
        begin
        // qry.Params.createParam(ftString, SuperOwner.Components[i].Name, ptInput);
        // qry.Param(SuperOwner.Components[i].Name).AsString := QuotedStr(TRaEdit(SuperOwner.Components[i]).Text);
          qry.Params.ParamByName(SuperOwner.Components[i].Name).Value := TRaEdit(SuperOwner.Components[i]).Text;
         WriteLn(SuperOwner.Components[i].Name);
         WriteLn(TRaEdit(SuperOwner.Components[i]).Text)
        end;

      if SuperOwner.Components[i] is TRaComboBox then
        if qry.Params.FindParam(SuperOwner.Components[i].Name) <> nil then
          qry.Param(SuperOwner.Components[i].Name).AsString := TRaComboBox(SuperOwner.Components[i]).Text;

      if SuperOwner.Components[i] is TRxJqDatePicker then
        if qry.Params.FindParam(SuperOwner.Components[i].Name) <> nil then
          qry.Param(SuperOwner.Components[i].Name).AsString := datetostr(TRxJqDatePicker(SuperOwner.Components[i]).Value);

    end;
  end;
  qry.Open;
  qry.First;

  Dm.frDBDataSet1.DataSet := qry.DataSet;
  Dm.frDBDataSet1.DataSource := qry.DataSource;

  while not qry.EOF do
  begin
    WriteLn(qry.Field('REL_CODIGO').AsString);
    WriteLn(qry.SQL.Text);
    qry.Next;
  end;
  RxPublisherView1 := TRxPublisherView.Create(Owner);
  RaStreamPublisher1 := TRaStreamPublisher.Create(Owner);
  app := ExtractFilePath(ParamStr(0));
{$IFDEF UNIX}
  app := '/home/Mobb/Relatorio/';
{$ENDIF}
  RaStreamPublisher1.Stream.Free;
  arqpdf := formatdatetime('ddmmyyyhhmmss', now) + '_' + 'SaldoSeparacao.pdf';
  RaStreamPublisher1.DownloadName := arqpdf;

  Dm.frReport1.LoadFromFile(app +'modelo\'+ 'SaldoSeparacao.lrf');

  Dm.frReport1.PrepareReport;
  //Synchronize(@Dm.frReport1.PrepareReport);
  Dm.frReport1.ExportTo(TFrTNPDFExportFilter, app +'tmp\'+ arqpdf);

  appFile := TFileStream.Create(app +'tmp\'+ arqpdf, fmOpenRead);

  RaStreamPublisher1.Stream := appFile;
  RxPublisherView1.kind := pvkIFRAME;
  RxPublisherView1.publisher := RaStreamPublisher1;

  frmPreview.RaStreamPublisher1 := RaStreamPublisher1;
  frmPreview.Show;
end;

procedure TfrmRelatorio.CriaLabel(ANome, ACaption, AVisible: string;
  var ATop: integer; AParent: TWinControl);
var
  vLabel: TRaLabel;

begin
  vLabel := TRaLabel.Create(Owner);
  vLabel.Parent := AParent;

  if AVisible = 'S' then
    vLabel.Visible := True
  else
    vLabel.Visible := False;

  vLabel.Caption := ACaption;
  vLabel.Name := ANome;
  vLabel.Left := 10;
  vLabel.Width := 300;
  vLabel.AutoSize := True;
  vLabel.AutoSizeDelayed;
  vLabel.Top := ATop;
end;

procedure TfrmRelatorio.CriaBusca(ANome, AVisible, ABusca: string; var ATop: integer;
  vWidth: integer; AParent: TWinControl);
var
  vButton: TRaBitButton;
  RaImage1: TRaImage;
  aPic: TPicture;

begin
  RaImage1 := TRaImage.Create(Owner);
  vButton := TRaBitButton.Create(Owner);
  vButton.Parent := AParent;

  vButton.onclick := @btnBuscaClick;
  vButton.Name := ANome;
  vButton.ParentColor := True;
  vButton.ui := 'simple';

  if AVisible = 'S'
    then vButton.Visible := True
    else vButton.Visible := False;

  aPic := TPicture.Create;
  aPic.LoadFromFile(ExtractFilePath(Application.ExeName) + 'img\busca.png');
  vButton.Glyph.Assign(aPic.Bitmap);
  aPic.Free;

  vButton.Left := 300 + vWidth;
  vButton.Width := 20;
  vButton.Height := 20;
  vButton.AutoSize := True;
  vButton.AutoSizeDelayed;
  vButton.Top := ATop;
end;


procedure TfrmRelatorio.CriaComboBox(ANome, ACaption, AVisible: string;
  var ATop: integer; AParent: TWinControl);
var
  vComboBox: TRaComboBox;
begin
  vComboBox := TRaComboBox.Create(Owner);
  vComboBox.Parent := AParent;

  if AVisible = 'S' then
    vComboBox.Visible := True
  else
    vComboBox.Visible := False;

  vComboBox.Name := ANome;
  vComboBox.Left := 300;
  vComboBox.ui := 'cupertino';
  vComboBox.Top := ATop;
  vComboBox.Items.add(ACaption);
end;

procedure TfrmRelatorio.CriaEdit(ANome, ACaption, AVisible: string;
  var ATop: integer; vWidth: integer; AParent: TWinControl);
var
  vEdit: TRaEdit;

begin
  vEdit := TRaEdit.Create(Owner);
  vEdit.Parent := AParent;

  if AVisible = 'S' then
    vEdit.Visible := True
  else
    vEdit.Visible := False;

  vEdit.OnExit := @OnExit;
  vEdit.Name := ANome;

  vEdit.Left := 300;
  vEdit.Width := vWidth;
  vEdit.ui := 'cupertino';
  vEdit.Top := ATop;
end;

procedure TfrmRelatorio.CampoDE_ATE(ANome, AVisible: string;
  var ATop: integer; AParent: TWinControl);
var
  vDatePicker, vDatePicker1: TRxJqDatePicker;
  vLabel: TRaLabel;

begin

  vDatePicker := TRxJqDatePicker.Create(Owner);
  vDatePicker.Parent := AParent;
  vDatePicker.Name := ANome + 'DE';
  vDatePicker.Left := 300;
  vDatePicker.ui := 'cupertino';
  vDatePicker.Top := ATop;

  vLabel := TRaLabel.Create(Owner);
  vLabel.Parent := AParent;
  vLabel.Caption := 'Até';
  vLabel.Name := ANome;
  vLabel.Left := 300 + 1 * 128;
  vLabel.AutoSize := True;
  vLabel.AutoSizeDelayed;
  vLabel.Top := ATop + 8;

  vDatePicker1 := TRxJqDatePicker.Create(Owner);
  vDatePicker1.Parent := AParent;
  vDatePicker1.Name := ANome + 'Ate';
  vDatePicker1.Left := 300 + 1 * 150;
  vDatePicker1.ui := 'cupertino';
  vDatePicker1.Top := ATop;
end;

constructor TfrmRelatorio.Create(AOwner: TComponent);
//var
//  a: integer;
//  strCaption: string;
begin
  inherited Create(AOwner);

//  btnImprimir.Left := (frmPrincipal.fraContainer.Width - btnImprimir.Width) div 2;
  onShow(Self);
end;

initialization
  {$I untrelatorio.lrs}
  RegisterClass(TfrmRelatorio);

finalization
  UnRegisterClass(TfrmRelatorio);
end.
