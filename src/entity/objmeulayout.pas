unit objMeuLayout;

{$mode objfpc}{$H+}
interface

uses  dSQLdbBroker, dOpf, dbutils, sysutils;

type
  EMeuLayout = class(Exception);

type
  { TMeuLayout }
  TMeuLayout = class(TObject)
  private
    FId: Int64;
    FComponet: string;
    FCor: string;
  public
    procedure Validate;
    function GetId(AField:string):integer;
  published
    property Id: Int64 read FId write FId;
    property Componet: string read FComponet write FComponet;
    property Cor: string read FCor write FCor;
  end;

  { TMeuLayoutOpf }
  TMeuLayoutOpf = class(specialize TdGSQLdbEntityOpf<TMeuLayout>)
  protected
    procedure DoUpdating(AEntity: T3); override;
  public
    constructor Create; overload; virtual;
    function GetId(AField:string):integer;
  end;

  Topf = specialize TdGSQLdbEntityOpf<TMeuLayout>;

implementation

{ TMeuLayout }

procedure TMeuLayout.Validate;
begin

end;

function TMeuLayout.GetId(AField: string): integer;
var
  con: TdSQLdbConnector;
  qry: TdSQLdbQuery;
begin
  con := dbutils.con; //TdSQLdbConnector.Create(nil);
  qry := TdSQLdbQuery.Create(con);
  try
    con.Connect;
    qry.SQL.Text := 'SELECT id FROM MEULAYOUT_LAY WHERE LAY_COMPONET=' + QuotedStr(AField);
    qry.Open;
    qry.First;
    if qry.Fields.Count > 0
     then Result := qry.Fields.FieldByName('id').AsInteger
     else Result := 0;
  finally
    con.Disconnect;
    con.FreeOnRelease;
    qry.FreeOnRelease;
  end;
end;

{ TTMeuLayoutOpf }

procedure TMeuLayoutOpf.DoUpdating(AEntity: T3);
begin
  case UpdateKind of
    ukAdd, ukModify: AEntity.Validate;
  end;
end;

constructor TMeuLayoutOpf.Create;
var
  FDbMapping:string;
begin
  FDbMapping := 'id:id,';
  FDbMapping := FDbMapping + 'Componet:LAY_COMPONET,';
  FDbMapping := FDbMapping + 'Cor:LAY_COR';

  inherited Create(dbutils.con, 'MEULAYOUT_LAY',FDbMapping);
end;

function TMeuLayoutOpf.GetId(AField: string): integer;
var
  con: TdSQLdbConnector;
  qry: TdSQLdbQuery;
begin
  con := dbutils.con; //TdSQLdbConnector.Create(nil);
  qry := TdSQLdbQuery.Create(con);
  try
    con.Connect;
    qry.SQL.Text := 'SELECT id FROM MEULAYOUT_LAY WHERE LAY_COMPONET=' + QuotedStr(AField);
    qry.Open;
    qry.First;
    if qry.Fields.Count > 0
     then Result := qry.Fields.FieldByName('id').AsInteger
     else Result := 0;
  finally
    con.Disconnect;
    con.FreeOnRelease;
    qry.FreeOnRelease;
  end;
end;

end.
