program RxAdmin;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX} cthreads, {$ENDIF}
  Interfaces, RaApplication, RaudusX, lazreportpdfexport, RaApplicationExe,
  RaConfig, untLogin, Utils, libBusca, untPesquisa, objMenu, untMeuLayout,
  objUsuario, objGeradorRelatorio, untprincipal, libGeradorRelatorio,
  untusuario, untRelatorio, untPreview;

begin
  WriteLn('http://localhost:8080/ - open in browser');
  Application.Title:='Raudus Application';
  Application.Initialize;
  Application.Config.Port := 8080;
  Application.Config.WwwDiskDirectory := 'C:\Raudus\www';
  Application.Config.SchedulerMode := rsmRunInSuperThread;
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmPreview, frmPreview);
  Application.Run;
end.
