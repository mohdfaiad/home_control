unit hcFrmDevices;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  System.Math.Vectors, FMX.Controls3D, FMX.Layers3D, FMX.Layouts, FMX.ListBox,
  IdBaseComponent, IdComponent, IdUDPBase, IdUDPClient, System.Generics.Collections,
  FMX.Ani, hcDevice, hcUpsDevice, FMX.Menus, System.Actions, FMX.ActnList,
  FMX.ListView.Types, FMX.ListView, FMX.Effects, FMX.Edit,
  FMX.Controls.Presentation, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  Data.DB, FireDAC.Comp.Client, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef,
  FireDAC.Phys.SQLite, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  hcShared;

type
  TfrmDevices = class(TForm)
    AniIndicator1: TAniIndicator;
    GradientAnimation1: TGradientAnimation;
    alDevices: TActionList;
    tbTop: TToolBar;
    sbOverflowMenu: TSpeedButton;
    lbOverflowMenu: TListBox;
    acScan: TAction;
    ShadowEffect1: TShadowEffect;
    lbiScanDevices: TListBoxItem;
    acSearch: TAction;
    edSearchIp: TEdit;
    sbSearchDevice: TSearchEditButton;
    lbIp: TLabel;
    lbDevices: TListBox;
    lbPopup: TListBox;
    ShadowEffect2: TShadowEffect;
    procedure acScanExecute(Sender: TObject);
    procedure sbOverflowMenuClick(Sender: TObject);
    procedure lbScanClick(Sender: TObject);
    procedure acSearchExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbDevicesItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure lbPopupExit(Sender: TObject);
    procedure lbOverflowMenuExit(Sender: TObject);
    procedure lbDevicesCanFocus(Sender: TObject; var ACanFocus: Boolean);
    procedure acScanUpdate(Sender: TObject);
  private
    procedure OnClickProc(AObject: TObject);
    procedure OnFinishedSeach(ADevices: TDevices);
    procedure LoadList(AList: TDevices);
    function GetSelectedDevice: TCustomDevice;
  public
    procedure ShowDetails(ADetail: TDeviceDetail);
    procedure ShowAbout(ADevice: TCustomDevice);
  end;

var
  frmDevices: TfrmDevices;

implementation

uses
  hcFrmDeviceInfo, hcFrmSensors, hcFrmUpsControl;

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.NmXhdpiPh.fmx ANDROID}

procedure TfrmDevices.acScanExecute(Sender: TObject);
begin
  AniIndicator1.Visible := True;
  AniIndicator1.Enabled := True;
  Devices.SearchAll(OnFinishedSeach);
  lbDevices.Enabled := False;
end;

procedure TfrmDevices.acScanUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := IsWiFiConnected;
end;

procedure TfrmDevices.acSearchExecute(Sender: TObject);
var
  str: String;
begin
  str := Trim(edSearchIp.Text);
  if (str <> '') and (Devices.Search(str, True) <> nil) then
    LoadList(Devices);
end;

procedure TfrmDevices.FormCreate(Sender: TObject);
begin
  LoadList(Devices);
end;

function TfrmDevices.GetSelectedDevice: TCustomDevice;
begin
  Result := nil;
  if lbDevices.ItemIndex >= 0 then
    Result := TCustomDevice(lbDevices.ListItems[lbDevices.ItemIndex].Tag);
end;

procedure TfrmDevices.lbDevicesCanFocus(Sender: TObject;
  var ACanFocus: Boolean);
begin
  lbPopup.Visible := False;
end;

procedure TfrmDevices.lbDevicesItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
var
  editorSet: TEditorActionSet;
  i, heighListBox: Integer;

  function CreateItem(const ACaption: String; AAction: TEditorAction): TListBoxItem;
  begin
    Result := TListBoxItem.Create(lbPopup);
    Result.StyleLookup := 'listbox_context_item';
    Result.StyledSettings:=[TStyledSetting.Family,TStyledSetting.Style,TStyledSetting.FontColor,TStyledSetting.Other];
    Result.StylesData['item_caption'] := ACaption;
    Result.Tag := Integer(AAction);
    Result.OnClick := OnClickProc;
  end;

