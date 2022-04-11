unit LogosUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, ExtCtrls, Menus, StdCtrls, ImgList, Math, ShellApi, System.ImageList;

const
  //макс. размеры поля:
  MAX_POLE_WIDTH= 14;
  MAX_POLE_HEIGHT= 14;
  NAME_PROG='Logos';
  letter: string= 'ABCDEFGHIJKLM';

type
  TPole= array[0..MAX_POLE_WIDTH-1, 0..MAX_POLE_HEIGHT-1] of Shortint;
  TMemory= Record
    Hod: integer;
    //позиция на полях:
    PosL, PosR: TPole;
  end;
  //состояние программы:
  TGameState= (gsWait, gsSolution);
  //ходы:
  TMoves= Record
    //колонка:
    Col: integer;
    //строка:
    Row: integer;
    //позиция на полях:
    PosL, PosR: TPole;
  end;

var
  //поля:
  masPole, masPole2: TPole;
  Memory: TMemory;
  GameState: TGameState= gsWait;
  //запись ходов:
  Moves: array[0..169] of TMoves;
  //номер хода:
  Hod: integer= 0;
  Hod_max: integer= 0;
  step: integer;
  rep: integer= 0;
  flgFlash: integer= 0;
  LastComp: integer= 0;

  Move: array[0..169] of TPoint;
  NameFig: string= '';

type
  Tlogos_form = class(TForm)
    img2: TImage;
    img1: TImage;
    dgPole: TDrawGrid;
    Image1: TImage;
    dgPole2: TDrawGrid;
    PopupMenu1: TPopupMenu;
    miMemoryIn: TMenuItem;
    miMemoryOut: TMenuItem;
    N6: TMenuItem;
    miHelp: TMenuItem;
    Image2: TImage;
    imgUndo: TImage;
    lblHod: TLabel;
    Image3: TImage;
    Image4: TImage;
    imgClearL: TImage;
    imgRedo: TImage;
    Image5: TImage;
    Image6: TImage;
    imgClearR: TImage;
    imgCopyRL: TImage;
    imgCopyLR: TImage;
    Image11: TImage;
    Image12: TImage;
    Timer1: TTimer;
    Image13: TImage;
    Image14: TImage;
    imgSolution: TImage;
    miUndo: TMenuItem;
    miRedo: TMenuItem;
    imgExit: TImage;
    imlNota: TImageList;
    Timer2: TTimer;
    Image9: TImage;
    Image10: TImage;
    imgOpen: TImage;
    OpenDialog1: TOpenDialog;
    imgSavePosL: TImage;
    SaveDialog1: TSaveDialog;
    Image18: TImage;
    Image19: TImage;
    Img3: TImage;
    Img4: TImage;
    Img0: TImage;
    imlAnima: TImageList;
    Img00: TImage;
    imgSavePosR: TImage;
    Image7: TImage;
    Image8: TImage;
    Image17: TImage;
    Image20: TImage;
    imgHelp: TImage;
    Image21: TImage;
    Image22: TImage;
    procedure dgPoleDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure dgPoleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure dgPole2DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure imgUndoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgUndoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure dgPole2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgClearLMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgClearLMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgRedoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgRedoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgClearRMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgClearRMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgCopyRLMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgCopyRLMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgCopyLRMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgCopyLRMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure imgSolutionMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgSolutionMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lblHodClick(Sender: TObject);
    procedure miUndoClick(Sender: TObject);
    procedure miRedoClick(Sender: TObject);
    procedure miHelpClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure imgOpenMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgSavePosLMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgSavePosLMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure miMemoryInClick(Sender: TObject);
    procedure miMemoryOutClick(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure imgHelpMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgHelpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgExitMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgExitMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);

  private
    { Private declarations }
    procedure NewPlay;

    procedure Solution(arr: TPole);
    procedure MemoryIn;
    procedure Open (fn: string);
    procedure SavePos(arr: TPole);
    function BackMove(arr: TPole; x, y: integer): TPole;
  public
    { Public declarations }
    function DoMove(arr: TPole; x, y: integer): TPole;
    function IsReady: Boolean;
    procedure Ready;
  end;

var
  logos_form: Tlogos_form;

implementation

uses ProtokolUnit, ReadyUnit;

{$R *.DFM}

//СОЗДАТЬ ФОРМУ
procedure Tlogos_form.FormCreate(Sender: TObject);
begin
  //подготовить новую игру:
  NewPlay;
end; //FormCreate

//ПОДГОТОВКА К НОВОЙ ИГРЕ
procedure Tlogos_form.NewPlay;
var
 i, j: integer;
