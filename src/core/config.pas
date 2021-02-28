unit Config;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  mysql56conn,
  dUtils,
//  sqlite3conn,
//  JCoreOPFMySQL,
  sqldb, DB, JCoreLogger, JCoreOPFConfig, JCoreOPFSession,
  JCoreOPFMappingSQL,
  JCoreOPFDriverSQLdb;

type
  { TConfig }
  TConfig = class(TObject)
  private
  protected
    Flog: IJCoreLogger;
    FConfig: IJCoreOPFConfiguration;
    FSession: IJCoreOPFSession;

  public
    constructor Create;
    destructor Destroy; override;
    property Config: IJCoreOPFConfiguration read FConfig write FConfig;
  end;

var
  VDatabaseName: String; // set in DPR
  Vid: String; // set in DPR

implementation

uses objProduto, objEstoque,objAlmoxarifado,objPessoa,Utils,libBusca, untPesquisa, objMovimento,
  objUnidade, objGrupo, objFormaPagamento, objMarca, objCfop, objNCM, objLocalizacao, objCEST, objPedVenda,
  objEndereco, objContato, objUsuario, objBuscaItem, objGeradorRelatorio;

{ TConfig }

constructor TConfig.Create;
begin
  FConfig := TJCoreOPFConfiguration.Create;
//  FConfig.Params.Values['connection'] := 'sqlite3';
//  FConfig.Params.Values['database'] := VDatabaseName;

  FConfig.Params.Values['connection'] := 'MySQL 5.6';
  FConfig.Params.Values['hostname'] := '127.0.0.1';
  FConfig.Params.Values['database'] := 'mobb';
  FConfig.Params.Values['username'] := 'root';
  FConfig.Params.Values['password'] := '';

  FConfig.DriverClass := TJCoreOPFDriverSQLdb;
  FConfig.AddMappingClass([TJCoreOPFSQLMapping]);
  FConfig.Model.AddClass([TUsuario,TEstoque, TItensMovimento, TMovimentoEstoque,TAlmoxarifado, TCest,
  TNcm,TUnidade, TGrupo, TFormaPagamento, TMarca, TLocalizacao, TProduto, TPedidoVenda ,TItemPedVenda,
  TPessoa, TPessoaFisica, TPessoaJuridica, TEndereco, TContato, TSaidaEstoque, TLocalizaItem, TRelatorio,TRelCampo,TRelConsulta]);
  FConfig.Model.AddGenerics(TItensMovimentoList, TItensMovimento);
  FConfig.Model.AddGenerics(TItemPedVendaList, TItemPedVenda);
  FConfig.Model.AddGenerics(TRelCampoList, TRelCampo);
  FConfig.Model.AddGenerics(TItensMovimentoList, TLocalizaItem);
  FConfig.Model.AddGenerics(TEnderecoList, TEndereco);
  FConfig.Model.AddGenerics(TContatoList, TContato);
end;

destructor TConfig.Destroy;
begin
  FreeAndNil(FSession);
  inherited Destroy;
end;

end.
