unit untPreview;

{$mode objfpc}{$H+}

interface

uses
  Classes, LResources, RxPublisherView, RaControlsVCL, Forms;

type

  { TfrmPreview }
  TfrmPreview = class(TRaFormCompatible)
    RxPublisherView1: TRxPublisherView;
    RaStreamPublisher1: TRaStreamPublisher;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmPreview: TfrmPreview;

implementation

procedure TfrmPreview.FormActivate(Sender: TObject);
begin
  RxPublisherView1.publisher := RaStreamPublisher1;
  frmPreview.Caption := UTF8Decode('Visualização');
end;

procedure TfrmPreview.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
//  RaStreamPublisher1.Free;
//  RaStreamPublisher1.FreeOnRelease;
end;

procedure TfrmPreview.FormCreate(Sender: TObject);
begin
  //  frmPreview.Caption:= 'Visualização';
end;

procedure TfrmPreview.FormDestroy(Sender: TObject);
begin
//  RaStreamPublisher1.Free;
//  RaStreamPublisher1.FreeOnRelease;
end;

procedure TfrmPreview.FormShow(Sender: TObject);
begin
  //  RxPublisherView1.publisher := RaStreamPublisher1;
  frmPreview.Caption := UTF8Decode('Visualização');
end;

initialization
  {$I untPreview.lrs}
  RegisterClass(TfrmPreview);

finalization
  UnRegisterClass(TfrmPreview);
end.