begin
  //обнулить число ходов:
  Hod:= 0;   Hod_max:= 0;
  lblHod.Caption:=  'Ход - 0';

  //задача не имеет названия:
  form1.caption:= NAME_PROG + '   []';

  //очистить левое поле:
  for j:= 1 to dgPole.RowCount-1 do
    for i:= 1 to dgPole.ColCount-1 do
      masPole[i,j]:= 0;
  dgPole.Invalidate;

  //очистить правое поле:
  masPole2:= masPole;
  dgPole2.Invalidate;
  //запомнить начальную позицию:
  MemoryIn;
end; //NewPlay

//ОТРИСОВАТЬ ЯЧЕЙКУ ИГРОВОГО ПОЛЯ
procedure Tlogos_form.dgPoleDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  n, m: integer;
  r, dr: TRECT;
begin
  //какая фишка в ячейке:
  n:= masPole[ACol, ARow];
  //размеры картинок:
  r:= Bounds(0, 0, 32, 32);
  dr:= Bounds(Rect.Left, Rect.Top, 32, 32);
  m:= 100 * ARow + ACol;
  case m of
    0..13: //- верхняя строка
      imlNota.Draw(dgPole.Canvas, dr.left, dr.top, m);
    100, 200, 300, 400, 500, 600, 700, 800, 900,1000,1100,1200,1300: //- первая колонка
      imlNota.Draw(dgPole.Canvas, dr.left, dr.top, m div 100+13);
    else begin
      case n of
        0:    //- пустая клетка
          if masPole2[ACol, ARow]<> 0 then
            dgPole.canvas.CopyRect(dR, img00.Canvas, R)
          else
            dgPole.canvas.CopyRect(dR, img0.Canvas, R);
        1:   //- фишка 1
          dgPole.canvas.CopyRect(dR, img1.Canvas, R);
        2:   //- фишка 2
          dgPole.canvas.CopyRect(dR, img2.Canvas, R);
        3:   //- фишка 3
          dgPole.canvas.CopyRect(dR, img3.Canvas, R);
        4:   //- фишка 4
          dgPole.canvas.CopyRect(dR, img4.Canvas, R);
      end
    end
  end;
end;  //dgPoleDrawCell

//ПУЛЬСИРОВАНИЕ УГЛОВОГО КВАДРАТИКА
procedure Tlogos_form.Timer2Timer(Sender: TObject);
var
  rect: TRect;
  n: integer;
begin

//exit;

  //угловой квадратик поля:
  rect:= dgPole.CellRect(0,0);
  //номер картинки:
  case flgFlash of
    0,1: inc(flgFlash);
    2: inc(flgFlash);
    3: flgFlash:= 0;
  end;
  if flgFlash= 3 then n:= 0 else n:= flgFlash;
  imlAnima.Draw(dgPole.Canvas, rect.left, rect.top, n);
end;  //Timer2Timer

//ОТРИСОВАТЬ ЯЧЕЙКУ ПОЛЯ-ОБРАЗЦА
procedure Tlogos_form.dgPole2DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  n, m: integer;
  r, dr: TRECT;
  bmp: TBitmap;
begin
  //фишка в ячейке:
  n:= masPole2[ACol, ARow];
  //размеры картинок:
  r:= Bounds(0, 0, 16, 16);
  dr:= Bounds(Rect.Left, Rect.Top, Rect.Right-Rect.Left,Rect.Bottom-Rect.Top);

  m:= 100 * ARow + ACol;

  bmp:= TBitmap.Create;
  bmp.Width:= 32;
  bmp.Height:= 32;

  case m of
    0..13: //- верхняя строка
      begin
        imlNota.Draw(bmp.Canvas, 0, 0, m);
        dgPole2.canvas.StretchDraw(dR, bmp);
      end;
    100, 200, 300, 400, 500, 600, 700, 800, 900,1000,1100,1200,1300: //- первая колонка
      begin
        imlNota.Draw(bmp.Canvas, 0, 0, m div 100 + 9);
        dgPole2.canvas.StretchDraw(dR, bmp);
      end;
    else begin
      case n of
        0:    //- пустая клетка
          dgPole2.canvas.StretchDraw(dR, img0.Picture.Graphic);
        1:   //- фишка 1
          dgPole2.canvas.StretchDraw(dR, img1.Picture.Graphic);
        2:   //- фишка 2
          dgPole2.canvas.StretchDraw(dR, img2.Picture.Graphic);
        3:   //- фишка 3
          dgPole2.canvas.StretchDraw(dR, img3.Picture.Graphic);
        4:   //- фишка 4
          dgPole2.canvas.StretchDraw(dR, img4.Picture.Graphic);
      end
    end
  end;
  bmp.Free;
  dgPole.Invalidate;
end;  //dgPole2DrawCell

//ПОСТАВИТЬ ФИШКУ НА ПОЛЕ-ОБРАЗЦЕ
procedure Tlogos_form.dgPole2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ACol,ARow: integer;
begin
  //координаты мыши:
  dgPole2.MouseToCell(x,y,ACol,ARow);
  //нажата левая кнопка мыши - ставим след. фишку:
  if (ssLeft in shift) then begin
    inc(masPole2[ACol,ARow]);
    if masPole2[ACol,ARow]>4 then masPole2[ACol,ARow]:= 0;
    dgPole2.Invalidate;
  end
