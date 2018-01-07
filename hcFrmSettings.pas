unit hcFrmSettings;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.StdCtrls, FMX.Controls.Presentation, hcShared, hcDevice, hcUpsDevice,
  FMX.Layouts, FMX.ListBox, hcFrmSchedule, System.Rtti, System.Actions,
  FMX.ActnList, FMX.Ani;

type
  TfrmUpsSettings = class(TfrmEditForm)
    swAlways: TSwitch;
    lbAuto: TLabel;
    lbAlwaysOn: TLabel;
    swAuto: TSwitch;
    edNTP: TEdit;
    lbNtp: TLabel;
    tbControl: TToolBar;
    sbClose: TSpeedButton;
    lbSettings: TLabel;
    sbSave: TSpeedButton;
    lbSchedules: TListBox;
    lbSchedule: TLabel;
    Layout1: TLayout;
    alSettings: TActionList;
    acSave: TAction;
    acBack: TAction;
    AniIndicator1: TAniIndicator;
    GradientAnimation1: TGradientAnimation;
    procedure acSaveUpdate(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure swAutoSwitch(Sender: TObject);
    procedure swAlwaysSwitch(Sender: TObject);
    procedure edNTPChange(Sender: TObject);
    procedure acBackExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure acBackUpdate(Sender: TObject);
  private
    procedure DoLoaded(AObject: TRespondObject); override;
    procedure DoBeginLoading; override;
    procedure DoEndLoading; override;

    procedure OnEnabledClick(ASender: TObject);
    procedure OnButtonClick(ASender: TObject);
  public
    { Public declarations }
  end;

var
  frmUpsSettings: TfrmUpsSettings;

implementation

{$R *.fmx}
{ TfrmUpsSettings }

procedure TfrmUpsSettings.acBackExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmUpsSettings.acBackUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := not IsLoading;
end;

procedure TfrmUpsSettings.acSaveExecute(Sender: TObject);
begin
  (FDetail as TUpsSetting).Post;
end;

procedure TfrmUpsSettings.acSaveUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := ((FDetail as TUpsSetting).IsModified) and
    (not IsLoading);
end;

procedure TfrmUpsSettings.DoBeginLoading;
begin
  inherited;
  AniIndicator1.Enabled := True;
  AniIndicator1.Visible := True;
end;

procedure TfrmUpsSettings.DoEndLoading;
begin
  inherited;
  AniIndicator1.Enabled := False;
  AniIndicator1.Visible := False;
end;

procedure TfrmUpsSettings.DoLoaded(AObject: TRespondObject);
var
  i: Integer;
  obj: TUpsSetting absolute AObject;
  sensors: TCustomSensors absolute AObject;
  item: TListBoxItem;
begin
  if not(AObject is TUpsSetting) then
    Exit;

  swAuto.IsChecked := obj.AutoMode;
  swAlways.IsChecked := obj.AlwaysOn;
  edNTP.Text := obj.NTP;

  lbSchedules.Clear;
  lbSchedules.BeginUpdate;
  try
    obj.Schedules.Load;
    for i := 0 to obj.Schedules.Count - 1 do
    begin
      obj.Schedules.Items[i].Load;
      item := TListBoxItem.Create(lbSchedules);
      item.StyleLookup := 'listbox_shedule';
      item.StylesData['swEnabled'] := obj.Schedules.Items[i].Enabled;
      item.StylesData['swEnabled.Tag'] := i;
      item.StylesData['swEnabled.OnSwitch'] :=
        TValue.From<TNotifyEvent>(OnEnabledClick);
      item.StylesData['lbCaption'] := obj.Schedules.Items[i].toString;
      item.StylesData['sbEdit.OnClick'] := TValue.From<TNotifyEvent>
        (OnButtonClick);
      item.Tag := i;
      item.Data := obj.Schedules.Items[i];
      lbSchedules.AddObject(item);
    end;
  finally
    lbSchedules.EndUpdate;
  end;
end;

procedure TfrmUpsSettings.edNTPChange(Sender: TObject);
begin
  (FDetail as TUpsSetting).NTP := edNTP.Text;
end;

procedure TfrmUpsSettings.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

function FindItemParent(obj: TFmxObject; ParentClass: TClass): TFmxObject;
begin
  Result := nil;
  if Assigned(obj.Parent) then
    if obj.Parent.ClassType = ParentClass then
      Result := obj.Parent
    else
      Result := FindItemParent(obj.Parent, ParentClass);
end;

procedure TfrmUpsSettings.OnButtonClick(ASender: TObject);
var
  form: TfrmSchedule;
  item: TListBoxItem;
begin
  item := TListBoxItem(FindItemParent(ASender as TFmxObject, TListBoxItem));
  if Assigned(item) then
  begin
    form := TfrmSchedule.Create(nil);
    form.Init(TSchedule(item.Data));
    form.ShowModal(
      procedure(ModalResult: TModalResult)
      begin
        item.StylesData['swEnabled'] := TSchedule(item.Data).Enabled;
        item.StylesData['lbCaption'] := TSchedule(item.Data).toString;
      end);
  end;
end;

procedure TfrmUpsSettings.OnEnabledClick(ASender: TObject);
var
  form: TfrmSchedule;
  item: TSwitch absolute ASender;
begin
  if not (ASender is TSwitch) then
    Exit;

  if Assigned(item) then
    (FDetail as TUpsSetting).Schedules.Items[item.Tag].Enabled := item.IsChecked;
end;

procedure TfrmUpsSettings.swAlwaysSwitch(Sender: TObject);
begin
  (FDetail as TUpsSetting).AlwaysOn := swAlways.IsChecked;
end;

procedure TfrmUpsSettings.swAutoSwitch(Sender: TObject);
begin
  (FDetail as TUpsSetting).AutoMode := swAuto.IsChecked;
end;

initialization
  editorFormRegister.Add(TUpsSetting, TfrmUpsSettings);

end.
