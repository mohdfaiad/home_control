unit hcFrmUpsControl;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, hcUpsDevice, hcShared, hcDevice, System.Actions,
  FMX.ActnList;

type
  TfrmUpsControl = class(TfrmEditForm)
    swAuto: TSwitch;
    tbControl: TToolBar;
    sbClose: TSpeedButton;
    lbControl: TLabel;
    lbActive: TLabel;
    lbAuto: TLabel;
    swActive: TSwitch;
    alControl: TActionList;
    acBack: TAction;
    procedure swActiveSwitch(Sender: TObject);
    procedure swAutoSwitch(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure acBackExecute(Sender: TObject);
  private
    procedure DoLoaded(AObject: TRespondObject); override;
    procedure DoBeginLoading; override;
    procedure DoEndLoading; override;
  end;

var
  frmUpsControl: TfrmUpsControl;

implementation

{$R *.fmx}


procedure TfrmUpsControl.acBackExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmUpsControl.DoBeginLoading;
begin
  inherited;

end;

procedure TfrmUpsControl.DoEndLoading;
begin
  inherited;

end;

procedure TfrmUpsControl.DoLoaded(AObject: TRespondObject);
var
  obj: TUpsCotrol absolute AObject;
begin
  if not (AObject is TUpsCotrol) then
    Exit;

  swActive.IsChecked := obj.Activate;
  swAuto.IsChecked := obj.IsAutoMode;
  swAuto.Enabled := not obj.IsAutoMode;
end;

procedure TfrmUpsControl.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

procedure TfrmUpsControl.swActiveSwitch(Sender: TObject);
begin
  if not (FDetail is TUpsCotrol) then
    Exit;

  if not IsLoading then
  begin
    (FDetail as TUpsCotrol).Activate := (Sender as TSwitch).IsChecked;
    (FDetail as TUpsCotrol).IsAutoMode := False;
    Load;
  end;
end;

procedure TfrmUpsControl.swAutoSwitch(Sender: TObject);
begin
  if not (FDetail is TUpsCotrol) then
    Exit;
  if not IsLoading then
  begin
    (FDetail as TUpsCotrol).IsAutoMode := (Sender as TSwitch).IsChecked;
    Load;
  end;
end;

initialization
  editorFormRegister.Add(TUpsCotrol, TfrmUpsControl);

end.
