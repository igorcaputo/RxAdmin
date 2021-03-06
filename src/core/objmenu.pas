unit objMenu;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, Forms, dSQLdbBroker,
  RaApplication, RaBase, RaControlsVCL, objDynamicForm;

type
  TItemMenuEvent = procedure(Sender: TRaBitButton) of object;
  StringArray = array of string;
  { TMenu }

  TMenu = class(TObject)
  private
    FErro_Str: WideString;
    FErro_List: TStringList;
    FForm: TRaFormCompatible;
    FSideBar: TRaScrollBox;
    FCenterPanel: TRaScrollBox;
    FTabControl: TRaTabControl;

    FFrameCount: integer;
    FTipo: integer;
    FMenu: TRaOverlay;

    procedure ButtonClick(Sender: TObject);
    procedure btnBuscaClick(Sender: TObject);
    procedure CloseFrameClick(Sender: TObject);
  protected
    function Get_Menu: TRaOverlay;
    procedure Set_Menu(AMenu: TRaOverlay);

    function Get_Form: TRaFormCompatible;
    procedure Set_Form(AForm: TRaFormCompatible);

    function Get_CenterPanel: TRaScrollBox;
    procedure Set_CenterPanel(ACenterPanel: TRaScrollBox);

    function Get_SideBar: TRaScrollBox;
    procedure Set_SideBar(ASideBar: TRaScrollBox);

    function Get_TabControl: TRaTabControl;
    procedure Set_TabControl(ATabControl: TRaTabControl);

    function Get_FrameCount: integer;
    procedure Set_FrameCount(AFrameCount: integer);

    function Get_Tipo: integer;
    procedure Set_Tipo(ATipo: integer);

  public
    constructor Create;
    destructor Destroy; override;

    property Menu: TRaOverlay read Get_Menu write Set_Menu;
    property Form: TRaFormCompatible read Get_Form write Set_Form;
    property CenterPanel: TRaScrollBox read Get_CenterPanel write Set_CenterPanel;
    property TabControl: TRaTabControl read Get_TabControl write Set_TabControl;
    property SideBar: TRaScrollBox read Get_SideBar write Set_SideBar;
    property FrameCount: integer read Get_FrameCount write Set_FrameCount;
    property Tipo: integer read Get_Tipo write Set_Tipo;

    procedure CarregaMenu;
    procedure Relatorio(const AForm: TRaFormCompatible; var AFrameCount: integer;
      ACaption: string; var ASubMenuScroll: TRaScrollBox;var ASubMenu: TRaOverlay);

    procedure CriarItemMenu(const AForm: TRaFormCompatible; ATag:integer;
      AMenu, AName, ACaption: string; var ASubMenuScroll: TRaScrollBox; var ASubMenu: TRaOverlay);

    procedure CriarMenu(const AForm: TRaFormCompatible; AName, ACaption: string;
      AHeight: integer; var ASubMenuScroll: TRaScrollBox; var ASubMenu: TRaOverlay);

    function funcStringToArray(strConverte: string; const chrDelimita: char): StringArray;
  end;

implementation

uses untFrameDefault, dbutils;

function TMenu.funcStringToArray(strConverte: string;
  const chrDelimita: char): StringArray;
var
  lstString: TStringList;
  IntCnt: integer;
begin

  lstString := TStringList.Create;
  Assert(Assigned(lstString));

  lstString.Clear;
  lstString.Delimiter := chrDelimita;
  lstString.DelimitedText := Trim(strConverte);
  SetLength(Result, lstString.Count);

  for IntCnt := 0 to lstString.Count - 1 do
    Result[IntCnt] := lstString.Strings[IntCnt];

end;

{ TMenu }
procedure TMenu.btnBuscaClick(Sender: TObject);
var
  vForm: TDynamicForm;
begin
  vForm := TDynamicForm.Create;
  Inc(FFrameCount);
  vForm.Form := FForm;
  vForm.FrameCount := FFrameCount;
  vForm.TabControl := FTabControl;
  vForm.CenterPanel := FCenterPanel;
  vForm.Tipo := 1;

  case (Sender as TRaButton).Tag of
    0: vForm.LoadForm((Sender as TRaButton).Name, FForm, True, []);
    1: vForm.NewFrame((Sender as TRaButton).Name, (Sender as TRaButton).Caption, FCenterPanel);
  end;

  (Sender as TRaButton).Parent.Hide;
end;

