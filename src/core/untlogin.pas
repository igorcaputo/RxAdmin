unit untLogin;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, LResources, RaBase, RaControlsVCL,
  RaApplication,Forms,
  Classes, objUsuario;

type

  { TfrmLogin }

  TfrmLogin = class(TRaFormCompatible)
    edtSenha: TRaEdit;
    edtUsuario: TRaEdit;
    imgLogo: TRaImage;
    lblSenha: TRaLabel;
    lblUsuario: TRaLabel;
    RaApplicationEvents1: TRaApplicationEvents;
    lblEsqueciSenha: TRaLabel;
    lblAviso: TRaLabel;
    lblQRCode: TRaLabel;
    btnAcessar: TRaButton;
    RaIntervalTimer1: TRaIntervalTimer;
    lblNome: TRaLabel;
    RaPanel1: TRaPanel;
    Login_cfg: TRaPanel;
    procedure FormActivate(Sender: TObject);
    procedure Login_cfgAjaxRequest(Sender: TComponent; EventName: string;
      Params: TRaStrings);
    procedure btnAcessarClick(Sender: TObject);
    procedure showPrincipal;
  private
    { private declarations }
    FDbMapping: string;
  public
    { public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

uses untprincipal, objDynamicForm, dbutils, Utils, libBusca;

{ TfrmLogin }

procedure TfrmLogin.btnAcessarClick(Sender: TObject);
var
  Usuario: TUsuario;
  UsuarioOpf: TUsuarioOpf;
  UsuarioEntity: TUsuarioOpf.TEntities;

begin

  if (edtUsuario.Text <> '') and (edtSenha.Text <> '') then
    if BuscaCampo('select USO_ACESSOAD from USUARIO_USO where upper(USO_LOGIN)=',
      UpperCase(edtUsuario.Text), 'USO_ACESSOAD') = '0' then
    begin
      try
        Usuario := TUsuario.Create;
        UsuarioOpf := TUsuarioOpf.Create;
        UsuarioEntity := TUsuarioOpf.TEntities.Create;

        UsuarioOpf.Entity.Nome := UpperCase(edtUsuario.Text);
        UsuarioOpf.Entity.Senha := edtSenha.Text;
        UsuarioOpf.Find(UsuarioEntity, 'upper(USO_login) =:nome and USO_senha =:senha');

        for Usuario in UsuarioEntity do
          WriteLn(Usuario.Id);

        if ((UpperCase(Usuario.LoginAD) = UpperCase(edtUsuario.Text)) and
          (Usuario.Senha = edtSenha.Text)) then
          begin
          showPrincipal;
          end
        else
          lblAviso.Caption := 'Usuário ou senha inválidos!';
      finally
        FreeAndNil(Usuario);
        FreeAndNil(UsuarioOpf);
      end;

    end
    else
    if IsAuthenticated('cnseg.int', edtUsuario.Text, edtSenha.Text) = true then
      showPrincipal
    else
      lblAviso.Caption := 'Usuário ou senha inválidos!';
end;

procedure TfrmLogin.Login_cfgAjaxRequest(Sender: TComponent; EventName: string;
  Params: TRaStrings);
begin
  FDbMapping := 'id:id,';
  FDbMapping := FDbMapping + 'LoginAD:USO_LOGIN,';
  FDbMapping := FDbMapping + 'Nome:USO_NOME,';
  FDbMapping := FDbMapping + 'Email:USO_EMAIL,';
  FDbMapping := FDbMapping + 'DtCadastro:USO_DTCADASTRO,';
  FDbMapping := FDbMapping + 'CadastradoPor:USO_NMCADASTRO,';
  FDbMapping := FDbMapping + 'Senha:USO_SENHA,';
  FDbMapping := FDbMapping + 'AcessoAD:USO_ACESSOAD';
end;

procedure TfrmLogin.FormActivate(Sender: TObject);
var
  FConfig: TDynamicForm;
  parametro:string;
begin
  parametro:=RaApplication.Application.GateQueryParams;

  FConfig := TDynamicForm.Create;
  FConfig.LoadSetting(Self);
  FConfig.Free;
end;

procedure TfrmLogin.showPrincipal;
var
  VfrmPrincipal: TDynamicForm;
begin
  VfrmPrincipal := TDynamicForm.Create;
  VfrmPrincipal.LoadForm('TfrmPrincipal', Self, False, []);
  LimparCampos(Self);
  lblAviso.Caption := '';
end;

initialization
  {$I untlogin.lrs}

end.
