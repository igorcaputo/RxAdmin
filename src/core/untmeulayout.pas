unit untMeuLayout;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, RaControlsVCL,
  untFrameDefault, RaBase, RaApplication, LCLIntf,objMeuLayout;

type

  { TfrmMeuLayout }

  TfrmMeuLayout = class(TFrameDefault)
    btnAcessar: TRaBitButton;
    btnAreaTrabalho: TRaButton;
    btnAreaTrabalho_cfg: TRaPanel;
    btnListaCliente2: TRaButton;
    btnListaCliente3: TRaButton;
    btnListaFornecedores: TRaButton;
    ckbMenuBaixo: TRaCheckBox;
    edtSenha: TRaEdit;
    edtUsuario: TRaEdit;
    imgLogo: TRaImage;
    lblCorFonte: TRaLabel;
    lblCorFundo: TRaLabel;
    lblEsqueciSenha: TRaLabel;
    lblSenha: TRaLabel;
    lblUsuario: TRaLabel;
    Login: TRaButton;
    Login_cfg: TRaPanel;
    MenuLado_cfg: TRaPanel;
    RaButton14: TRaButton;
    RaButton15: TRaButton;
    ckbMenuLado: TRaCheckBox;
    RaImage1: TRaImage;
    RaLabel3: TRaLabel;
    RaLabel4: TRaLabel;
    RaOverlay1: TRaOverlay;
    RaPanel1: TRaPanel;
    RaPanel2: TRaPanel;
    RaTabSheet1: TRaTabSheet;
    SBMenuLayout: TRaScrollBox;
    SBMenuLayout1: TRaScrollBox;
    SiderPanel: TRaButton;
    Submenu: TRaButton;
    Menu: TRaButton;
    Menu_cfg: TRaPanel;
    Submenu_cfg: TRaPanel;
    Submenu_cfg1: TRaPanel;
    Submenu_cfg2: TRaPanel;
    Submenu_cfg3: TRaPanel;
    Submenu_cfg4: TRaPanel;
    Submenu_cfg5: TRaPanel;
    TopPanel: TRaButton;
    TopPanel_cfg: TRaPanel;
    SiderPanel_cfg: TRaPanel;
    pnlLateral2: TRaPanel;
    pnlMeuLayout: TRaPanel;
    RaTabControl1: TRaTabControl;
    tbsTelaLogin: TRaTabSheet;
    tbsTelaNavegacao: TRaTabSheet;
    procedure btnAcessarClick(Sender: TObject);
    procedure btnListaCliente2Click(Sender: TObject);
    procedure btnListaCliente3Click(Sender: TObject);
    procedure btnMudarCor(Sender: TObject);
    procedure lblCorFonteAjaxRequest(Sender: TComponent; EventName: string;
      Params: TRaStrings);
    procedure lblCorFundoAjaxRequest(Sender: TComponent; EventName: string;
      Params: TRaStrings);
    procedure ckbMenuLadoClick(Sender: TObject);
    procedure RaLabelCheckAjaxRequest(Sender: TComponent; EventName: string;
      Params: TRaStrings);
    procedure RaPanel2AjaxRequest(Sender: TComponent; EventName: string;
      Params: TRaStrings);
  private
    Botao:string;
    FDbMapping: string;
    MeuLayout: TMeuLayout;
    MeuLayoutOpf: TMeuLayoutOpf;
    edtID: TRaEdit;

    procedure loadSetting;
  public
    constructor Create(AOwner: TComponent); override;

  end;

implementation

{$R *.lfm}

{ TfrmMeuLayout }

procedure TfrmMeuLayout.RaLabelCheckAjaxRequest(Sender: TComponent;
  EventName: string; Params: TRaStrings);
var
  FColor: string;
begin
  FColor := StringReplace(Params.ValueFromIndex[0], '#', '', []);

  lblUsuario.Color := RGB(StrToInt('$' + Copy(FColor, 1, 2)),
                          StrToInt('$' + Copy(FColor, 3, 2)),
                          StrToInt('$' + Copy(FColor, 5, 2)));

  Login_cfg.Color := lblUsuario.Color;

end;

procedure TfrmMeuLayout.RaPanel2AjaxRequest(Sender: TComponent;
  EventName: string; Params: TRaStrings);
begin
  Params.Text := EventName;
  writeln(Params.Values['teste']);
end;

procedure TfrmMeuLayout.loadSetting;
var
   x:integer;
   FColor:TColor;
begin
  try
    MeuLayoutOpf := TMeuLayoutOpf.Create;

    for x := 0 to (Self.ComponentCount) - 1 do
     begin
      if (Pos('_cfg',TComponent(Self.Components[x]).name) > 0) then
      if (Self.Components[x] is TRaPanel) then
      begin
        MeuLayoutOpf.Entity.Id := MeuLayout.GetId(TComponent(Self.Components[x]).name);
        if (MeuLayoutOpf.Entity.Id > 0) then
        begin
         MeuLayoutOpf.Get;

         FColor := StringToColor(MeuLayoutOpf.Entity.Cor);
         (Self.Components[x] as TRaPanel).color := FColor;
        end;
      end;
     end;

  finally
    MeuLayoutOpf.Free;
  end;
