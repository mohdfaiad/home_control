unit hcFrmDeviceInfo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, hcDevice, System.Math.Vectors, FMX.Objects, FMX.Controls3D,
  FMX.Layers3D, FMX.ListView.Types, FMX.ListView, FMX.ListBox,
  FMX.Controls.Presentation, FMX.ListView.Appearances, System.Actions,
  FMX.ActnList, hcShared, hcJson, FMX.Ani;

type
  TfrmDeviceInfo = class(TfrmEditForm)
    lvDeviceProperties: TListBox;
    ToolBar1: TToolBar;
    sbBack: TSpeedButton;
    alInfo: TActionList;
    acBack: TAction;
    AniIndicator1: TAniIndicator;
    GradientAnimation1: TGradientAnimation;
    lbAbout: TLabel;
    procedure acBackExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure acBackUpdate(Sender: TObject);
  private
    procedure DoLoaded(AObject: TRespondObject); override;
    procedure DoBeginLoading; override;
    procedure DoEndLoading; override;
  public
  end;

var
  frmDeviceInfo: TfrmDeviceInfo;

implementation

{$R *.fmx}

{ TfrmDeviceInfo }

procedure TfrmDeviceInfo.acBackExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmDeviceInfo.acBackUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := not IsLoading;
end;

procedure TfrmDeviceInfo.DoBeginLoading;
begin
  inherited;
  AniIndicator1.Enabled := True;
  AniIndicator1.Visible := True;
end;

procedure TfrmDeviceInfo.DoEndLoading;
begin
  inherited;
  AniIndicator1.Enabled := False;
  AniIndicator1.Visible := False;
end;

procedure TfrmDeviceInfo.DoLoaded(AObject: TRespondObject);
var
  info: TCustomInfo absolute AObject;
begin
  if not (AObject is TCustomInfo) then
    Exit;

  lvDeviceProperties.Items.Clear;
  lvDeviceProperties.Items.Add(Format('MAC: %s',[info.Mac]));
  lvDeviceProperties.Items.Add(Format('Memory: %f bytes',[info.Heap]));
  lvDeviceProperties.Items.Add(Format('Build: %s',[info.Build]));
  lvDeviceProperties.Items.Add(Format('Uptime: %s',[info.UpTime]));
end;

procedure TfrmDeviceInfo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

procedure TfrmDeviceInfo.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not Self.IsLoading;
end;


initialization
  editorFormRegister.Add(TCustomInfo, TfrmDeviceInfo);

end.