end;  //dgPole2MouseDown

//ВЫСТАВИТЬ ФИШКУ ИЛИ СДЕЛАТЬ ХОД
procedure Tlogos_form.dgPoleMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ACol,ARow: integer;
begin
  //координаты мыши:
  dgPole.MouseToCell(x,y,ACol,ARow);
  if ACol * ARow = 0 then exit;
  //нажата левая кнопка мыши и клавиша Shift -
  //ставим след. фишку:
  if (ssLeft in shift) and (ssShift in shift ) then begin
    inc(masPole[ACol,ARow]);
    if masPole[ACol,ARow]>4 then masPole[ACol,ARow]:= 0;
    dgPole.Invalidate;
  end
  else if (ssLeft in shift) and (ssAlt in shift )then begin
    //не нужно ходить в пустую клетку:
    if masPole[ACol, ARow]= 0 then exit;
    //ход назад:
    masPole:=BackMove(masPole, ACol, ARow);
    inc(Hod); lblHod.Caption:= 'Ход - ' + inttostr(Hod);
    dgPole.Invalidate;
    //запомнить ход:
    Moves[Hod].Col:= ACol;
    Moves[Hod].Row:= ARow;
    Moves[Hod].PosL:= masPole;
    Hod_max:= Hod;
    //занести ход в протокол:
    frmProtokol.ListBox1.items.add(format('%3d',[Hod]) + '. ' +
                         letter[ACol]+ ' ' +inttostr(ARow));
  end
  //нажата левая кнопка мыши без клавиши Shift и Alt -
  //делаем ход:
  else if ssLeft in shift then begin
    if masPole[ACol, ARow]<> 0 then exit;
    masPole:=DoMove(masPole, ACol, ARow);
    inc(Hod); lblHod.Caption:= 'Ход - ' + inttostr(Hod);
    dgPole.Invalidate;
    //запомнить ход:
    Moves[Hod].Col:= ACol;
    Moves[Hod].Row:= ARow;
    Moves[Hod].PosL:= masPole;
    Hod_max:= Hod;
    //занести ход в протокол:
    frmProtokol.ListBox1.items.add(format('%3d',[Hod]) + '. ' +
                         letter[ACol]+ ' ' +inttostr(ARow));
    //проверить, не решена ли задача:
    if IsReady then Ready;
    ///Ready;
  end
end;  //dgPoleMouseDown

//ВЫПОЛНИТЬ ХОД
function Tlogos_form.DoMove(arr: TPole; x, y: integer): TPole;
var i: integer;
begin
  result:= arr;
  //нельзя ходить в занятую клетку:
  if arr[x,y]<> 0 then begin dec(hod);exit; end;
  //изменить соседние фишки:
  for i:= Max(y-1,1) to Min(y+1,dgPole.RowCount-1) do //- вертикальный ряд
  begin
    if arr[x,i] <> 0 then inc(arr[x,i]);
    if arr[x,i]>4 then arr[x,i]:= 1;
  end;
  for i:= Max(x-1,1) to Min(x+1,dgPole.ColCount-1) do //- горизонтальный ряд
  begin
    if arr[i,y] <> 0 then inc(arr[i,y]);
    if arr[i,y]>4 then arr[i,y]:= 1;
  end;
  //поставить в заданную клетку фишку 1:
  arr[x,y]:= 1;
  result:= arr;
end; //DoMove

//ПРОВЕРИТЬ, НЕ РЕШЕНА ЛИ ЗАДАЧА
function Tlogos_form.IsReady: Boolean;
var
  i, j: integer;
begin
  Result:= True;
  for j:= 1 to dgPole.RowCount-1 do
    for i:= 1 to dgPole.ColCount-1 do
      if masPole[i,j]<> masPole2[i,j] then
        begin Result:= False; exit end
end; //IsReady

//ЗАДАЧА РЕШЕНА!
procedure Tlogos_form.Ready;
begin
  rep:= 0;
  ReadyUnit.frmReady.label1.Top:= 32;
  frmReady.Show;
  timer1.Enabled:= true;
end; //Ready

//СОЗДАТЬ ФОН ДЛЯ НАДПИСИ
procedure OutReady;
var
  bmp: TBitmap;
  i, j: integer;
