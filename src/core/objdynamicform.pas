unit objDynamicForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, Forms, Graphics,
  RaApplication, RaBase, RaControlsVCL;

type

  { TDynamicForm }
  TDynamicForm = class(TObject)
  private
    FErro_Str: WideString;
    FErro_List: TStringList;
    FForm: TRaFormCompatible;
    FCenterPanel: TRaScrollBox;
    FTabControl: TRaTabControl;
    FFrameCount: integer;
    FTipo: integer;

    procedure btnBuscaClick(Sender: TObject);
    procedure CloseFrameClick(Sender: TObject);
  protected
    function Get_Form: TRaFormCompatible;
    procedure Set_Form(AForm: TRaFormCompatible);

    function Get_CenterPanel: TRaScrollBox;
    procedure Set_CenterPanel(ACenterPanel: TRaScrollBox);

    function Get_TabControl: TRaTabControl;
    procedure Set_TabControl(ATabControl: TRaTabControl);

    function Get_FrameCount: integer;
    procedure Set_FrameCount(AFrameCount: integer);

    function Get_Tipo: integer;
    procedure Set_Tipo(ATipo: integer);

  public
    constructor Create;
    destructor Destroy; override;

    property Form: TRaFormCompatible read Get_Form write Set_Form;
    property CenterPanel: TRaScrollBox read Get_CenterPanel write Set_CenterPanel;
    property TabControl: TRaTabControl read Get_TabControl write Set_TabControl;
    property FrameCount: integer read Get_FrameCount write Set_FrameCount;
    property Tipo: integer read Get_Tipo write Set_Tipo;

    procedure LoadForm(ANome_form: string; AOwner: TComponent;
      is_ShowModalNonBlocking: boolean; ABorderIcons: TBorderIcons);

    procedure NewFrame(ANome_form, ACaption: string; var ACenterPanel: TRaScrollBox);
    procedure LoadSetting(AOwner: TComponent);
    procedure Procurar(const AForm: TRaFormCompatible; var AFrameCount: integer;
      var ARelatorios: TRaScrollBox);

  end;

implementation

uses untFrameDefault, objMeuLayout;

{ TDynamicForm }
procedure TDynamicForm.btnBuscaClick(Sender: TObject);
begin
  writeln((Sender as TRaButton).Name);
  NewFrame((Sender as TRaButton).Name, (Sender as TRaButton).Caption, FCenterPanel);
end;

procedure TDynamicForm.CloseFrameClick(Sender: TObject);
var
  fra: TFrameDefault;
  pnl: TRaFrameHolder;
  i: integer;
  vTabSheet: string;

begin
  fra := TFrameDefault(TRaButton(Sender).Parent.Parent);
  Writeln(' name: ' + fra.Name);
  vTabSheet := fra.Name;
  pnl := TRaFrameHolder(fra.Parent.Parent);
  Writeln(' destruir : ' + pnl.Name);
  pnl.Free;

  if FTipo <> 0 then
  begin
    for i := 0 to FTabControl.TabCount - 1 do
    begin
      if FTabControl.Controls[i] is TRaTabSheet then
      begin
        writeln(FTabControl.Controls[i].Name);
        if FTabControl.Controls[i].Name = vTabSheet then
          FTabControl.Controls[i].Free;
      end;
    end;
  end;
end;

function TDynamicForm.Get_Form: TRaFormCompatible;
begin
  if not Assigned(FForm) then
    FForm := TRaFormCompatible.Create(nil);
  Result := FForm;
end;

procedure TDynamicForm.Set_Form(AForm: TRaFormCompatible);
begin
  if Assigned(FForm) then
    FreeAndNil(FForm);

  FForm := AForm;
end;

function TDynamicForm.Get_CenterPanel: TRaScrollBox;
begin
  if not Assigned(FCenterPanel) then
    FCenterPanel := TRaScrollBox.Create(nil);
  Result := FCenterPanel;
end;

procedure TDynamicForm.Set_CenterPanel(ACenterPanel: TRaScrollBox);
begin
  if Assigned(FCenterPanel) then
    FreeAndNil(FCenterPanel);

  FCenterPanel := ACenterPanel;
end;

function TDynamicForm.Get_TabControl: TRaTabControl;
begin
  if not Assigned(FTabControl) then
    FTabControl := TRaTabControl.Create(nil);
  Result := FTabControl;
end;

procedure TDynamicForm.Set_TabControl(ATabControl: TRaTabControl);
begin
  if Assigned(FTabControl) then
    FreeAndNil(FTabControl);

  FTabControl := ATabControl;
end;

function TDynamicForm.Get_FrameCount: integer;
begin
  //  if not Assigned(FFrameCount) then
  Result := FFrameCount;
end;

procedure TDynamicForm.Set_FrameCount(AFrameCount: integer);
begin
  //if Assigned(FFrameCount) then
  FreeAndNil(FFrameCount);
  FFrameCount := AFrameCount;
end;

function TDynamicForm.Get_Tipo: integer;
begin
  Result := FTipo;
end;

procedure TDynamicForm.Set_Tipo(ATipo: integer);
begin
  FTipo := ATipo;
end;

constructor TDynamicForm.Create;
begin

end;

destructor TDynamicForm.Destroy;
begin
  inherited Destroy;
