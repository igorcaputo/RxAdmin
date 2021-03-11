unit objBusca;

{$mode objfpc}{$H+}

interface

uses
  dbutils, dOpf, dSQLdbBroker, SysUtils;

type

  { TSisBusca }
  TSisBusca = class(TObject)
  private
    FCodigo: string;
    FConsulta: string;
    FRetorno: string;
  public
    destructor Destroy; override;
  published
    property Codigo: string read FCodigo write FCodigo;
    property Consulta: string read FConsulta write FConsulta;
    property Retorno: string read FRetorno write FRetorno;
  end;

implementation

{ TSisBusca }

destructor TSisBusca.Destroy;
begin
  inherited Destroy;
end;

end.