begin
  //создать временный растр:
  bmp:=TBitmap.Create;
  bmp.Height:= ReadyUnit.frmReady.Image1.Height;
  bmp.Width:= ReadyUnit.frmReady.Image1.Width;
  //заполнить его точками серого и белого цвета:
  for j:= 0 to bmp.Height do
    for i:= 0 to bmp.Width do
      if random(2) = 0 then bmp.Canvas.Pixels[i,j]:= clGray
      else bmp.Canvas.Pixels[i,j]:= clWhite;
  //обвести рамкой:
  bmp.Canvas.Brush.Style:= bsClear;
  bmp.Canvas.Pen.Width:= 5;
  bmp.Canvas.Pen.Color:= clYellow;
  bmp.Canvas.Rectangle(0,0,bmp.Width,bmp.Height);
  //скопировать в объект Image1:
  ReadyUnit.frmReady.Image1.Picture.Bitmap.Assign(bmp);
  //уничтожить растр:
  bmp.FreeImage;
end;  //OutReady;

//ПОЗДРАВИТЬ
procedure Tlogos_form.Timer1Timer(Sender: TObject);
begin
  OutReady;
  inc(rep);
  if rep mod 10 > 5  then ReadyUnit.frmReady.label1.Font.Color:= clBlue
  else ReadyUnit.frmReady.label1.Font.Color:= clRed;
  ReadyUnit.frmReady.label1.Top:= ReadyUnit.frmReady.label1.Top+1;
  if rep> 60 then begin
    timer1.Enabled:= false;
    frmReady.Hide;
  end;
end;  //Timer1Timer

//ЗАПОМНИТЬ ПОЗИЦИЮ
procedure Tlogos_form.MemoryIn;
begin
  Memory.hod:= Hod;
  Memory.PosL:= masPole;
  Memory.PosR:= masPole2;
end; //MemoryIn
procedure Tlogos_form.miMemoryInClick(Sender: TObject);
begin
  MemoryIn;
end; //miMemoryInClick

//ВОССТАНОВИТЬ ПОЗИЦИЮ НА ПОЛЕ
procedure Tlogos_form.miMemoryOutClick(Sender: TObject);
var i: integer;
begin
  with Memory do begin
    masPole:= PosL;
    masPole2:= PosR;
  end;
  dgPole.Invalidate;
  dgPole2.Invalidate;
  Hod:= Memory.hod;
  lblHod.Caption:= 'Ход - ' + inttostr(hod);
  //обновить протокол:
  frmProtokol.ListBox1.items.Clear;
  for i:= 1 to hod do
    frmProtokol.ListBox1.items.add(format('%3d',[i]) + '. ' +
                         letter[Moves[i].Col]+ ' ' +inttostr(Moves[i].Row));
end; //miMemoryOutClick

//ВЕРНУТЬ ХОД
procedure Tlogos_form.miUndoClick(Sender: TObject);
var i: integer;
begin
  if hod= Memory.Hod then exit;
  dec(hod);
  lblHod.Caption:=  'Ход - ' + inttostr(hod);
  masPole:= Moves[hod].PosL;
  dgPole.Invalidate;
  //обновить протокол:
  frmProtokol.ListBox1.items.Clear;
  for i:= 1 to hod do
    frmProtokol.ListBox1.items.add(format('%3d',[i]) + '. ' +
                         letter[Moves[i].Col]+ ' ' +inttostr(Moves[i].Row));
end; // miUndoClick

//ОТМЕНИТЬ ПОСЛЕДНИЙ ВОЗВРАТ ХОДА
procedure Tlogos_form.miRedoClick(Sender: TObject);
var i: integer;
begin
  if Hod< Hod_max then inc(hod)
  else exit;
  //восстановить позицию на игровом поле:
  masPole:=Moves[Hod].PosL ;
  dgPole.Invalidate;
  lblHod.Caption:= 'Ход - ' + inttostr(hod);
  //обновить протокол:
  frmProtokol.ListBox1.items.Clear;
  for i:= 1 to hod do
    frmProtokol.ListBox1.items.add(format('%3d',[i]) + '. ' +
                         letter[Moves[i].Col]+ ' ' +inttostr(Moves[i].Row));
end;  //miRedoClick

//ОБНУЛИТЬ ХОДЫ
procedure Tlogos_form.lblHodClick(Sender: TObject);
begin
  Hod:= 0;   Hod_max:= 0;
  lblHod.Caption:=  'Ход - 0';
  frmProtokol.listbox1.items.add('');
end;  //lblHodClick

//ЗАКРЫТЬ ПРОГРАММУ
procedure Tlogos_form.imgExitMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  imgExit.Picture.Assign(Image20.Picture);
end; //imgExitMouseDown
procedure Tlogos_form.imgExitMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  imgExit.Picture.Assign(Image17.Picture);
  close
end; //imgExitMouseUp

