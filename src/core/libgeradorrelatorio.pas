unit libGeradorRelatorio;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, RxJqDatePicker, RxPublisherView,
  RaApplication, RaBase, RaControlsVCL, lr_e_pdf, LR_Class,
  LR_DBSet, DB, sqldb, oracleconnection, sqlite3conn, Controls,
  dUtils, dSQLdbBroker;

const
 SQL_RELPARAMETRO = 'SELECT RPR_VISIVEL Visivel,RPR_ORDEM as Ordem, RPR_CODIGO as Codigo, RPR_NOME as Nome, RPR_TAMANHO as Tamanho, RPR_TPCAMPO as Tipo, RPR_BUSCA as Busca FROM RELPARAMETRO_RPR ORDER BY RPR_ORDEM ASC';

procedure CriaLabel(ANome, ACaption: string; var ATop: integer; AParent: TWinControl;AOwner:TComponent);
procedure CriaComboBox(ANome, ACaption: string; var ATop: integer; AParent: TWinControl;AOwner:TComponent);
procedure CriaEdit(ANome, ACaption: string; var ATop: integer; vWidth: integer; AParent: TWinControl;AOwner:TComponent);
procedure CampoDE_ATE(ANome: string; var ATop: integer; AParent: TWinControl;AOwner:TComponent);

implementation

procedure CriaLabel(ANome, ACaption: string; var ATop: integer;
  AParent: TWinControl; AOwner:TComponent);
var
  vLabel: TRaLabel;

begin
  vLabel := TRaLabel.Create(AOwner);
  vLabel.Parent := AParent;

  vLabel.Caption := ACaption;
  vLabel.Name := ANome;
  vLabel.Left := 10;
  vLabel.Width := 300;
  vLabel.AutoSize := True;
  vLabel.AutoSizeDelayed;
  vLabel.Top := ATop;
end;

procedure CriaComboBox(ANome, ACaption: string; var ATop: integer;
  AParent: TWinControl;AOwner:TComponent);
var
  vComboBox: TRaComboBox;
begin
  vComboBox := TRaComboBox.Create(AOwner);
  vComboBox.Parent := AParent;

  vComboBox.Name := ANome;
  vComboBox.Left := 300;
  vComboBox.ui := 'cupertino';
  vComboBox.Top := ATop;
  vComboBox.Items.add(ACaption);
end;

procedure CriaEdit(ANome, ACaption: string; var ATop: integer; vWidth: integer;
  AParent: TWinControl;AOwner:TComponent);
var
  vEdit: TRaEdit;

begin
  vEdit := TRaEdit.Create(AOwner);
  vEdit.Parent := AParent;

  vEdit.Name := ANome;
  vEdit.Text := ACaption;
  vEdit.Left := 300;
  vEdit.Width := vWidth;
  vEdit.ui := 'cupertino';
  vEdit.Top := ATop;
end;

procedure CampoDE_ATE(ANome: string; var ATop: integer; AParent: TWinControl;AOwner:TComponent);
var
  i, ii: integer;
  vDatePicker, vDatePicker1: TRxJqDatePicker;
  vLabel: TRaLabel;
begin
  vDatePicker := TRxJqDatePicker.Create(AOwner);
  vDatePicker.Parent := AParent;
  vDatePicker.Name := ANome + 'DE';
  vDatePicker.Left := 300;
  vDatePicker.ui := 'cupertino';
  vDatePicker.Top := ATop;

  vLabel := TRaLabel.Create(AOwner);
  vLabel.Parent := AParent;
  vLabel.Caption := 'Até';
  vLabel.Name := ANome;
  vLabel.Left := 300 + 1 * 128;
  vLabel.AutoSize := True;
  vLabel.AutoSizeDelayed;
  vLabel.Top := ATop + 8;

  vDatePicker1 := TRxJqDatePicker.Create(AOwner);
  vDatePicker1.Parent := AParent;
  vDatePicker1.Name := ANome + 'Ate';
  vDatePicker1.Left := 300 + 1 * 150;
  vDatePicker1.ui := 'cupertino';
  vDatePicker1.Top := ATop;
end;
end.

