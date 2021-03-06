unit untDm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, mysql57conn, mysql56conn, DB, sqlite3conn, FileUtil,
  lr_e_pdf, LR_Class, LR_DBSet, lr_CrossTab, LR_BarC, LR_Shape, LR_RRect,
  LR_ChBox, LR_Desgn, LR_E_TXT, LR_E_CSV, LR_DSet;

type

  { TDm }

  TDm = class(TDataModule)
    DataSource1: TDataSource;
    frBarCodeObject1: TfrBarCodeObject;
    frCheckBoxObject1: TfrCheckBoxObject;
    frCSVExport1: TfrCSVExport;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    frRoundRectObject1: TfrRoundRectObject;
    frShapeObject1: TfrShapeObject;
    frTextExport1: TfrTextExport;
    frTNPDFExport1: TfrTNPDFExport;
    lrCrossObject1: TlrCrossObject;
    SQLQuery1: TSQLQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure frDBDataSet1CheckEOF(Sender: TObject; var Eof: Boolean);
  private

  public

  end;

var
  Dm: TDm;

implementation

{$R *.lfm}

{ TDm }

procedure TDm.DataModuleCreate(Sender: TObject);
begin

end;

procedure TDm.frDBDataSet1CheckEOF(Sender: TObject; var Eof: Boolean);
begin

end;

end.

