unit dbutils;

{$mode objfpc}{$H+}

interface

uses
  dSQLdbBroker, sqlite3conn, SysUtils;

function con: TdSQLdbConnector;

implementation

var
  _con: TdSQLdbConnector = nil;

function con: TdSQLdbConnector;
begin
  if not Assigned(_con) then
  begin
    _con := TdSQLdbConnector.Create(nil);
    _con.Logger.Active := false;
    _con.Logger.FileName := 'OUTPUT.LOG';
    _con.Driver := 'sqlite3';
    _con.Database := 'C:\Desenvolvimento\Projetos\RxAdmin\trunk\RxAdmin.db';
  end;
  Result := _con;
end;

finalization
  FreeAndNil(_con);

end.

