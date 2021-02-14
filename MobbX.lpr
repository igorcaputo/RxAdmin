program MobbX;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX} cthreads, {$ENDIF}
  Interfaces,
  RaApplication,
  RaApplicationExe,
  RaConfig;

begin
  WriteLn('http://localhost:8080/ - open in browser');
  Application.Initialize;
  Application.Config.Port := 8080;
  Application.Config.WwwDiskDirectory := 'C:\Raudus\www';
  Application.Config.SchedulerMode := rsmRunInSuperThread;
  Application.Run;
end.