//МЫШКА ПЕРЕМЕЩАЕТСЯ ПО ФОРМЕ И КОМПОНЕНТАМ НА НЕЙ
procedure Tlogos_form.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var n: integer;
begin
  //на каком компоненте находится курсор:
  n:= (Sender as TComponent).tag;
  //тот же компонент - ничего не делать:
  if n= LastComp then exit;

  //выключить прежнюю кнопку:
  case LastComp of
    101: imgSavePosL.Picture.Assign(Image19.Picture);
    102: imgClearL.Picture.Assign(Image4.Picture);
    103: imgSavePosR.Picture.Assign(Image19.Picture);
    104: imgOpen.Picture.Assign(Image10.Picture);
    105: imgClearR.Picture.Assign(Image4.Picture);
    106: imgSolution.Picture.Assign(Image14.Picture);
    107: imgCopyLR.Picture.Assign(Image12.Picture);
    108: imgCopyRL.Picture.Assign(Image6.Picture);
    109: imgUndo.Picture.Assign(Image2.Picture);
    110: imgRedo.Picture.Assign(Image8.Picture);
    111: imgExit.Picture.Assign(Image20.Picture);
    112: imgHelp.Picture.Assign(Image22.Picture);
  end;

  //зашли на новую кнопку - включить:
  LastComp:= (Sender as TComponent).tag;
  case LastComp of
      0: exit;  //- не кнопка
    101: imgSavePosL.Picture.Assign(Image18.Picture);
    102: imgClearL.Picture.Assign(Image3.Picture);
    103: imgSavePosR.Picture.Assign(Image18.Picture);
    104: imgOpen.Picture.Assign(Image9.Picture);
    105: imgClearR.Picture.Assign(Image3.Picture);
    106: imgSolution.Picture.Assign(Image13.Picture);
    107: imgCopyLR.Picture.Assign(Image11.Picture);
    108: imgCopyRL.Picture.Assign(Image5.Picture);
    109: imgUndo.Picture.Assign(Image1.Picture);
    110: imgRedo.Picture.Assign(Image7.Picture);
    111: imgExit.Picture.Assign(Image17.Picture);
    112: imgHelp.Picture.Assign(Image21.Picture);
  end;
end;  //FormMouseMove

//ВОЗВРАТ ХОДА
procedure Tlogos_form.imgUndoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  imgUndo.Picture.Assign(Image2.Picture);
end; //imgUndoMouseDown
procedure Tlogos_form.imgUndoMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  miUndoClick(Self);
  imgUndo.Picture.Assign(Image1.Picture);
end; //imgUndoMouseUp

//ХОД ВПЕРЁД
procedure Tlogos_form.imgRedoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  imgRedo.Picture.Assign(Image8.Picture);
end; //imgRedoMouseDown
procedure Tlogos_form.imgRedoMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  miRedoClick(Self);
  imgRedo.Picture.Assign(Image7.Picture);
end; //imgRedoMouseUp

//ОЧИСТИТЬ ЛЕВОЕ ПОЛЕ
procedure Tlogos_form.imgClearLMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  imgClearL.Picture.Assign(Image4.Picture);
end; //imgClearLMouseDown
procedure Tlogos_form.imgClearLMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i, j: integer;
begin
  for j:= 1 to dgPole.RowCount-1 do
    for i:= 1 to dgPole.ColCount-1 do
      masPole[i,j]:= 0;
  dgPole.Invalidate;
  MemoryIn;
  imgClearL.Picture.Assign(Image3.Picture);
end; //imgClearLMouseUp

//ОЧИСТИТЬ ПРАВОЕ ПОЛЕ
procedure Tlogos_form.imgClearRMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  imgClearR.Picture.Assign(Image4.Picture);
end; //imgClearRMouseDown
procedure Tlogos_form.imgClearRMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i, j: integer;
begin
  for j:= 1 to dgPole2.RowCount-1 do
    for i:= 1 to dgPole2.ColCount-1 do
      masPole2[i,j]:= 0;
  dgPole2.Invalidate;
  masPole:= masPole2;
  dgPole.Invalidate;
  MemoryIn;
  frmProtokol.listbox1.Clear;
  imgClearR.Picture.Assign(Image3.Picture);
end; //imgClearRMouseUp

//КОПИРОВАТЬ ЛЕВОЕ ПОЛЕ В ПРАВОЕ
procedure Tlogos_form.imgCopyLRMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  //заменить картинку:
  imgCopyLR.Picture.Assign(Image12.Picture);
  masPole2:= masPole;
  dgPole2.Invalidate;
end; //imgCopyLRMouseDown
procedure Tlogos_form.imgCopyLRMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  imgCopyLR.Picture.Assign(Image11.Picture);
end; //imgCopyLRMouseUp

//КОПИРОВАТЬ ПРАВОЕ ПОЛЕ В ЛЕВОЕ
procedure Tlogos_form.imgCopyRLMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  imgCopyRL.Picture.Assign(Image6.Picture);
  masPole:= masPole2;
  dgPole.Invalidate;
end; //imgCopyRLMouseDown
procedure Tlogos_form.imgCopyRLMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  imgCopyRL.Picture.Assign(Image5.Picture);
end; //imgCopyRLMouseUp

