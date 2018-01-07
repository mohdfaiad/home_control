unit hcShared;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, System.ImageList,
  FMX.ImgList, FMX.Forms, System.Generics.Collections, hcDevice;

type
  TdmShared = class(TDataModule)
    sbListBox: TStyleBook;
    ImageList1: TImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TfrmEditForm = class(TForm)
  private
    FLoading: Boolean;
    procedure OnLoaded(AObject: TRespondObject);
  protected
    FDetail: TDeviceDetail;
    procedure DoLoaded(AObject: TRespondObject); virtual;
    procedure DoBeginLoading; virtual;
    procedure DoEndLoading; virtual;
  public
    property IsLoading: Boolean read FLoading;
    procedure Init(ADetail: TDeviceDetail); virtual;
    procedure Load;
  end;

  TfrmEditFormClass = class of TfrmEditForm;

var
  dmShared: TdmShared;
  editorFormRegister: TDictionary<TDeviceDetailClass, TfrmEditFormClass>;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TfrmEditForm }

procedure TfrmEditForm.DoBeginLoading;
begin
  ;
end;

procedure TfrmEditForm.DoEndLoading;
begin
  ;
end;

procedure TfrmEditForm.DoLoaded(AObject: TRespondObject);
begin
  ;
end;

procedure TfrmEditForm.Init(ADetail: TDeviceDetail);
begin
  FDetail := ADetail;
  Load;
end;

procedure TfrmEditForm.Load;
begin
  FLoading := True;
  FDetail.Load(OnLoaded);
  DoBeginLoading;
end;

procedure TfrmEditForm.OnLoaded(AObject: TRespondObject);
begin
  DoLoaded(AObject);
  DoEndLoading;
  FLoading := False;
end;

initialization
  editorFormRegister := TDictionary<TDeviceDetailClass, TfrmEditFormClass>.Create;

finalization
  FreeAndNil(editorFormRegister);
end.
