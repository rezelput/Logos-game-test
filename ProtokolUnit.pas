unit ProtokolUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TfrmProtokol = class(TForm)
    ListBox1: TListBox;
    sbtSaveOtv: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SaveDialog1: TSaveDialog;
    sbtInv: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure sbtSaveOtvClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure sbtInvClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmProtokol: TfrmProtokol;

implementation

uses LogosUnit;

{$R *.DFM}

//ОЧИСТИТЬ ПРОТОКОЛ
procedure TfrmProtokol.SpeedButton1Click(Sender: TObject);
begin
  ListBox1.Items.Clear;
end; //SpeedButton1Click

//ЗАПИСАТЬ ОТВЕТ
procedure TfrmProtokol.sbtSaveOtvClick(Sender: TObject);
var
  s,ss,fn: string;
  i: integer;
  f: textfile;
begin
  savedialog1.DefaultExt:='txt';
  savedialog1.Filter:='Решения (*.txt)|*.TXT';
  savedialog1.FilterIndex:=1;
  s:=extractfilepath(application.exename)+'Figures\';
  savedialog1.InitialDir:= s;
  savedialog1.Title:='Запишите решение на диск';

  //сформировать имя файла:
  if NameFig<>'' then begin
    s:=extractFileName(NameFig);
    ss:='';
    i:=1;
    while (s[i]<>'.') and (i<=length(s)) do begin
      ss:=ss+s[i];
      inc(i)
    end;
    ss:=ss+'otv.txt';
    savedialog1.filename:=ss
   end
   else
     savedialog1.filename:='otv_temp.txt';

   if not savedialog1.Execute then exit;
   //имя конечного файла:
   fn:= savedialog1.filename;
   assignfile(f,fn);
   rewrite(f);
   //записать протокол:
   for i:=0 to (ListBox1.Items.Count - 1) do
     writeln (f,ListBox1.Items.Strings[i]);
   Closefile(f);
   Messagebeep(0)
end; //sbtSaveOtvClick

procedure TfrmProtokol.ListBox1Click(Sender: TObject);
var
  s,h: string;
  n: integer;
  x, y: integer;
begin
  //прокрутить список так, чтобы сверху была выделенная строка:
  ListBox1.TopIndex:= ListBox1.ItemIndex;
  //выделенная строка из списка:
  s:= ListBox1.Items.Strings[ListBox1.ItemIndex];
  //найти точку:
  n:= pos('.',s);

  if n=0 then exit; //- это не запись хода!
  
  //выделить номер хода:
  h:= copy(s,1,n-1);
  Hod:= strtoint(h);
  //вывести его на экран:
  LogosUnit.Form1.lblHod.Caption:= 'Ход - ' + inttostr(Hod);
  //выделить координаты клетки:
  x:= pos(s[n+2],letter);
  s:= copy(s,n+4,2);
  y:= strtoint (s);
  //выполнить ход:
  masPole:= LogosUnit.Form1.DoMove(masPole, x, y);
  Form1.dgPole.invalidate;
  //проверить, не решена ли задача:
  if LogosUnit.Form1.IsReady then LogosUnit.Form1.Ready;
end; //ListBox1Click

//ОБРАТИТЬ СПИСОК ХОДОВ
procedure TfrmProtokol.sbtInvClick(Sender: TObject);
var
  s: array [0..169] of string;
  str: string;
  i,j: integer;
  n,m: integer;
begin
  n:= ListBox1.Items.Count-1;

  j:=-1;
  for i:= 0 to n do 
    if ListBox1.Items.Strings[i] <> '' then begin
      inc(j);
      s[j]:= ListBox1.Items.Strings[i];
  end;
  ListBox1.Clear;

  for i:= j downto 0 do begin
    m:= pos('.',s[i]);
    str:= copy(s[i], m+2, length(s[i])-m);
    str:= format('%3d',[j-i+1]) + '. ' + str;
    ListBox1.Items.Add(str);
  end;
  ListBox1.Items.Add('');
end; //sbtInvClick

end.
  