//ЗАПИСАТЬ ПОЗИЦИЮ НА ЛЕВОМ ИЛИ ПРАВОМ ПОЛЕ
procedure Tlogos_form.imgSavePosLMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  imgSavePosL.Picture.Assign(Image19.Picture)
end; //imgSavePosLMouseDown
procedure Tlogos_form.imgSavePosLMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  imgSavePosL.Picture.Assign(Image18.Picture);
  if (Sender as TComponent).tag= 101 then begin // - левое поле
    SavePos(masPole) end
  else begin                                    // - правое поле
    SavePos(masPole2) end;
end; //imgSavePosLMouseUp

//ЗАПИСАТЬ ПОЗИЦИЮ НА ЗАДАННОМ ПОЛЕ
procedure Tlogos_form.SavePos(arr: TPole);
var
  F: textfile;
  fn,s: string;
  i,j: integer;
begin
  savedialog1.DefaultExt:='txt';
  savedialog1.Filter:='Задачи (*.lgs)|*.LGS';
  savedialog1.FilterIndex:=1;
  s:=extractfilepath(application.exename)+'Figures\';
  savedialog1.InitialDir:= s;
  savedialog1.Title:='Запишите позицию на диск';
  if NameFig<>'' then savedialog1.filename:= NameFig
  else savedialog1.filename:='temp.lgs';
  if not savedialog1.Execute then exit;
  //имя конечного файла:
  fn:= savedialog1.filename;
  NameFig:=fn;
  assignfile(f,fn);
  rewrite(f);
  //записать позицию:
  for j:= 1 to 13 do begin
    s:='';
    for i:= 1 to 13 do s:=s+ inttostr(arr[i][j]);
    writeln (f,s);
  end;
  closefile(f);
  //вывести в заголовок формы имя файла:
  form1.caption:= NAME_PROG + '   [' + NameFig + ']';
  messagebeep(0)
end; //SavePos

//ЗАГРУЗИТЬ ЗАДАЧУ
procedure Tlogos_form.imgOpenMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  imgOpen.Picture.Assign(Image10.Picture);
  Open('');
end; //imgOpenMouseDown

//ЗАГРУЗИТЬ ЗАДАЧУ С ЗАДАННЫМ ИМЕНЕМ
procedure Tlogos_form.Open (fn: string);
var
  s: string;
  F: TextFile;
  nLines,Len: integer;
  i,j:integer;
  ss: array[1..MAX_POLE_HEIGHT] of string;
begin
  if fn='' then begin  //- имя файла не задано
    form1.opendialog1.DefaultExt:='lgs';
    form1.opendialog1.Filter:='Logos files (*.lgs)|*.LGS';
    s:=extractfilepath(application.exename)+'FIGURES\';
    form1.opendialog1.InitialDir:= s;
    form1.opendialog1.Title:='Загрузите новую задачу';
    if not form1.opendialog1.Execute then exit;
    s:= form1.opendialog1.filename
    end
  else s:=extractfilepath(application.exename)+'FIGURES\'+ fn;

  //название задачи:
  NameFig:=s;

  {$i-}
  AssignFile(F,NameFig);
  Reset(F);
  {$i+}
  if IOResult<>0 then begin  //- ошибка при загрузке файла
    application.MessageBox ('Такой задачи нет!',NAME_PROG, MB_OK);
    exit
  end;

  nLines:=0;
  Len:=0;
  while not eof(f) do begin
    inc(nLines);
    //считать строку из файла:
    Readln(F, S);
    ss[nLines]:=s;
    If (Length(s) <> Len) and (Len<>0) Then begin
      application.MessageBox ('Неверная длина строки!',NAME_PROG, MB_OK);
      exit
      end
    else
      Len:= Length(s);
  end;
  //закрыть файл:
  CloseFile(F);
  //проверить данные:
  if (Len> MAX_POLE_WIDTH) or (nLines> MAX_POLE_HEIGHT) then begin
    application.MessageBox('Неверные данные!',NAME_PROG, MB_OK);
    exit
  end;
  //вывести в заголовок имя файла:
  form1.caption:= NAME_PROG + '   [' + NameFig + ']';

  //очистить массивы полей:
  for j:= 1 to dgPole.RowCount-1 do
    for i:= 1 to dgPole.ColCount-1 do begin
      masPole[i,j]:= 0;
    end;
  //и протокол:
  frmProtokol.listbox1.items.Clear;
  //заполнить массив новыми данными:
  for j:=1 to nLines do
    for i:=1 to Len do
       masPole2[i][j]:= strtoint(ss[j,i]);
  //запомнить начальную позицию:
  MemoryIn;
  //обновить поля:
  dgPole.Invalidate;
  dgPole2.Invalidate;
  //обнулить ходы:
  Hod:= 0;   Hod_max:= Hod;
  lblHod.Caption:= 'Ход - ' + inttostr(Hod);
end; //Open