begin
  lbPopup.Visible := not lbPopup.Visible;
  if lbPopup.Visible then
  begin
    editorSet := TCustomDevice(lbDevices.ListItems[lbDevices.ItemIndex].Tag).GetEditorType;

    lbPopup.Clear;
    lbPopup.BeginUpdate;
    try
      if eaControl in editorSet then
        lbPopup.AddObject(CreateItem('Control', eaControl));
      if eaSensor in editorSet then
        lbPopup.AddObject(CreateItem('Sensor', eaSensor));
      if eaSetting in editorSet then
        lbPopup.AddObject(CreateItem('Setting', eaSetting));
      if eaAbout in editorSet then
        lbPopup.AddObject(CreateItem('About', eaAbout));
    finally
      lbPopup.EndUpdate;
    end;

    lbPopup.Height := 0;
    for i := 0 to lbPopup.Count - 1 do
    if lbPopup.ListItems[i].Visible then
      lbPopup.Height := lbPopup.Height + lbPopup.itemheight;
    lbPopup.Height := lbPopup.Height + 5;

    lbPopup.SetFocus;
    lbPopup.BringToFront;
    lbPopup.ItemIndex := -1;
    lbPopup.ApplyStyleLookup;
    lbPopup.RealignContent;
  end;
end;

procedure TfrmDevices.lbScanClick(Sender: TObject);
begin
  lbOverflowMenu.Visible := False;
  lbOverflowMenu.ItemIndex := -1;
  acScan.Execute;
end;

procedure TfrmDevices.lbOverflowMenuExit(Sender: TObject);
begin
  lbOverflowMenu.Visible := False;
end;

procedure TfrmDevices.lbPopupExit(Sender: TObject);
begin
  lbPopup.Visible := False;
end;

procedure TfrmDevices.LoadList(AList: TDevices);
var
  i: Integer;
  item: TListBoxItem;
begin
  lbDevices.Items.Clear;
  lbDevices.BeginUpdate;
  try
    for i := 0 to AList.Count - 1 do
    begin
      item := TListBoxItem.Create(lbDevices);
      item.Parent := lbDevices;
      item.Text := Format('%s (%s)',[AList[i].Info.Description, AList[i].IpAddress]);
      item.Tag := Integer(AList[i]);
    end;
  finally
    lbDevices.EndUpdate;
  end;
end;

procedure TfrmDevices.OnClickProc(AObject: TObject);
var
  item: TListBoxItem absolute AObject;
begin
  if not (item is TListBoxItem) then
    Exit;
  case TEditorAction(item.Tag) of
    eaSensor: ShowDetails(GetSelectedDevice.Sensors);
    eaControl: ShowDetails(GetSelectedDevice.Control);
    eaSetting: ShowDetails(GetSelectedDevice.Settings);
    eaAbout: ShowAbout(GetSelectedDevice);
  end;
end;

procedure TfrmDevices.OnFinishedSeach(ADevices: TDevices);
begin
  LoadList(ADevices);
  AniIndicator1.Visible := False;
  AniIndicator1.Enabled := False;
  lbDevices.Enabled := True;
end;

procedure TfrmDevices.sbOverflowMenuClick(Sender: TObject);
begin
  lbOverflowMenu.Visible := not lbOverflowMenu.Visible;
  if lbOverflowMenu.Visible then
  begin
    lbOverflowMenu.BringToFront;
    lbOverflowMenu.ItemIndex := -1;
    lbOverflowMenu.ApplyStyleLookup;
    lbOverflowMenu.RealignContent;
  end;
end;

procedure TfrmDevices.ShowAbout(ADevice: TCustomDevice);
var
  form: TfrmDeviceInfo;
begin
  form := TfrmDeviceInfo.Create(nil);
  form.Init(ADevice.Info);
  {$IFDEF ANDROID}
  form.Show;
  {$ENDIF}
end;

procedure TfrmDevices.ShowDetails(ADetail: TDeviceDetail);
var
  formClass: TfrmEditFormClass;
  form: TfrmEditForm;
begin
  if (Assigned(ADetail)) and (editorFormRegister.TryGetValue(TDeviceDetailClass(ADetail.ClassType), formClass)) then
  begin
    form := formClass.Create(Self);
    form.Init(ADetail);
    {$IFDEF ANDROID}
    form.Show;
    {$ENDIF}
  end;
end;

end.
