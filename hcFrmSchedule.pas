unit hcFrmSchedule;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.DateTimeCtrls, hcUpsDevice, FMX.StdCtrls, FMX.Controls.Presentation,
  System.Actions, FMX.ActnList, hcShared;

type
  TfrmSchedule = class(TForm)
    teFrom: TTimeEdit;
    lbFrom: TLabel;
    tbControl: TToolBar;
    sbClose: TSpeedButton;
    lbSettings: TLabel;
    teTo: TTimeEdit;
    lbTo: TLabel;
    swState: TSwitch;
    lbState: TLabel;
    alSchedule: TActionList;
    acBack: TAction;
    procedure sbCloseClick(Sender: TObject);
    procedure swStateSwitch(Sender: TObject);
    procedure teFromChange(Sender: TObject);
    procedure teToChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure acBackExecute(Sender: TObject);
  private
    FObject: TSchedule;
  public
    procedure Init(AObject: TSchedule);
  end;

var
  frmSchedule: TfrmSchedule;

implementation

{$R *.fmx}

{ TfrmSchedule }

procedure TfrmSchedule.acBackExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmSchedule.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action := TCloseAction.caFree;
 ModalResult := mrOK;
end;

procedure TfrmSchedule.Init(AObject: TSchedule);
begin
  FObject := AObject;
  teFrom.Time := AObject.StartHour.toTime;
  teTo.Time := AObject.EndHour.toTime;
  swState.IsChecked := AObject.State;
end;

procedure TfrmSchedule.sbCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSchedule.swStateSwitch(Sender: TObject);
begin
  FObject.State := swState.IsChecked;
end;

procedure TfrmSchedule.teFromChange(Sender: TObject);
begin
  FObject.StartHour.setTime(teFrom.Time);
end;

procedure TfrmSchedule.teToChange(Sender: TObject);
begin
  FObject.EndHour.setTime(teTo.Time);
end;

end.
