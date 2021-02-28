unit untFrameDefault;

interface

uses
  Classes, SysUtils, Controls,
  RaApplication, RaBase, RaControlsVCL,
  Forms, StdCtrls, ExtCtrls;
type

  { TFrameDefault }

  TFrameDefault = class(TFrame)
    btnFechar: TRaBitButton;
    pnlTopo: TRaPanel;
    Container: TRaPanel;
  private
  public
  end;

implementation

{$R *.lfm}

end.