//ПОКАЗАТЬ ФОРМУ
procedure Tlogos_form.FormShow(Sender: TObject);
begin
  open('001.lgs');
  frmProtokol.show;
end; //FormShow

procedure Tlogos_form.FormActivate(Sender: TObject);
begin
  frmProtokol.Left:= form1.Left + lblHod.Left;
  frmProtokol.Top:= form1.Top + lblHod.Top+lblHod.Height+35;
end; //FormActivate

//ПОКАЗАТЬ ФАЙЛ СПРАВКИ
procedure Tlogos_form.miHelpClick(Sender: TObject);
var s: string;
begin
//WinHelp(handle, PChar('XorGame.hlp'), HELP_CONTENTS,0)
  s:= extractfilepath(application.exename)+'LogosHelp.htm';
  //showmessage(s);
  //ShellExecute(handle, pChar('open'),pChar('iexplore'),pChar(s),
  //'', SW_SHOWNORMAL);
  ShellExecute(handle, pChar('open'),pChar('iexplore'),pChar(s),
  '', SW_SHOWMAXIMIZED);
end;  //miHelpClick
procedure Tlogos_form.imgHelpMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  imgHelp.Picture.Assign(Image22.Picture);
end;  //imgHelpMouseDown
procedure Tlogos_form.imgHelpMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var s: string;
begin
  imgHelp.Picture.Assign(Image21.Picture);
  s:= extractfilepath(application.exename)+'LogosHelp.htm';
  ShellExecute(handle, 'open','iexplore',pChar(s),
  '', SW_SHOWMAXIMIZED);
end;  //imgHelpMouseDown

//ХОД НАЗАД
function Tlogos_form.BackMove(arr: TPole; x, y: integer): TPole;
var i: integer;
begin
  result:= arr;
  //изменить соседние фишки:
  for i:= Max(y-1,1) to Min(y+1,dgPole.RowCount-1) do //- вертикальный
  begin
    if (i<> y) and (arr[x,i] <> 0) then begin
      dec(arr[x,i]);
      if arr[x,i]=0 then arr[x,i]:= 4; end;
  end;
  for i:= Max(x-1,1) to Min(x+1,dgPole.ColCount-1) do //- горизонтальный
  begin
    if (i<> x) and (arr[i,y] <> 0) then begin
      dec(arr[i,y]);
      if arr[i,y]=0 then arr[i,y]:= 4; end;
  end;
  //уменьшить на единицу значение заданной фишки:
  dec(arr[x,y]);
  result:= arr;
end; //BackMove

//НАЙТИ РЕШЕНИЕ ЗАДАЧИ
procedure Tlogos_form.imgSolutionMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  imgSolution.Picture.Assign(Image14.Picture);
end; //imgSolutionMouseDown
procedure Tlogos_form.imgSolutionMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  imgSolution.Picture.Assign(Image13.Picture);
  if GameState= gsSolution then exit;
  //перевести программу в режим поиска:
  GameState:= gsSolution;
  //искать решение:
  solution(masPole2);
  //перевести программу в режим ожидания ввода команд:
  GameState:= gsWait;
end; //imgSolutionMouseUp

