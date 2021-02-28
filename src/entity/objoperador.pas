unit objOperador;

{$mode objfpc}{$H+}

interface

uses
  dbutils, dOpf, dSQLdbBroker, SysUtils;

type
  EOperador = class(Exception);

type
  { TOperador }
  TOperador = class(TObject)
  private
    FId: int64;
    FLoginAD: string;
    FNome: string;
    FEmail: string;
    FDtCadastro: string;
    FCadastradoPor: string;
    FSenha: string;
    FAcessoAD: int64;
  public
    procedure Validate;
  published
    property Id: int64 read FId write FId;
    property Nome: string read FNome write FNome;
    property LoginAD: string read FLoginAD write FLoginAD;
    property Email: string read FEmail write FEmail;
    property DtCadastro: string read FDtCadastro write FDtCadastro;
    property CadastradoPor: string read FCadastradoPor write FCadastradoPor;
    property Senha: string read FSenha write FSenha;
    property AcessoAD: int64 read FAcessoAD write FAcessoAD;
  end;

  { TOperadorOpf }
  TOperadorOpf = class(specialize TdGSQLdbEntityOpf<TOperador>)
  protected
    procedure DoUpdating(AEntity: T3); override;
  public
    constructor Create; overload; virtual;
  end;

  Topf = specialize TdGSQLdbEntityOpf<TOperador>;

implementation

{ TOperador }

procedure TOperador.Validate;
begin

end;

{ TTOperadorOpf }

procedure TOperadorOpf.DoUpdating(AEntity: T3);
begin
  case UpdateKind of
    ukAdd, ukModify: AEntity.Validate;
  end;
end;

constructor TOperadorOpf.Create;
var
  FDbMapping: string;
begin
  FDbMapping := 'id:id,';
  FDbMapping := FDbMapping + 'LoginAD:USO_LOGIN,';
  FDbMapping := FDbMapping + 'Nome:USO_NOME,';
  FDbMapping := FDbMapping + 'Email:USO_EMAIL,';
  FDbMapping := FDbMapping + 'DtCadastro:USO_DTCADASTRO,';
  FDbMapping := FDbMapping + 'CadastradoPor:USO_NMCADASTRO,';
  FDbMapping := FDbMapping + 'Senha:USO_SENHA,';
  FDbMapping := FDbMapping + 'AcessoAD:USO_ACESSOAD';

  inherited Create(dbutils.con, 'USUARIO_USO', FDbMapping);
end;

end.