procedure TMenu.ButtonClick(Sender: TObject);
var
  x:integer;
begin
  for x := 0 to (FForm.ComponentCount) - 1 do
  begin
    if (FForm.Components[x] is TRaOverlay) then
     if ((TComponent(FForm.Components[x]).Name) = (Sender as TRaBitButton).Name) then
     begin
       (FForm.Components[x] as TRaOverlay).Left := RaApplication.Application.EventRectangle.Left;
       (FForm.Components[x] as TRaOverlay).Top := RaApplication.Application.EventRectangle.Bottom;

       (FForm.Components[x] as TRaOverlay).Left := RaApplication.Application.EventRectangle.Left + (Sender as TRaBitButton).Width;
       (FForm.Components[x] as TRaOverlay).Top := RaApplication.Application.EventRectangle.Top;

       (FForm.Components[x] as TRaOverlay).Show;
     end;
  end;
end;

procedure TMenu.CloseFrameClick(Sender: TObject);
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

function TMenu.Get_Menu: TRaOverlay;
begin
  if not Assigned(FMenu) then
    FMenu := TRaOverlay.Create(nil);
  Result := FMenu;
end;

procedure TMenu.Set_Menu(AMenu: TRaOverlay);
begin
  if Assigned(AMenu) then
    FreeAndNil(AMenu);

  FMenu := AMenu;
end;

function TMenu.Get_Form: TRaFormCompatible;
begin
  if not Assigned(FForm) then
    FForm := TRaFormCompatible.Create(nil);
  Result := FForm;
end;

procedure TMenu.Set_Form(AForm: TRaFormCompatible);
begin
  if Assigned(FForm) then
    FreeAndNil(FForm);

  FForm := AForm;
end;

function TMenu.Get_CenterPanel: TRaScrollBox;
begin
  if not Assigned(FCenterPanel) then
    FCenterPanel := TRaScrollBox.Create(nil);
  Result := FCenterPanel;
end;

procedure TMenu.Set_CenterPanel(ACenterPanel: TRaScrollBox);
begin
  if Assigned(FCenterPanel) then
    FreeAndNil(FCenterPanel);

  FCenterPanel := ACenterPanel;
end;

function TMenu.Get_SideBar: TRaScrollBox;
begin
  if not Assigned(FSideBar) then
    FSideBar := TRaScrollBox.Create(nil);
  Result := FSideBar;
end;

procedure TMenu.Set_SideBar(ASideBar: TRaScrollBox);
begin
  if Assigned(FSideBar) then
    FreeAndNil(FSideBar);

  FSideBar := ASideBar;
end;

function TMenu.Get_TabControl: TRaTabControl;
begin
  if not Assigned(FTabControl) then
    FTabControl := TRaTabControl.Create(nil);
  Result := FTabControl;
end;

procedure TMenu.Set_TabControl(ATabControl: TRaTabControl);
begin
  if Assigned(FTabControl) then
    FreeAndNil(FTabControl);

  FTabControl := ATabControl;
end;

function TMenu.Get_FrameCount: integer;
begin
  Result := FFrameCount;
end;

procedure TMenu.Set_FrameCount(AFrameCount: integer);
begin
  FreeAndNil(FFrameCount);
  FFrameCount := AFrameCount;
end;

function TMenu.Get_Tipo: integer;
begin
  Result := FTipo;
end;

procedure TMenu.Set_Tipo(ATipo: integer);
begin
  FTipo := ATipo;
end;

constructor TMenu.Create;
begin

end;

destructor TMenu.Destroy;
begin
  inherited Destroy;
end;

procedure TMenu.CarregaMenu;
var
  con: TdSQLdbConnector;
  qry: TdSQLdbQuery;
  vSubMenu: TRaOverlay;
  sMenu: string;
  x:integer;