end;

procedure TDynamicForm.LoadForm(ANome_form: string; AOwner: TComponent;
  is_ShowModalNonBlocking: boolean; ABorderIcons: TBorderIcons);
var
  vcls_form: TPersistentClass;
  vobj_form: TForm;
begin
  vcls_form := GetClass(ANome_form);
  if (Assigned(vcls_form)) and (vcls_form.InheritsFrom(TRaFormCompatible)) then
  begin
    vobj_form := TFormClass(vcls_form).Create(AOwner);
    if is_ShowModalNonBlocking then
    begin
      TRaFormCompatible(vobj_form).UI := 'cupertino';
      TRaFormCompatible(vobj_form).BorderIcons := ABorderIcons;//[];
      TRaFormCompatible(vobj_form).Color := $00B59E88;//$00EEEEEE;
      TRaFormCompatible(vobj_form).ShowModalNonBlocking;
      TRaFormCompatible(vobj_form).Position := poScreenCenter;
    end
    else
      vobj_form.Show;
  end
  else;
  //    ShowMessage('Tentativa de carga um formulário inválido ['+ANome_form+'].');
end;

procedure TDynamicForm.NewFrame(ANome_form, ACaption: string;
  var ACenterPanel: TRaScrollBox);
var
  pnl: TRaPanel;
  tbs: TRaTabSheet;
  sbx: TRaScrollBox;
  fraH: TRaFrameHolder;
  aFrame: TFrameDefault;
  aClass: TPersistentClass;

begin
  aClass := GetClass(ANome_form);
  Inc(FFrameCount);

    //sbx:= TRaScrollBox.Create(FForm);
    //sbx.direction := rsdVertical;

  pnl := TRaPanel.Create(FForm);
  aFrame := TFrameDefault(TControlClass(aClass).Create(pnl));
  aFrame.Name := aFrame.Name + IntToStr(FFrameCount);
  (aFrame).Visible := False;

  if FTipo <> 0 then
  begin
    tbs := TRaTabSheet.Create(FTabControl);
    tbs.TabControl := FTabControl;
    tbs.Title.Caption := ACaption;
    tbs.Title.Width := tbs.Title.Width + Length(ACaption) + 25;
    tbs.Name := aFrame.Name;
    FTabControl.activetab := tbs;
  end;

  pnl.Name := 'TRaPanel_' + aFrame.Name + IntToStr(FFrameCount);

  if FTipo = 0 then
    pnl.Parent := ACenterPanel
  else
    pnl.Parent := tbs;

  pnl.Top := 0;
  pnl.Align := alTop;
  pnl.Height := (aFrame).Height;
  pnl.Width := (aFrame).Width;
  pnl.SetFocus;

  fraH := TRaFrameHolder.Create(pnl);
  fraH.Name := 'TRaFrameHolder_' + aFrame.Name + IntToStr(FFrameCount);
  fraH.Parent := pnl;
  fraH.Align := alClient;
  fraH.Color := $00EEEEEE;

  (aFrame).Align := alClient;
  (aFrame).Parent := (fraH);
  aFrame.btnFechar.onClick := @CloseFrameClick;
end;

procedure TDynamicForm.LoadSetting(AOwner: TComponent);
var
  x: integer;
  FColor: TColor;
  MeuLayoutOpf: TMeuLayoutOpf;

begin
  try
    MeuLayoutOpf := TMeuLayoutOpf.Create;

    for x := 0 to (AOwner.ComponentCount) - 1 do
    begin
      writeln(TComponent(AOwner.Components[x]).Name);

      if (Pos('_cfg', TComponent(AOwner.Components[x]).Name) > 0) then
      begin
        MeuLayoutOpf.Entity.Id := MeuLayoutOpf.GetId(TComponent(AOwner.Components[x]).Name);

        if (MeuLayoutOpf.Entity.Id > 0) then
        begin
          MeuLayoutOpf.Get;
          FColor := StringToColor(MeuLayoutOpf.Entity.Cor);

          if (AOwner.Components[x] is TRaPanel)
            then (AOwner.Components[x] as TRaPanel).color := FColor;

          if (AOwner.Components[x] is TRaScrollBox)
           then (AOwner.Components[x] as TRaScrollBox).color := FColor;

        end;
      end;
    end;

  finally
    MeuLayoutOpf.Free;
  end;
end;

procedure TDynamicForm.Procurar(const AForm: TRaFormCompatible;
  var AFrameCount: integer; var ARelatorios: TRaScrollBox);
var
  vButton: TRaBitButton;
  RaImage1: TRaImage;

begin
  RaImage1 := TRaImage.Create(nil);
  vButton := TRaBitButton.Create(nil);
  vButton.Parent := ARelatorios;

  vButton.onclick := @btnBuscaClick;
  vButton.Name := 'TfrmRelatorio';
  vButton.ParentColor := True;
  vButton.Caption := 'asasasa';
  vButton.ui := 'simple';

  vButton.Left := ARelatorios.Left;
  vButton.Width := 179;
  vButton.Height := 32;
  vButton.Align := alTop;
  vButton.AutoSize := True;
  vButton.AutoSizeDelayed;

  ARelatorios.Height := ARelatorios.Height + 48;
end;

end.
