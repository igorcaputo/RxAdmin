unit libBusca;

{$mode objfpc}{$H+}

interface

uses
  dSQLdbBroker,
  mysql56conn,
  dUtils, SysUtils, untPesquisa, RaControlsVCL, Forms,
  Classes, FileUtil, LResources,
  dbutils, Utils;

type
  TRetornoArray = array of string;

  TCampo1 = class
    Referencia: string;
    Descricao: string;
  end;

//var  Dictionary: TDictionary<String, TCampo>;

const
  AJAXREQUEST = '<a href="#" onclick="Rfe.ajaxRequest(#id_controle, #command, [])">#desc</a>';
  MSG_ALERTA = 'Os campos abaixo, são de preenchimento obrigatório' + '</br>' + 'Número do pedido' + '</br>' + 'Código do representante' + '</br>' + 'Código do cliente' + '</br>' + 'Código do transportador';
  MSG_ALERTA_ENTRADA = 'Os campos abaixo, são de preenchimento obrigatório' + '</br>' + 'Número do documento' + '</br>' + 'Data de emissão' + '</br>' + 'Estoque' + '</br>' + 'Almoxarifado';

procedure Alerta(var AAlerta:TRaListBox);
function BuscaCampo(AQuery, ACampo, ARetorna: string): string;
procedure Pesquisa(AFramework: boolean; AQuery, ACaption: string; ARetorno: TRetornoArray; var ACampo: TRaEdit; var ACampo1: TRaEdit);

function valida(AQuery: string; ATipo: integer): boolean;

implementation

function valida(AQuery: string; ATipo: integer): boolean;
var
  I: integer;
  con: TdSQLdbConnector;
  qry: TdSQLdbQuery;
begin
  try
    con := dbutils.con;
    qry := TdSQLdbQuery.Create(con);
    qry.SQL.Text := AQuery;
    qry.Open;

    if qry.Count <= 0
      then Result := true
      else Result := false;

  finally
    con.Disconnect;
    FreeAndNil(qry);
  end;
end;

procedure Alerta(var AAlerta: TRaListBox);
var
  con: TdSQLdbConnector;
  qry: TdSQLdbQuery;
  AQuery:string;
begin
  con := TdSQLdbConnector.Create(nil);
  qry := TdSQLdbQuery.Create(con);
  try
    con := dbutils.con;
    con.Connect;

    AQuery := ' SELECT count(*) as minimo FROM ( ';
    AQuery := AQuery + 'SELECT PRD_CODIGO,SUM(ENTRADA) AS ENTRADA,SUM(SAIDA) AS SAIDA, SUM(RESERVADO) AS RESERVADO, (SUM(ENTRADA) - (SUM(SAIDA) +  SUM(RESERVADO))) AS SALDO, SUM(FALTA) AS FALTA, SUM(PRD_QTDMINIMA) AS QTDMINIMA  FROM ( ';
    AQuery := AQuery + '    SELECT ';
    AQuery := AQuery + '      PRD_CODIGO, ';
    AQuery := AQuery + '      PRD_QTDMINIMA, ';
    AQuery := AQuery + '      MST_TIPO, ';
    AQuery := AQuery + '      ifnull(CASE MST_TIPO WHEN ''E'' THEN SUM(MST_QTDINICIAL) END ,0)  AS ENTRADA, ';
    AQuery := AQuery + '      ifnull(CASE MST_TIPO WHEN ''S'' THEN SUM(MST_QTDINICIAL) END ,0)  AS SAIDA, ';
    AQuery := AQuery + '      ifnull(CASE MST_TIPO WHEN ''R'' THEN SUM(MST_QTDINICIAL) END ,0)  AS RESERVADO, ';
    AQuery := AQuery + '      ifnull(CASE MST_TIPO WHEN ''F'' THEN SUM(MST_QTDINICIAL) END ,0)  AS FALTA ';
    AQuery := AQuery + '      FROM ITENSMOVIMENTO_MST ';
    AQuery := AQuery + '      INNER JOIN PRODUTO_PRD PRD ON (PRODUTO=PRD.ID) ';
    AQuery := AQuery + '    GROUP BY PRD_CODIGO,MST_TIPO ';
    AQuery := AQuery + '    ) TMP ';
    AQuery := AQuery + '    GROUP BY PRD_CODIGO ';
    AQuery := AQuery + ') TMP1   WHERE SALDO < QTDMINIMA ';

    qry.SQL.Text := AQuery;
    qry.Open;
    qry.First;

    while not qry.EOF do
    begin
      AAlerta.items.add('Existem ' + qry.Fields.FieldByName('minimo').AsString + ' itens com o saldo abaixo do estoque mínimo!');
      qry.Next;
    end;

  finally
    con.Disconnect;
    con.FreeOnRelease;
    qry.FreeOnRelease;
  end;
end;

function BuscaCampo(AQuery, ACampo, ARetorna: string): string;
var
  con: TdSQLdbConnector;
  qry: TdSQLdbQuery;
begin
  con := dbutils.con;
 // con := TdSQLdbConnector.Create(nil);
  qry := TdSQLdbQuery.Create(con);
  try

    con.Connect;
    qry.SQL.Clear;
    qry.SQL.Text := AQuery + QuotedStr(ACampo);
    qry.Open;
    qry.First;
    while not qry.EOF do
    begin
      Result := qry.Fields.FieldByName(ARetorna).AsString;
      qry.Next;
    end;

    if qry.Count <= 0 then
      Result := '';

  finally
    con.Disconnect;
    con.FreeOnRelease;
    qry.FreeOnRelease;
  end;
end;

procedure Pesquisa(AFramework: boolean; AQuery, ACaption: string; ARetorno: TRetornoArray; var ACampo: TRaEdit; var ACampo1: TRaEdit);
var
  FrmPesquisa: TFrmPesquisa;
  VRetorno: string;
  VCampo: TRaEdit;
begin
  FrmPesquisa := TFrmPesquisa.Create(nil);
  FrmPesquisa.Framework := AFramework;
  FrmPesquisa.Indice_Inicial := 'Codigo';
  FrmPesquisa.Select := AQuery;
  FrmPesquisa.Caption := ACaption;
  FrmPesquisa.Campo_Retorno := ARetorno;
  FrmPesquisa.Id := ACampo;
  FrmPesquisa.Campo1 := ACampo1;
  FrmPesquisa.UI := 'cupertino';
  FrmPesquisa.ShowModalNonBlocking;
end;

end.
