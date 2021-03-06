program RxAdmin;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX} cthreads, {$ENDIF}
  Interfaces, RaApplication, RaudusX, lazreportpdfexport, RaApplicationExe,
  RaConfig, untLogin, Utils, libBusca, untPesquisa, objMenu, untMeuLayout,
  objUsuario, objGeradorRelatorio, objBusca, untprincipal, libGeradorRelatorio,
  untDm, untusuario, untRelatorio, untPreview, untRelatorio1;

begin
  WriteLn('http://localhost:8080/ - open in browser');
  Application.Title:='Raudus Application';
  Application.Initialize;
  Application.Config.Port := 8080;
  Application.Config.WwwDiskDirectory := 'C:\Raudus\www';
  Application.Config.SchedulerMode := rsmRunInSuperThread;
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmPreview, frmPreview);
  Application.CreateForm(TDm, Dm);
  Application.CreateForm(TfrmRelatorio, frmRelatorio);
  Application.Run;
end.
