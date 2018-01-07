unit hcFrmSensors;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.ListBox, hcDevice, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Ani,
  System.Actions, FMX.ActnList, hcShared, hcJson;

type
  TfrmSensors = class(TfrmEditForm)
    lbSensors: TListBox;
    ToolBar1: TToolBar;
    sbRefresh: TSpeedButton;
    sbClose: TSpeedButton;
    lbSensorsList: TLabel;
    AniIndicator1: TAniIndicator;
    GradientAnimation1: TGradientAnimation;
    alSensors: TActionList;
    acBack: TAction;
    acRefresh: TAction;
    procedure acRefreshExecute(Sender: TObject);
    procedure acBackUpdate(Sender: TObject);
    procedure acBackExecute(Sender: TObject);
  private
  protected
    procedure DoLoaded(AObject: TRespondObject); override;
    procedure DoBeginLoading; override;
    procedure DoEndLoading; override;
  public
  end;

var
  frmSensors: TfrmSensors;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

{ TfrmSensors }

procedure TfrmSensors.acBackExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmSensors.acBackUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := not IsLoading;
end;

procedure TfrmSensors.acRefreshExecute(Sender: TObject);
begin
  Load;
end;

procedure TfrmSensors.DoBeginLoading;
begin
  AniIndicator1.Visible := True;
  AniIndicator1.Enabled := True;
end;

procedure TfrmSensors.DoEndLoading;
begin
  AniIndicator1.Visible := False;
  AniIndicator1.Enabled := False;
end;

procedure TfrmSensors.DoLoaded(AObject: TRespondObject);
var
  sensors: TCustomSensors absolute AObject;
  i: Integer;
  item: TListBoxItem;
begin
  lbSensors.Clear;
  lbSensors.BeginUpdate;
  try
    for i := 0 to sensors.Count - 1 do
    begin
      item := TListBoxItem.Create(lbSensors);
      item.StyleLookup := 'listbox_sensor';
      item.StyledSettings:=[TStyledSetting.Family,TStyledSetting.Style,TStyledSetting.FontColor,TStyledSetting.Other];
      Item.StylesData['lbId'] := sensors[i].Id;
      Item.StylesData['lbValue'] := FloatToStr(sensors[i].Value);
      lbSensors.AddObject(item);
    end;
  finally
    lbSensors.EndUpdate;
  end;
end;

initialization
  editorFormRegister.Add(TCustomSensors, TfrmSensors);

end.
