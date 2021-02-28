unit untLogin;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, LResources, RaBase, RaControlsVCL,
  RaApplication,Forms,
  Classes, objOperador;

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
    pnlLogin: TRaPanel;
    procedure FormActivate(Sender: TObject);
    procedure pnlLoginAjaxRequest(Sender: TComponent; EventName: string;
      Params: TRaStrings);
    procedure btnAcessarClick(Sender: TObject);
    procedure RaIntervalTimer1Tick(Sender: TObject);
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
  Operador: TOperador;
  OperadorOpf: TOperadorOpf;
  OperadorEntity: TOperadorOpf.TEntities;

begin

  if (edtUsuario.Text <> '') and (edtSenha.Text <> '') then
    if BuscaCampo('select OPR_ACESSOAD from OPERADOR_OPR where upper(OPR_LOGIN)=',
      UpperCase(edtUsuario.Text), 'OPR_ACESSOAD') = '0' then
    begin
      try
        Operador := TOperador.Create;
        OperadorOpf := TOperadorOpf.Create;
        OperadorEntity := TOperadorOpf.TEntities.Create;

        OperadorOpf.Entity.Nome := UpperCase(edtUsuario.Text);
        OperadorOpf.Entity.Senha := edtSenha.Text;
        OperadorOpf.Find(OperadorEntity, 'upper(opr_login) =:nome and opr_senha =:senha');

        for Operador in OperadorEntity do
          WriteLn(Operador.Id);

        if ((UpperCase(Operador.LoginAD) = UpperCase(edtUsuario.Text)) and
          (Operador.Senha = edtSenha.Text)) then
          begin
          showPrincipal;
          end
        else
          lblAviso.Caption := 'Usuário ou senha inválidos!';
      finally
        FreeAndNil(Operador);
        FreeAndNil(OperadorOpf);
      end;

    end
    else
    if IsAuthenticated('cnseg.int', edtUsuario.Text, edtSenha.Text) = true then
      showPrincipal
    else
      lblAviso.Caption := 'Usuário ou senha inválidos!';
end;

procedure TfrmLogin.pnlLoginAjaxRequest(Sender: TComponent; EventName: string;
  Params: TRaStrings);
begin
  FDbMapping := 'id:id,';
  FDbMapping := FDbMapping + 'LoginAD:OPR_LOGIN,';
  FDbMapping := FDbMapping + 'Nome:OPR_NOME,';
  FDbMapping := FDbMapping + 'Email:OPR_EMAIL,';
  FDbMapping := FDbMapping + 'DtCadastro:OPR_DTCADASTRO,';
  FDbMapping := FDbMapping + 'CadastradoPor:OPR_NMCADASTRO,';
  FDbMapping := FDbMapping + 'Senha:OPR_SENHA,';
  FDbMapping := FDbMapping + 'AcessoAD:OPR_ACESSOAD';
end;

procedure TfrmLogin.FormActivate(Sender: TObject);
//var
//  parametro:string;
begin
//  parametro:=RaApplication.Application.GateQueryParams[1];
end;

//RaApplication.application.BrowserWindowOpen('http://bol.com.br');
//CheckAccess('Limited','leonardorame','lrame123');

procedure TfrmLogin.RaIntervalTimer1Tick(Sender: TObject);
begin
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
