unit objUsuario;

{$mode objfpc}{$H+}

interface

uses
  sysutils,
  fgl,
  JCoreEntity,
  JCoreOPFConfig,
  objPessoa;

type
  { TUsuario }
  TUsuario = class(TJCoreEntity)
  private
    FLogin: string;
    FNome: string;
    FEmail: string;
    FSenha: string;
    FVendedor: string;
    FPessoa: TPessoa;
    function GetPessoa: TPessoa;
    procedure SetPessoa(AValue: TPessoa);
  public
    destructor Destroy; override;
    procedure SetMetadata(VAR AConfig: IJCoreOPFConfiguration);
  published
    property Login: string read FLogin write FLogin;
    property Nome: string read FNome write FNome;
    property Email: string read FEmail write FEmail;
    property Senha: string read FSenha write FSenha;
    property Vendedor: string read FVendedor write FVendedor;
    property Pessoa: TPessoa read GetPessoa write SetPessoa;
  end;

implementation

{ Almoxarifado }

function TUsuario.GetPessoa: TPessoa;
begin
  if not _proxy.Lazyload(@FPessoa) then
    FPessoa := TPessoa.Create;
  Result := FPessoa;
end;

procedure TUsuario.SetPessoa(AValue: TPessoa);
begin
  FreeAndNil(FPessoa);
  FPessoa := AValue;
end;

destructor TUsuario.Destroy;
begin
  inherited Destroy;
end;

procedure TUsuario.SetMetadata(var AConfig: IJCoreOPFConfiguration);
begin
  (*
  sqlite
  CREATE TABLE USUARIO_USU (
      id            VARCHAR(32), PRIMARY KEY,
      USU_LOGIN     VARCHAR (40)       UNIQUE,
      USU_NOME      VARCHAR (60),
      USU_EMAIL     VARCHAR(150),
      USU_SENHA     VARCHAR (10),
      USU_VENDEDOR  VARCHAR(1)
  );

  mysqql

  CREATE TABLE `usuario_usu` (
	`id` VARCHAR(32) NOT NULL COLLATE 'utf8_general_ci',
	`USU_LOGIN` VARCHAR(40) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`USU_NOME` VARCHAR(60) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`USU_EMAIL` VARCHAR(150) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`USU_SENHA` VARCHAR(10) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`USU_VENDEDOR` VARCHAR(1) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `USU_LOGIN` (`USU_LOGIN`) USING BTREE
  )
  COLLATE='utf8_general_ci'
  ENGINE=InnoDB;
  *)

  AConfig.Model.AcquireMetadata(TUsuario).TableName := 'USUARIO_USU';
  AConfig.Model.AcquireAttrMetadata(TUsuario, 'Login').PersistentFieldName := 'USU_LOGIN';
  AConfig.Model.AcquireAttrMetadata(TUsuario, 'Nome').PersistentFieldName := 'USU_NOME';
  AConfig.Model.AcquireAttrMetadata(TUsuario, 'Email').PersistentFieldName := 'USU_EMAIL';
  AConfig.Model.AcquireAttrMetadata(TUsuario, 'Senha').PersistentFieldName := 'USU_SENHA';
  AConfig.Model.AcquireAttrMetadata(TUsuario, 'Vendedor').PersistentFieldName := 'USU_VENDEDOR';
end;
end.