//АВТОМАТИЧЕСКОЕ РЕШЕНИЕ ЗАДАЧИ
procedure Tlogos_form.Solution(arr: TPole);
var
  Hod: integer;
  w,h: integer;
  x, y: byte;
  flgHod: Boolean;
  arr1, arr2: TPole;

  //Подсчитать число ходов (фишек)
  function Steps: integer;
  var
    i, j: integer;
  begin
    Result:= 0;
    for j:= 1 to h do
      for i:= 1 to w do
        if arr2[i,j]<> 0 then inc(Result)
  end;

  //Подсчитать число единиц
  {function Solo1: integer;
  var
    i, j: integer;
  begin
    Result:= 0;
    for j:= 1 to h do
      for i:= 1 to w do
        if arr2[i,j]=1 then begin
          inc(Result);
          x:= i; y:= j;
        end
  end;}

  //Найти единицу без соседей
  {function Exc1: Boolean;
  var
    i, j: integer;
    i1: integer;
    //flg: Boolean;
  begin
    //найдена:
    Result:= True;
    for j:= 1 to h do
      for i:= 1 to w do
        if arr2[i,j]=1 then begin  //- нашли единицу

          //есть ли у неё соседи?
          for i1:= Max(j-1,1) to Min(j+1,h) do //- по вертикали
            if (i1<> j) and (arr2[i,i1] <> 0) then begin //- есть
              Result:= False; break; end;
          for i1:= Max(i-1,1) to Min(i+1,w) do //- по горизонтали
            if (i1<> i) and (arr2[i1,j] <> 0) then begin //- есть
              Result:= False; break; end;
          //соседей нет:
          if Result= True then begin
            x:= i; y:= j; exit; end;
        end;
  end;}

  //Подсчитать число соседей у единицы
  function Sosedi: integer;
  var
    i, j: integer;
    i1: integer;
  begin
    //искать по всему полю:
    for j:= 1 to h do
      for i:= 1 to w do
        if arr2[i,j]=1 then begin  //- нашли единицу
          Result:= 0;
          //сколько соседей?
          for i1:= Max(j-1,1) to Min(j+1,h) do //- по вертикали
            if (i1<> j) and (arr2[i,i1] <> 0) then begin //- есть
              inc(Result); end;
          for i1:= Max(i-1,1) to Min(i+1,w) do //- по горизонтали
            if (i1<> i) and (arr2[i1,j] <> 0) then begin //- есть
              inc(Result); end;
          if Result< 4 then begin
            x:= i; y:= j;
            //дальше не искать:
            exit;
          end;
        end;
    //не найдены:
    Result:= -1;
  end;

  //Найти единицу с 4-мя соседями (с двойкой)
  function Sosedi2: integer;
  var
    i, j: integer;
    i1: integer;
    flg: Boolean;
  begin
    //искать по всему полю:
    for j:= 1 to h do
      for i:= 1 to w do
        if arr2[i,j]=1 then begin  //- нашли единицу
          Result:= 0;
          flg:= False;
          //сколько соседей?
          for i1:= Max(j-1,1) to Min(j+1,h) do //- по вертикали
            if (i1<> j) and (arr2[i,i1] <> 0) then begin //- есть
              inc(Result);
              if arr2[i,i1] =2 then flg:= True; end;
          for i1:= Max(i-1,1) to Min(i+1,w) do //- по горизонтали
            if (i1<> i) and (arr2[i1,j] <> 0) then begin //- есть
              inc(Result);
              if arr2[i1,j]= 2 then flg:= True; end;

          if flg and (Result=4) then begin  //- нашли
            x:= i; y:= j;
            //дальше не искать:
            exit; end;
        end;
    //не найдены:
    Result:= -1;
  end;

  //записать ходы в протокол:
  procedure SavePos;
  var
    n: integer;
    x, y: integer;
    s: string;
  begin
    frmProtokol.listbox1.items.Clear;
    //frmProtokol.listbox1.items.add('');
    for n:= Hod  downto 1 do begin
      s:='';
      x:= Move[n].x; y:= Move[n].y;
      frmProtokol.ListBox1.items.add(format('%3d',[Hod-n+1]) + '. ' +
                         letter[x]+ ' ' +inttostr(y));
    end;
    frmProtokol.listbox1.items.add('');
  end;

begin
  //очистить протокол:
  frmProtokol.listbox1.Clear;

  //скопировать массивы полей:
  arr2:= masPole2;
  arr1:= masPole;
  //размеры полей:
  w:= dgPole.ColCount-1; h:= dgPole.RowCount-1;

  //подсчитать число ходов:
  step:= steps;
  if step= 0 then begin
    application.MessageBox ('Вы не загрузили задачу!',NAME_PROG, MB_OK);
    exit
  end;

  Hod:= 0;

  repeat
    //ходим в клетки с 1, имеющие не более 3 соседей:
    while Sosedi<> -1 do
    begin
      //делаем ход в эту клетку:
      inc(Hod);
      Move[Hod].x:= x;
      Move[Hod].y:= y;
      arr2:= BackMove(arr2, x, y);
      masPole:= arr2; dgPole.Invalidate;
      //делаем задержку, чтобы увидеть процесс решения задачи:
      sleep(100);
      application.ProcessMessages;
      if hod = step then begin
         savepos;
         frmProtokol.Hide;
         application.MessageBox ('Задача решена!',NAME_PROG, MB_OK);
         frmProtokol.Show;
         exit
      end
    end;

    flgHod:= False;
    if Sosedi2<> -1 then begin
      //делаем ход в эту клетку:
      flgHod:= True;
      inc(Hod);
      Move[Hod].x:= x;
      Move[Hod].y:= y;
      arr2:= BackMove(arr2, x, y);
      masPole:= arr2; dgPole.Invalidate;
      sleep(100);
      application.ProcessMessages;
      if hod = step then begin
         savepos;
         application.MessageBox ('Задача решена!',NAME_PROG, MB_OK);
         exit
      end;
    end;
  until flgHod= False;
  //не удалось решить задачу:
  application.MessageBox ('Задача решений не имеет!',NAME_PROG, MB_OK);
  exit;
end;  //Solution

{procedure TForm1.ImageDraw (img: TImage; index: integer);
var
  bmp: TBitmap;
begin
  //заменить картинку:
  bmp:= TBitmap.Create;
  bmp.Width:= 36; bmp.Height:= 36;
  bmp.TransparentColor:= clWhite;
  imlBut.Draw(bmp.Canvas, 0, 0, index);
  img.Picture.Assign(bmp);
  bmp.free;
end;}

end.
