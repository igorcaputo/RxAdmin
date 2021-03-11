unit objGeradorRelatorio;

{$mode objfpc}{$H+}

interface

uses
  dbutils, dOpf, dSQLdbBroker, SysUtils;

type

  { TRelParametro }
  TRelParametro = class(TObject)
  private
    FCodigo: string;
    FNome: string;
    FTamanho: integer;
    FOrdem: integer;
    FTipo: string;
    FVisivel: string;
    FBusca: string;
  public
    destructor Destroy; override;
  published
    property Codigo: string read FCodigo write FCodigo;
    property Nome: string read FNome write FNome;
    property Tamanho: integer read FTamanho write FTamanho;
    property Ordem: integer read FOrdem write FOrdem;
    property Tipo: string read FTipo write FTipo;
    property Visivel: string read FVisivel write FVisivel;
    property Busca: string read FBusca write FBusca;
  end;

  { TRelCampo }
  TRelCampo = class(TObject)
  private
    FCodigo: string;
    FNome: string;
    FTamanho: integer;
    FOrdem: integer;
    FTipo: string;
    FVisivel: string;
  public
    destructor Destroy; override;
  published
    property Codigo: string read FCodigo write FCodigo;
    property Nome: string read FNome write FNome;
    property Tamanho: integer read FTamanho write FTamanho;
    property Ordem: integer read FOrdem write FOrdem;
    property Tipo: string read FTipo write FTipo;
    property Visivel: string read FVisivel write FVisivel;
  end;

  { TRelatorio }
  TRelatorio = class(TObject)
  private
    FCodigo: string;
    FNome: string;
    FDrive: string;
    FHostname: string;
    FDatabase: string;
    FUsername: string;
    FPassword: string;
  public
    destructor Destroy; override;
  published
    property Codigo: string read FCodigo write FCodigo;
    property Nome: string read FNome write FNome;
    property Drive: string read FDrive write FDrive;
    property Hostname: string read FHostname write FHostname;
    property Database: string read FDatabase write FDatabase;
    property Username: string read FUsername write FUsername;
    property Password: string read FPassword write FPassword;
  end;

  { TRelConsulta }
  TRelConsulta = class(TObject)
  private
    FDescricao: string;
    FConsulta: string;
    FRelatorio: TRelatorio;
    FModelo: string;
    function GetRelatorio: TRelatorio;
    procedure SetRelatorio(AValue: TRelatorio);
  public
    destructor Destroy; override;
  published
    property Descricao: string read FDescricao write FDescricao;
    property Consulta: string read FConsulta write FConsulta;
    property Relatorio: TRelatorio read GetRelatorio write SetRelatorio;
    property Modelo: string read FModelo write FModelo;
  end;

implementation

{ TRelParametro }

destructor TRelParametro.Destroy;
begin
  inherited Destroy;
end;

{ TRelCampo }

destructor TRelCampo.Destroy;
begin
  inherited Destroy;
end;


{ TRelConsulta }

function TRelConsulta.GetRelatorio: TRelatorio;
begin

end;

procedure TRelConsulta.SetRelatorio(AValue: TRelatorio);
begin

end;

destructor TRelConsulta.Destroy;
begin
  inherited Destroy;
end;

{ Relatorio }

destructor TRelatorio.Destroy;
begin
  inherited Destroy;
end;

end.



