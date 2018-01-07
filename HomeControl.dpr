program HomeControl;

uses
  System.StartUpCopy,
  FMX.Forms,
  hcFrmDevices in 'hcFrmDevices.pas' {frmDevices},
  hcDevice in 'Classes\hcDevice.pas',
  hcJson in 'Classes\hcJson.pas',
  hcUpsDevice in 'Classes\hcUpsDevice.pas',
  hcFrmDeviceInfo in 'hcFrmDeviceInfo.pas' {frmDeviceInfo},
  hcFrmSensors in 'hcFrmSensors.pas' {frmSensors},
  hcShared in 'Classes\hcShared.pas' {dmShared: TDataModule},
  hcFrmUpsControl in 'hcFrmUpsControl.pas' {frmUpsControl},
  hcFrmSettings in 'hcFrmSettings.pas' {frmUpsSettings},
  hcFrmSchedule in 'hcFrmSchedule.pas' {frmSchedule};

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(TdmShared, dmShared);
  Application.CreateForm(TfrmDevices, frmDevices);
  Application.Run;
end.
