unit untPesquisa;

{$mode objfpc}{$H+}
{$DEFINE RAUDUS}

interface

uses
  Classes, SysUtils, FileUtil, LResources, RaApplication, RaBase, RaControlsVCL,
  sqldb, Controls,
  dUtils, dSQLdbBroker, DB, Forms;

type
  TRetornoArray = array of string;

  { TfrmPesquisa }
  TfrmPesquisa = class(TRaFormCompatible)
    ComboBox1: TRaComboBox;
    dtsBusca: TDataSource;
    edtCondicao: TRaEdit;
    Panel1: TRaPanel;
    RaApplicationEvents1: TRaApplicationEvents;
    dbGrid1: TRaDBGrid;

    FQuery: TdSQLdbQuery;
    con: TdSQLdbConnector;
    btnBusca: TRaBitButton;

    procedure btnBuscaClick(Sender: TObject);
    procedure dtsBuscaDataChange(Sender: TObject; Field: TField);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure RaApplicationEvents1FormCreate(Sender: TObject);
  private
    { Private declarations }
    bLoading: boolean;
    Compara: string;
    IndexINI: string;
    CampoRET: TRetornoArray;
    FId: TRaEdit;
    FCampo1: TRaEdit;
    FCampoDb: TRaDBEdit;
    FFramework: boolean;
    SQL: string;
    aMensagem: string;
    Exec_1: boolean; //Se for a primeira vez da execucao da query
    AbrirConteudo: boolean;
  public
  published
    property Framework: boolean read FFramework write FFramework;
    property Indice_Inicial: string read IndexINI write IndexINI;
    property Campo_Retorno: TRetornoArray read CampoRET write CampoRET;
    property Id: TRaEdit read FId write FId;
    property Campo1: TRaEdit read FCampo1 write FCampo1;
    property CampoDb: TRaDBEdit read FCampoDb write FCampoDb;
    property Select: string read SQL write SQL;
    property Mensagem: string read aMensagem write aMensagem;
    property Abrir_Conteudo: boolean
      read AbrirConteudo write AbrirConteudo default False;
  end;

var
  frmPesquisa: TfrmPesquisa;

implementation

uses Utils, dbutils;

{ TfrmPesquisa }
procedure TfrmPesquisa.FormShow(Sender: TObject);

  function TiraAspas(oTexto: string): string;
  var
    Ret: string;
    I: integer;
  begin
    Ret := '';
    for I := 1 to Length(oTexto) - 1 do
    begin
      if oTexto[I] <> '"' then
        Ret := Ret + oTexto[I];
    end;
    if Ret[Length(Ret)] in ['1', '2', '3', '4', '5'] then
      Ret := Copy(Ret, 1, Length(ret) - 1);
    Result := Ret;
  end;

var
  I: integer;
  oSelect, aOrdem, Condicao_zero: string;
begin
  Caption := 'Pesquisa (' + Caption + ')';

  FQuery.Close;
  FQuery.SQL.Clear;

  //Coloca condicao para nao retornar nenhum registro

  //Olha se tem ORDER
  aOrdem := '';
  if Pos('ORDER BY', AnsiUpperCase(Select)) > 0 then
  begin
    oSelect := Copy(Select, 1, Pos('ORDER BY', AnsiUpperCase(Select)) - 1);
    aOrdem := Copy(Select, Pos('ORDER BY', AnsiUpperCase(Select)), Length(Select));
  end
  else
  begin
    oSelect := AnsiUpperCase(Select);
    aOrdem := '';
  end;
  Condicao_zero := '';
  if not Abrir_Conteudo then
    Condicao_zero := ' AND ' + Campo_Retorno[0] + ' IS NOT NULL '; // LIMIT 20
  if Pos('WHERE', AnsiUpperCase(oSelect)) > 0 then
  begin
    //oSelect := oSelect + CRI;
    FQuery.SQL.Add(oSelect + Condicao_zero + aOrdem);
    FQuery.SQL.SaveToFile('aaa.txt');
  end
  else
  begin
    //oSelect := oSelect + ' WHERE ' + Copy(CRI, 6, Length(CRI));
    FQuery.SQL.Add(oSelect + ' WHERE ' + Copy(Condicao_zero,
      6, Length(Condicao_zero)) + aOrdem);
  end;
  //WriteLn(FQuery.sql.Strings[0]);
  FQuery.SQL.SaveToFile('aaa.txt');
  FQuery.Open;
  Compara := dtsBusca.DataSet.FieldByName(CampoRET[0]).AsString;
  bLoading := True;

  Exec_1 := True; //Executa pela 1 vez

  ComboBox1.Items.Clear;
  for I := 0 to FQuery.Fields.Count - 1 do
  begin
    if (FQuery.FieldDefs[I].Name) <> '' then
    begin
      ComboBox1.Items.Add(FQuery.FieldDefs[I].Name);
      if (UpperCase(FQuery.FieldDefs[I].Name) = UpperCase(Indice_Inicial)) or
        (UpperCase(TiraAspas(FQuery.FieldDefs[I].Name)) =
        UpperCase(Indice_Inicial)) then
        ComboBox1.ItemIndex := I;
    end;
  end;
  edtCondicao.SetFocus;
  FQuery.Active := True;

end;

procedure TfrmPesquisa.RaApplicationEvents1FormCreate(Sender: TObject);
begin
  con := dbutils.con;
  FQuery := TdSQLdbQuery.Create(con);
  con.Connect;

  dtsBusca.DataSet := FQuery.DataSet;
  dbGrid1.DataSource := dtsBusca;
end;

procedure TfrmPesquisa.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  VRetorno: string;
begin
  //  for VRetorno in CampoRET do
  //    writeln(VRetorno);

  if Assigned(CampoDb) then
    CampoDb.Caption := dtsBusca.DataSet.FieldByName(CampoRET[0]).AsString;

  writeln(dtsBusca.DataSet.FieldByName(CampoRET[0]).AsString);
  if (dtsBusca.DataSet.RecordCount > 0) then
  begin
    Id.Text := dtsBusca.DataSet.FieldByName(CampoRET[0]).AsString;
  end;

  if length(CampoRET) >= 2 then
    Campo1.Text := dtsBusca.DataSet.FieldByName(CampoRET[1]).AsString;

  //  if Framework then
  //    Campo.OnExit(Sender);

  con.Disconnect;
end;

procedure TfrmPesquisa.btnBuscaClick(Sender: TObject);
begin
  if (ComboBox1.Text <> '') then
  begin
    FQuery.Active := False;
    FQuery.SQL.Clear;
    FQuery.SQL.Text := SQL + ' WHERE ' + ComboBox1.Text + ' LIKE ' +
      QuotedStr(StringReplace('%' + edtCondicao.Text + '%', ' ', '%', [rfReplaceAll])) +
      '  LIMIT 100';
    //writeln(FQuery.SQL.Text);
    FQuery.Open;
    FQuery.Active := True;

    Compara := dtsBusca.DataSet.FieldByName(CampoRET[0]).AsString;
    bLoading := True;

    dtsBusca.DataSet := FQuery.DataSet;
    dbGrid1.DataSource := dtsBusca;
  end;
end;

procedure TfrmPesquisa.dtsBuscaDataChange(Sender: TObject; Field: TField);
begin
  if dtsBusca.State in [dsEdit, dsInsert, dsOpening, dsBrowse] then
    if (bLoading) then
    begin
      bLoading := False;
      //  if (Compara <> dtsBusca.DataSet.Fields[0].AsString) then
      //    Close;
    end;
end;

initialization
  {$I untpesquisa.lrs}

end.
