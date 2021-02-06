program MobbX;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX} cthreads, {$ENDIF}
  Interfaces,
  RaApplication,
  RaApplicationExe,
  RaConfig, Unit1;

begin
  WriteLn('http://localhost:8080/ - open in browser');
  Application.Initialize;
  Application.Config.Port := 8080;
  Application.Config.WwwDiskDirectory := 'C:\Raudus\www';
  Application.Config.SchedulerMode := rsmRunInSuperThread;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
