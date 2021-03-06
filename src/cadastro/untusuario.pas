unit untusuario;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, RaApplication, RaBase, RaControlsVCL,
  untFrameDefault, objUsuario;

type
  { TfrmUsuario }

  TfrmUsuario = class(TFrameDefault)
    btnExcluir: TRaButton;
    btnGravar: TRaButton;
    edtLoginAD: TRaEdit;
    edtNome: TRaEdit;
    edtEmail: TRaEdit;
    lbLoginAD: TRaLabel;
    lbNome: TRaLabel;
    lbEmail: TRaLabel;
    pnlConfirma: TRaPanel;
    RaBitButton1: TRaBitButton;
    edtSenha: TRaEdit;
    edtConfirmaSenha: TRaEdit;
    lbSenha: TRaLabel;
    lbConfirmacao: TRaLabel;
    lbConfirma: TRaLabel;
    ckbAD: TRaCheckBox;
    procedure btnExcluirClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure ckbADClick(Sender: TObject);
    procedure edtConfirmaSenhaChange(Sender: TObject);
    procedure edtLoginADEnter(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RaBitButton1Click(Sender: TObject);
  private
    Usuario: TUsuario;
    UsuarioOpf: TUsuarioOpf;
    edtID: TRaEdit;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmUsuario: TfrmUsuario;

implementation
{$R *.lfm}

uses libBusca,
  Utils, dbutils;

{ TfrmUsuario }

procedure TfrmUsuario.FormShow(Sender: TObject);
begin
  lbSenha.Visible := false;
  edtSenha.Visible := false;
  lbConfirmacao.Visible := false;
  edtConfirmaSenha.Visible := false;
end;

procedure TfrmUsuario.btnExcluirClick(Sender: TObject);
begin
  Usuario := TUsuario.Create;
  UsuarioOpf := TUsuarioOpf.Create;

  try
    if edtID.Text <> '' then
    begin
      Usuario.Id := StrToInt(edtID.Text);
      UsuarioOpf.Remove(Usuario);
      UsuarioOpf.Commit;
    end;

    LimparCampos(Self);
  finally
    Usuario.Free;
    UsuarioOpf.Free;
    edtID.Text := '';
  end;
end;

procedure TfrmUsuario.btnGravarClick(Sender: TObject);
begin
  Usuario := TUsuario.Create;
  UsuarioOpf := TUsuarioOpf.Create;

  try
    if edtID.Text <> '' then
      Usuario.Id := StrToInt(edtID.Text);

    Usuario.LoginAD := UpperCase(edtLoginAD.Text);
    Usuario.Nome := edtNome.Text;
    Usuario.Email := LowerCase(edtEmail.Text);
    Usuario.DtCadastro := DateTimeToStr(Now);
    Usuario.CadastradoPor := 'SysBlockAD';
    Usuario.Senha := edtSenha.Text;

    if ckbAD.Checked
    then Usuario.AcessoAD:=0
    else Usuario.AcessoAD:=1;

    if Usuario.Id > 0 then
      UsuarioOpf.Modify(Usuario)
    else
      UsuarioOpf.Add(Usuario);

    UsuarioOpf.Commit;

    LimparCampos(Self);
  finally
    Usuario.Free;
    UsuarioOpf.Free;
    edtID.Text := '';
  end;
end;

procedure TfrmUsuario.ckbADClick(Sender: TObject);
begin
  lbSenha.Visible := ckbAD.Checked;
  edtSenha.Visible := ckbAD.Checked;
  lbConfirmacao.Visible := ckbAD.Checked;
  edtConfirmaSenha.Visible := ckbAD.Checked;
end;

procedure TfrmUsuario.edtConfirmaSenhaChange(Sender: TObject);
begin
  if (edtSenha.Text <> edtConfirmaSenha.Text) then
  begin
    lbConfirma.Visible := True;
    lbConfirma.Caption := 'Senha não conferi!';
  end
  else
    lbConfirma.Visible := False;
end;

procedure TfrmUsuario.edtLoginADEnter(Sender: TObject);
begin
  try
    if edtID.Text <> '' then
    begin
      UsuarioOpf := TUsuarioOpf.Create;
      UsuarioOpf.Entity.Id := StrToInt(edtID.Text);
      UsuarioOpf.Get;

      edtLoginAD.Text := UsuarioOpf.Entity.LoginAD;
      edtNome.Text := UsuarioOpf.Entity.Nome;
      edtEmail.Text := UsuarioOpf.Entity.Email;
    end;

  finally
    UsuarioOpf.Free;
  end;
end;

procedure TfrmUsuario.RaBitButton1Click(Sender: TObject);
var
  VRetorno: TRetornoArray;

begin
  VRetorno := TRetornoArray.Create;
  SetLength(VRetorno, 3);
  VRetorno[0] := 'id';
  VRetorno[1] := 'Login';
  VRetorno[2] := 'Nome';

  Pesquisa(True, 'select id,USO_LOGIN as Login,USO_NOME as Nome from USUARIO_USO',
    'Usuario', VRetorno, edtID, edtLoginAD);

  edtLoginAD.SetFocus;
end;

constructor TfrmUsuario.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  edtID := TRaEdit.Create(Self);
end;

initialization
  RegisterClass(TfrmUsuario);

finalization
  UnRegisterClass(TfrmUsuario);

end.