begin
  x := 0;
  con := dbutils.con;
  con.Connect;

  qry := TdSQLdbQuery.Create(con);
  qry.SQL.Clear;
  qry.SQL.Add('SELECT * FROM MENU_MNU ORDER BY MNU_CDMENU,MNU_ORDEM ASC');
  qry.Open;
  qry.First;

  while not qry.EOF do
  begin
    sMenu := qry.Field('MNU_CDMENU').AsString;

    if qry.Field('MNU_CDSUBMENU').AsString = '' then
    begin
      vSubMenu := TRaOverlay.Create(Form);
      vSubMenu.Parent :=  Form;
      vSubMenu.Width := 300;
      vSubMenu.Height := 0;
      vSubMenu.Name := sMenu;

      CriarMenu(Form,
        qry.Field('MNU_CDMENU').AsString,
        qry.Field('MNU_DESCRICAO').AsString,
        qry.Field('MNU_HEIGHT').AsInteger,
        FSideBar, vSubMenu);
    end
    else
    begin
      if (qry.Field('MNU_CDSUBMENU').AsString <> '') and
         (sMenu = qry.Field('MNU_CDMENU').AsString) and (sMenu <> 'Relatorio') then
      begin
        vSubMenu.Height := vSubMenu.Height + qry.Field('MNU_HEIGHT').AsInteger;
        CriarItemMenu(Form,
          qry.Field('MNU_FORMFRAME').AsInteger,
          qry.Field('MNU_CDMENU').AsString,
          qry.Field('MNU_CDSUBMENU').AsString,
          qry.Field('MNU_DESCRICAO').AsString,
          FSideBar,vSubMenu);
      end;
      if (qry.Field('MNU_CDSUBMENU').AsString <> '') and
         ('Relatorio' = qry.Field('MNU_CDMENU').AsString) then
      begin
        vSubMenu.Height := vSubMenu.Height + qry.Field('MNU_HEIGHT').AsInteger;
        Relatorio(Form, x,qry.Field('MNU_DESCRICAO').AsString,FSideBar,vSubMenu);

      end;
    end;

    qry.Next;
  end;
  con.Disconnect;
end;

procedure TMenu.Relatorio(const AForm: TRaFormCompatible; var AFrameCount: integer;
  ACaption: string; var ASubMenuScroll: TRaScrollBox;var ASubMenu: TRaOverlay);
var
  vButton: TRaBitButton;
  RaImage1: TRaImage;

begin
  RaImage1 := TRaImage.Create(nil);
  vButton := TRaBitButton.Create(nil);
  vButton.Parent := ASubMenu;

  vButton.onclick := @btnBuscaClick;
  vButton.Name := 'TfrmRelatorio';
  vButton.ParentColor := True;
  vButton.Caption := ACaption;
  vButton.Tag := 1;
  vButton.Left := ASubMenu.Left;
  vButton.UI := 'simple';
  vButton.Width := 179;
  vButton.Height := 32;
  vButton.Font.Size:= 16;
  vButton.Align := alTop;
  vButton.AutoSize := True;
  vButton.AutoSizeDelayed;

  //ASubMenu.Height := ASubMenu.Height + 48;
end;

procedure TMenu.CriarItemMenu(const AForm: TRaFormCompatible; ATag:integer;
  AMenu, AName, ACaption: string; var ASubMenuScroll: TRaScrollBox; var ASubMenu: TRaOverlay);
var
  vButton: TRaBitButton;
  RaImage1: TRaImage;

begin
  FMenu := ASubMenu;
  RaImage1 := TRaImage.Create(nil);
  vButton := TRaBitButton.Create(nil);
  (*Ver uma forma de colocar esta opçao dinamica*)
  vButton.Parent := ASubMenu;//ASubMenuScroll;//
  vButton.onclick := @btnBuscaClick;
  vButton.Name := AName;

  vButton.Tag := ATag;
  vButton.ParentColor := True;
  vButton.Caption := ACaption;
  vButton.UI := 'simple';
  vButton.Left := ASubMenuScroll.Left;
  vButton.Width := 179;
  vButton.Height := 32;
  vButton.Font.Size:= 16;
  vButton.Align := alTop;
  vButton.AutoSize := True;
  vButton.AutoSizeDelayed;
end;

procedure TMenu.CriarMenu(const AForm: TRaFormCompatible; AName, ACaption: string;
  AHeight: integer; var ASubMenuScroll: TRaScrollBox; var ASubMenu: TRaOverlay);
var
  vButton: TRaBitButton;
begin
  vButton := TRaBitButton.Create(nil);
  vButton.onclick := @ButtonClick;
  vButton.Name := AName;
  vButton.ParentColor := True;
  vButton.Parent := ASubMenuScroll;
  vButton.Caption := ACaption;
  vButton.UI := 'simple';
  vButton.Left := ASubMenuScroll.Left;
  vButton.Width := 179;
  vButton.Height := 32;
  vButton.Font.Size:= 16;
  vButton.Align := alTop;
  vButton.AutoSize := True;
  vButton.AutoSizeDelayed;
end;

end.