end;

constructor TfrmMeuLayout.Create(AOwner: TComponent);
var
  txtCaption: string;
  idControl: longint;
begin
  inherited Create(AOwner);

  txtCaption := '<input type="color" id="CorFundo" onclick="Rfe.ajaxRequest( #idControl, '
    + QuotedStr('onclick') + ', this.value)">';

  idControl := lblCorFundo.ID;
  txtCaption := StringReplace(txtCaption, '#idControl',IntToStr(idControl), [rfReplaceAll]);
  lblCorFundo.Caption := txtCaption;

  txtCaption := '<input type="color" id="CorFonte" onclick="Rfe.ajaxRequest( #idControl, '
    + QuotedStr('onclick') + ', this.value)">';

  idControl := lblCorFonte.ID;
  txtCaption := StringReplace(txtCaption, '#idControl',IntToStr(idControl), [rfReplaceAll]);
  lblCorFonte.Caption := txtCaption;

  loadSetting;
end;

procedure TfrmMeuLayout.btnAcessarClick(Sender: TObject);
begin
  // <input type="button" id="meubtn"onClick="javascript:meubtn.style['background-color']=teste.value" value="Mudar a cor">
end;

procedure TfrmMeuLayout.btnListaCliente2Click(Sender: TObject);
begin
  loadSetting;
end;

procedure TfrmMeuLayout.btnListaCliente3Click(Sender: TObject);
var
  x:integer;
begin
  MeuLayout := TMeuLayout.Create;
  MeuLayoutOpf := TMeuLayoutOpf.Create;

  try

    for x := 0 to (Self.ComponentCount) - 1 do
    begin
     if (Pos('_cfg',TComponent(Self.Components[x]).name) > 0) then
     if (Self.Components[x] is TRaPanel) then
     begin
       MeuLayout.Id := MeuLayout.GetId(TComponent(Self.Components[x]).name);

       MeuLayout.Componet := TComponent(Self.Components[x]).name;
       MeuLayout.Cor := ColorToString((Self.Components[x] as TRaPanel).color);

       if MeuLayout.Id > 0
        then MeuLayoutOpf.Modify(MeuLayout)
        else MeuLayoutOpf.Add(MeuLayout);

        MeuLayoutOpf.Commit;
     end;
    end;

  finally
    MeuLayout.Free;
    MeuLayoutOpf.Free;
  end;
end;

procedure TfrmMeuLayout.btnMudarCor(Sender: TObject);
var
  x: integer;
begin
  Botao := (Sender as TRaButton).Name;
  RaOverlay1.Left := RaApplication.Application.EventRectangle.Left + Login.Width;
  RaOverlay1.Top := RaApplication.Application.EventRectangle.Top;
  RaOverlay1.Show;
end;

procedure TfrmMeuLayout.lblCorFonteAjaxRequest(Sender: TComponent;
  EventName: string; Params: TRaStrings);

var
  StrColor: string;
  x:integer;
  FColor:TColor;
begin

  StrColor := StringReplace(Params.ValueFromIndex[0], '#', '', []);

  FColor := RGB(StrToInt('$' + Copy(StrColor, 1, 2)),
                StrToInt('$' + Copy(StrColor, 3, 2)),
                StrToInt('$' + Copy(StrColor, 5, 2)));

  for x := 0 to (Self.ComponentCount) - 1 do
  begin
    if (TComponent(Self.Components[x]).name = Botao + '_lbl') then
    begin
      if (Self.Components[x] is TRaLabel) then
        (Self.Components[x] as TRaLabel).color := FColor;
    end;
  end;
end;

procedure TfrmMeuLayout.lblCorFundoAjaxRequest(Sender: TComponent;
  EventName: string; Params: TRaStrings);
var
  StrColor: string;
  x:integer;
  FColor:TColor;
begin

  StrColor := StringReplace(Params.ValueFromIndex[0], '#', '', []);

  FColor := RGB(StrToInt('$' + Copy(StrColor, 1, 2)),
                StrToInt('$' + Copy(StrColor, 3, 2)),
                StrToInt('$' + Copy(StrColor, 5, 2)));

  for x := 0 to (Self.ComponentCount) - 1 do
  begin
    if (TComponent(Self.Components[x]).name = Botao + '_cfg') then
    begin
      if (Self.Components[x] is TRaPanel) then
        (Self.Components[x] as TRaPanel).color := FColor;
    end;
  end;
end;

procedure TfrmMeuLayout.ckbMenuLadoClick(Sender: TObject);
begin
  ckbMenuLado.checked := not ckbMenuBaixo.checked;
  ckbMenuBaixo.checked := not ckbMenuLado.checked;

  MenuLado_cfg.Visible := ckbMenuLado.checked;
  Menu_cfg.Visible:= ckbMenuBaixo.checked;
end;

initialization

  RegisterClass(TfrmMeuLayout);

finalization
  UnRegisterClass(TfrmMeuLayout);

end.
