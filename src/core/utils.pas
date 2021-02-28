unit Utils;

{$mode objfpc}{$H+}

interface

{ Somente Units nativas do lazarus }
uses
  Classes, SysUtils, variants, strutils, Forms, Windows, Controls, IniFiles, StdCtrls
  //  {$IFDEF RAUDUS}
  , RaBase, RaControlsVCL, //lDapSend
  //RxTinyMCE
  //  {$ENDIF}
  Grids;

{ Aqui entra somente a declaração de Tipos e Records }
type
  TpDirecao = (tdDireita, tdEsquerda);

  TrUsuario = record
    user_admin: string[15];
    user_local: string[15];
    user_modulo: string[15];
  end;

{ Aqui entra somente a declaração de algumas constantes }
const
  ESPACO = #32;
  COM_MASCARA = '¨.¨,¨;¨-¨_¨/¨|¨\¨(¨)¨';
  SEM_MASCARA = ESPACO;

{ Aqui entra somente a declaração das funções }

function Iif(bValue: boolean; vTrue: variant; vFalse: variant): variant;
function Empty(AValue: variant): boolean;
function Mes: string;
function Semana: string;
function DiaMesAno(const cidade: string): string;
function StrZero(const AString: string; const ALength: integer;
  direcao: TPDirecao = tdEsquerda): string;
//function Autoincremento(const AColuna, ATabela: string): string;
function Space(n: integer): string;
function PadL(sVar: string; nTam: word; sAdic: string = '0';
  bTrataSinal: boolean = False): string;
function PadR(sVar: string; nTam: word; sAdic: string = ''): string;
function PadC(sVar: string; nTam: word; sAdic: string): string;
function StrToFloatZero(str: string): double;
function FloatZero(float: double): double;
function StrToIntZero(str: string): integer;

function TirarPonto(Texto: string): string;
{ Aqui entra somente a declaração das procedures }

//procedure viewform(AFormName, AFormPrincip: TFormClass; AOpcao: integer);
procedure GravaIni(Numero: longint; Texto: string; Condicao: boolean);
procedure LeIni(var Numero: longint; var Texto: string; var Condicao: boolean);
procedure SortGrid(Grid: TStringGrid; Col: integer);
procedure Debug(Str: string);
procedure ListarArquivos(Path: string; Lista: TStrings);
function EncryptSTR(const InString: string; StartKey, MultKey, AddKey: integer): string;
function DecryptSTR(const InString: string; StartKey, MultKey, AddKey: integer): string;
function SoNumeros(const Texto: string): string;
function FormataDoc(fDoc: string; ATipo: integer): string;
function FormataData(aData: string): string;
function ValiData(Data: string): boolean;
function ValMoeda(Moeda: string): boolean;
function ValNumero(Numero: string): boolean;
function ValInteger(Numero: string): boolean;
function ValidaCPF(xCPF: string): boolean;
function ValidaCGC(xCGC: string): boolean;
function AlinharStr(Pe_Str: string; Pe_QtdPos: byte; EDC: char): string;
function FormataCEP(const CEP: string): string;
procedure LimparCampos(AComponent: TComponent);
procedure LoadSecurity(Path, Rotina: PChar; Tag: integer);
function ProximoDiaUtil(dData: TDateTime): TDateTime;
function IsAuthenticated(ADomain, AUserName, APassword: string): boolean;

implementation

{ Somente Units do projeto }
uses
  untprincipal;

function IsAuthenticated(ADomain, AUserName, APassword: string): boolean;
//var
//  fldap: tldapsend;
begin
  //Result := False;
  //ausername := AUserName;
  //apassword := APassword;
  //fldap := TLDAPSend.Create;
  //fldap.TargetHost := ADomain;
  //fldap.UserName := AUserName + '@' + ADomain;
  //fldap.Password := APassword;
  //try
  //  if fldap.Login then
  //    if fldap.Bind then
  //    begin
  //      //user is succesfully authenticated at this point
  //      writeln('user is succesfully authenticated at this point');
  //      Result := True;
  //    end
  //    else writeln('LDAP bind failed.');
  //finally
  //  fldap.logout;
  //  FreeAndNil(fldap);
  //end;
end;

function ProximoDiaUtil(dData: TDateTime): TDateTime;
  {: Retorna o próximo dia útil caso a data informada caia em um fim de semana}
begin
  if DayOfWeek(dData) = 7 then
  begin
    dData := dData + 2;
  end
  else if DayOfWeek(dData) = 1 then
  begin
    dData := dData + 1;
  end;
  Result := dData;
end;

procedure LoadSecurity(Path, Rotina: PChar; Tag: integer);
var
  FHandle: THandle;
  FRoutine: procedure(Path: TFileName; Tag: integer);
begin
  FHandle := LoadLibrary(Path);
  try
    //    FRoutine := GetProcAddress(FHandle, Rotina);
    if (Assigned(FRoutine)) then
    begin
      try
        FRoutine(ExtractFilePath(Path), Tag);
      except
        on E: Exception do
          FreeLibrary(FHandle);
      end;
    end
    else
      raise Exception.Create('Dll não encontrada.');

  finally
    FreeLibrary(FHandle);
  end;
end;

function FormataCEP(const CEP: string): string;
var
  I: integer;
begin
  Result := '';
  for I := 1 to Length(CEP) do
    if CEP[I] in ['0'..'9'] then
      Result := Result + CEP[I];
  if Length(Result) = 8 then
    // <> 8   raise Exception.Create('CEP inválido.')
    //  else
    Result :=
      Copy(Result, 1, 2) + '.' + Copy(Result, 3, 3) + '-' + Copy(Result, 6, 3);
end;

procedure LimparCampos(AComponent: TComponent);
var
  x: integer;
begin
  for x := 0 to (AComponent.ComponentCount) - 1 do
  begin
    // Verificação da propriedade pTag
    if (TComponent(AComponent.Components[x]).Tag <> 100) then
    begin
      if (AComponent.Components[x] is TRaEdit) then
        (AComponent.Components[x] as TRaEdit).Text := '';

//      if (AComponent.Components[x] is TRxTinyMCE) then
//        (AComponent.Components[x] as TRxTinyMCE).Content := '';

    end;
  end;
end;

function FormataData(aData: string): string;
var
  vTam, xx: integer;
  vDoc: string;
begin
  vTam := Length(SoNumeros(aData));
  vDoc := '';
  for xx := 1 to vTam do
  begin
    vDoc := vDoc + Copy(aData, xx, 1);
    if vTam = 9 then
    begin
      if (xx in [2, 4]) then
        vDoc := vDoc + '/';
    end;
  end;
  Result := Copy(vDoc, 0, 10);
end;

function ValiData(Data: string): boolean;
  {Testa se uma data é válida ou não}
var
  TesteData: TDateTime;
begin
  Result := True;
  try
    TesteData := StrToDate(Data);
  except
    Result := False;
  end;
end;


function ValMoeda(Moeda: string): boolean;
var
  TesteMoeda: currency;
begin
  Result := True;
  try
    TesteMoeda := StrToCurr(TirarPonto(Moeda));
  except
    Result := False;
  end;
end;


function ValNumero(Numero: string): boolean;
var
  TesteNumero: double;
begin
  Result := True;
  try
    TesteNumero := StrToFloatZero(Numero);
  except
    Result := False;
  end;
end;

function ValInteger(Numero: string): boolean;
var
  TesteNumero: integer;
begin
  Result := True;
  try
    TesteNumero := StrToInt(Numero);
  except
    Result := False;
  end;
end;


function ValidaCpf(xCPF: string): boolean;
  {Testa se o CPF é válido ou não}
var
  d1, d4, xx, nCount, resto, digito1, digito2: integer;
  Check: string;
begin
  try
    d1 := 0;
    d4 := 0;
    xx := 1;
    for nCount := 1 to Length(xCPF) - 2 do
    begin
      if Pos(Copy(xCPF, nCount, 1), '/-.') = 0 then
      begin
        d1 := d1 + (11 - xx) * StrToInt(Copy(xCPF, nCount, 1));
        d4 := d4 + (12 - xx) * StrToInt(Copy(xCPF, nCount, 1));
        xx := xx + 1;
      end;
    end;
    resto := (d1 mod 11);
    if resto < 2 then
    begin
      digito1 := 0;
    end
    else
    begin
      digito1 := 11 - resto;
    end;
    d4 := d4 + 2 * digito1;
    resto := (d4 mod 11);
    if resto < 2 then
    begin
      digito2 := 0;
    end
    else
    begin
      digito2 := 11 - resto;
    end;
    Check := IntToStr(Digito1) + IntToStr(Digito2);
    if Check <> copy(xCPF, succ(length(xCPF) - 2), 2) then
    begin
      Result := False;
    end
    else
    begin
      Result := True;
    end;
  except
    Result := False;
  end;
end;

function ValidaCGC(xCGC: string): boolean;
  {Testa se o CGC é válido ou não}
var
  d1, d4, xx, nCount, fator, resto, digito1, digito2: integer;
  Check: string;
begin
  try
    d1 := 0;
    d4 := 0;
    xx := 1;
    for nCount := 1 to Length(xCGC) - 2 do
    begin
      if Pos(Copy(xCGC, nCount, 1), '/-.') = 0 then
      begin
        if xx < 5 then
        begin
          fator := 6 - xx;
        end
        else
        begin
          fator := 14 - xx;
        end;
        d1 := d1 + StrToInt(Copy(xCGC, nCount, 1)) * fator;
        if xx < 6 then
        begin
          fator := 7 - xx;
        end
        else
        begin
          fator := 15 - xx;
        end;
        d4 := d4 + StrToInt(Copy(xCGC, nCount, 1)) * fator;
        xx := xx + 1;
      end;
    end;
    resto := (d1 mod 11);
    if resto < 2 then
    begin
      digito1 := 0;
    end
    else
    begin
      digito1 := 11 - resto;
    end;
    d4 := d4 + 2 * digito1;
    resto := (d4 mod 11);
    if resto < 2 then
    begin
      digito2 := 0;
    end
    else
    begin
      digito2 := 11 - resto;
    end;
    Check := IntToStr(Digito1) + IntToStr(Digito2);
    if Check <> copy(xCGC, succ(length(xCGC) - 2), 2) then
    begin
      Result := False;
    end
    else
    begin
      Result := True;
    end;
  except
    Result := False;
  end;
end;

function AlinharStr(Pe_Str: string; Pe_QtdPos: byte; EDC: char): string;

  // Alinha uma string em um determinado espaço

  // EDC:  C = Centralizado
  //       D = Direita
  //       E = Esquerda

var
  L, N, R, I: integer;
  S, St, CH: string;
begin
  i := Pe_qtdPos;
  St := copy(Pe_Str, 1, Pe_QtdPos);
  if EDC = 'D' then
  begin
    Insert('aLeX', St, i);
    L := Pos('aLeX', St);
    if L <= i then
    begin
      for n := L to i do
      begin
        Insert(' ', St, 1);
      end;
    end;
    St := Copy(St, 1, i);
    R := i;
    Ch := Copy(St, i, 1);
    while (Ch = ' ') and (R <> 0) do
    begin
      if ch = ' ' then
      begin
        Insert(' ', St, 1);
      end;
      St := Copy(St, 1, i);
      R := R - 1;
      Ch := Copy(St, i, 1);
    end;
  end;
  if EDC = 'E' then
  begin
    Ch := Copy(St, 1, 1);
    while Ch = ' ' do
    begin
      Delete(St, 1, 1);
      Ch := Copy(St, 1, 1);
    end;
    St := Copy(St, 1, i);
  end;
  if EDC = 'C' then
  begin
    S := AlinharStr(Pe_Str, Pe_QtdPos, 'D');
    Ch := Copy(S, 1, 1);
    R := 1;
    N := 1;
    while Ch = ' ' do
    begin
      R := R + 1;
      Ch := Copy(S, R, 1);
    end;
    R := Round(R / 2);
    while n < R do
    begin
      Delete(S, 1, 1);
      N := N + 1;
    end;
    St := Copy(S, 1, i);
  end;
  AlinharStr := St;
end;

function FormataDoc(fDoc: string; ATipo: integer): string;
var
  vTam, xx: integer;
  vDoc: string;
begin
  vDoc := '';
  vTam := Length(fDoc);
  for xx := 1 to vTam do
    if (Copy(fDoc, xx, 1) <> '.') and (Copy(fDoc, xx, 1) <> '-') and
      (Copy(fDoc, xx, 1) <> '/') then
      vDoc := vDoc + Copy(fDoc, xx, 1);
  fDoc := vDoc;
  vTam := Length(fDoc);
  vDoc := '';
  for xx := 1 to vTam do
  begin
    vDoc := vDoc + Copy(fDoc, xx, 1);
    case ATipo of
      0:
      begin
        if vTam = 11 then
        begin
          if (xx in [3, 6]) then
            vDoc := vDoc + '.';
          if xx = 9 then
            vDoc := vDoc + '-';
        end;
      end;
      1:
      begin
        if vTam = 14 then
        begin
          if (xx in [2, 5]) then
            vDoc := vDoc + '.';
          if xx = 8 then
            vDoc := vDoc + '/';
          if xx = 12 then
            vDoc := vDoc + '-';
        end;
      end;
    end;
  end;
  Result := vDoc;
end;

procedure ListarArquivos(Path: string; Lista: TStrings);
var
  SR: TSearchRec;
begin
  if FindFirst(Path + '*.*', faAnyFile, SR) = 0 then
  begin
    repeat
      if (SR.Attr <> faDirectory) then
        Lista.Add(SR.Name);
    until FindNext(SR) <> 0;
    //FindClose(SR);
  end;
end;

// Remove caracteres de uma string deixando apenas numeros
function SoNumeros(const Texto: string): string;
var
  I: integer;
  S: string;
begin
  S := '0';
  for I := 1 to Length(Texto) do
  begin
    if (Texto[I] in ['0'..'9']) then
    begin
      S := S + Copy(Texto, I, 1);
    end;
  end;
  Result := S;
end;

procedure SortGrid(Grid: TStringGrid; Col: integer);
var
  i, j: integer;
  prev: string;
begin
  //in worst-case scenario we'll need RowCount-1 iterations to fully sort the grid
  for j := 0 to Grid.RowCount - 1 do
    for i := 2 to Grid.RowCount - 1 do
    begin
      if StrToInt(Grid.Cells[Col, i]) < StrToInt(Grid.Cells[Col, i - 1]) then
      begin // < if you want to reverse the sort order
        prev := Grid.Rows[i - 1].CommaText;
        Grid.Rows[i - 1].CommaText := Grid.Rows[i].CommaText;
        Grid.Rows[i].CommaText := prev;
      end;
    end;
end;
//Para criptografar passe como paramêtros 3 valores inteiros quaisquer.
//Para referter a criptografia utilize os mesmos valores
function EncryptSTR(const InString: string; StartKey, MultKey, AddKey: integer): string;
var
  I: byte;
begin
  Result := '';
  for I := 1 to Length(InString) do
  begin
    Result := Result + char(byte(InString[I]) xor (StartKey shr 8));
    StartKey := (byte(Result[I]) + StartKey) * MultKey + AddKey;
  end;
end;

function DecryptSTR(const InString: string; StartKey, MultKey, AddKey: integer): string;
var
  I: byte;
begin
  Result := '';
  for I := 1 to Length(InString) do
  begin
    Result := Result + char(byte(InString[I]) xor (StartKey shr 8));
    StartKey := (byte(InString[I]) + StartKey) * MultKey + AddKey;
  end;
end;

{ Implementação das functions }
procedure Debug(Str: string);
var
  {$IFDEF RAUDUS}
  FormDebug: TRaFormCompatible;
  mnDebug: TRaLabel;
  {$ELSE}
  FormDebug: TForm;
  mnDebug: TLabel;
  {$ENDIF}
begin

  if Assigned(FormDebug) then
  {$IFDEF RAUDUS}
    Application.CreateForm(TRaFormCompatible, FormDebug);
  {$ELSE}
  Application.CreateForm(TForm, FormDebug);
  {$ENDIF}
  if Assigned(FormDebug) then
  begin
    {$IFDEF RAUDUS}
    mnDebug := TRaLabel.Create(FormDebug);
    {$ELSE}
    mnDebug := TLabel.Create(FormDebug);
    {$ENDIF}

    mnDebug.Parent := FormDebug;
    mnDebug.Caption := Str;
  end;



  FormDebug.Show;
  FormDebug.FormStyle := fsStayOnTop;
  FormDebug.BringToFront;
end;

function Iif(bValue: boolean; vTrue: variant; vFalse: variant): variant;
begin
  if (bValue) then
    Result := vTrue
  else
    Result := vFalse;
end;

{******************************************************************************}

function Empty(AValue: variant): boolean;
begin
  case VarType(AValue) of
    varInteger: Result := (AValue = 0);
    varSmallInt: Result := (AValue = 0);
    varSingle: Result := (AValue = 0);
    varDouble: Result := (AValue = 0);
    varCurrency: Result := (AValue = 0);
    varByte: Result := (AValue = 0);
    varString: Result := (Trim(AValue) = '');
    varDate: Result := (DateToStr(AValue) = '  /  /    ');
    else
      Result := False;
  end;
end;

{******************************************************************************}

function Semana: string;
begin
  case DayOfWeek(Date) of
    1: Result := 'Domingo';
    2: Result := 'Segunda-feira';
    3: Result := 'Terça-feira';
    4: Result := 'Quarta-feira';
    5: Result := 'Quinta-feira';
    6: Result := 'Sexta-feira';
    7: Result := 'Sábado';
  end;
end;

{******************************************************************************}

function Mes: string;
var
  sMes: string;
begin
  sMes := FormatDateTime('mm', Date);

  if sMes = '01' then
    Result := 'Janeiro'
  else
  if sMes = '02' then
    Result := 'Fevereiro'
  else
  if sMes = '03' then
    Result := 'Março'
  else
  if sMes = '04' then
    Result := 'Abril'
  else
  if sMes = '05' then
    Result := 'Maio'
  else
  if sMes = '06' then
    Result := 'Junho'
  else
  if sMes = '07' then
    Result := 'Julho'
  else
  if sMes = '08' then
    Result := 'Agosto'
  else
  if sMes = '09' then
    Result := 'Setembro'
  else
  if sMes = '10' then
    Result := 'Outubro'
  else
  if sMes = '11' then
    Result := 'Novembro'
  else
  if sMes = '12' then
    Result := 'Dezembro';
end;

{******************************************************************************}

function diaMesAno(const cidade: string): string;
begin
  Result := cidade + ', ' + FormatDateTime('dd', Date) + ' de ' +
    Mes + FormatDateTime('yyyy', Date);
end;

{******************************************************************************}

function StrZero(const AString: string; const ALength: integer;
  direcao: TpDirecao = tdEsquerda): string;

var
  i: integer;
  R: string;
begin
  R := '';
  for i := 1 to (ALength - Length(AString)) do
    R := R + '0';

  if direcao = tdEsquerda then
    Result := R + AString
  else
    Result := AString + R;
end;

{******************************************************************************}

//function Autoincremento(const AColuna, ATabela: string): string; overload;
//begin
//  with FPrincipal do
//  begin
//    qexe.Close;
//    qexe.SQL.Text := 'SELECT COALESCE( MAX(' + AColuna + '), 0 ) AS REG FROM ' + ATabela;
//    qexe.Open;
//    Result := StrZero(IntToStr(qexe.FieldByName('reg').AsInteger + 1), 10, tdEsquerda);
//  end;
//end;

{******************************************************************************}

function Space(n: integer): string;
var
  i: integer;
begin
  for i := 1 to n do
    Result := Result + ESPACO;
end;

function PadL(sVar: string; nTam: word; sAdic: string; bTrataSinal: boolean): string;
var
  StrSimb, StrValorTemp: string;
begin
  if bTrataSinal then
  begin
    StrSimb := Copy(sVar, 1, 1);
    StrValorTemp := sVar;
    if (StrSimb = '-') or (StrSimb = '+') then
      StrValorTemp := Copy(sVar, 2, Length(sVar))
    else
      StrSimb := '';

    StrValorTemp := PadL(StrValorTemp, nTam, sAdic);
    Result := StrSimb + StrValorTemp;
  end
  else
  begin
    if sAdic = '' then
      sAdic := ' ';

    while Length(sVar) < nTam do
      Insert(sAdic, sVar, 1);

    Result := Copy(sVar, 1, nTam);
  end;
end;

function PadR(sVar: string; nTam: word; sAdic: string): string;
begin
  if sAdic = '' then
    sAdic := ' ';

  while Length(sVar) < nTam do
    sVar := sVar + sAdic;

  Result := Copy(sVar, 1, nTam);
end;

function PadC(sVar: string; nTam: word; sAdic: string): string;
var
  nDiv: word;

begin
  if sAdic = '' then
    sAdic := ' ';

  try
    nDiv := StrToInt(FloatToStr(Int((nTam - Length(sVar)) / 2)));
    if nDiv > 0 then
      sVar := PadL(sAdic, nDiv, sAdic) + sVar + PadL(sAdic, nDiv, sAdic);
  finally
    Result := Copy(sVar + sAdic, 1, nTam);
  end;
end;

function StrToFloatZero(str: string): double;
begin
  if Trim(str) = '' then
    Result := 0
  else
    Result := StrToFloat(TirarPonto(Str));
end;

function FloatZero(float: double): double;
begin
end;

function StrToIntZero(str: string): integer;
begin
  if Trim(str) = '' then
    Result := 0
  else
    Result := StrToInt(str);
end;

function TirarPonto(Texto: string): string;
var
  x: integer;
  Total: string;
begin
  Total := '';
  Texto := Trim(Texto);
  for x := 1 to length(trim(Texto)) do
  begin
    if Copy(texto, x, 1) <> '.' then
    begin
      total := total + copy(texto, x, 1);
    end;
  end;
  Result := total;

end;

(*
procedure viewForm(AFormName, AFormPrincip: TFormClass; AOpcao: integer);
begin
  try
    TForm(AFormName) := AFormName.Create(nil);

    case AOpcao of
      0:
      begin
        TForm(AFormName).FormStyle := fsNormal;
        TForm(AFormName).DockSite := True;
        TForm(AFormName).Align := alClient;

        TForm(AFormName).Constraints.MaxHeight := TForm(AFormName).Height + 10;
        TForm(AFormName).Constraints.MaxWidth := TForm(AFormName).Width + 10;
        TForm(AFormName).Constraints.MinHeight := TForm(AFormName).Height + 10;
        TForm(AFormName).Constraints.MinWidth := TForm(AFormName).Width + 10;

        //  frmRevista.Show;

      end;
      1:
      begin
      end;
    end;
    TForm(AFormName).ShowModal;
    TForm(AFormName).Dock(AFormPrincip, Rect(0, 0, 0, 0));
  finally
//    TForm(AFormName).Free;
//    AFormName := nil;
  end;
end;
*)

procedure GravaIni(Numero: longint; Texto: string; Condicao: boolean);
var
  ArqIni: TIniFile;
begin
  ArqIni := TIniFile.Create('c:windows	empTeste.Ini');
  try
    ArqIni.WriteInteger('Dados', 'Numero', Numero);
    ArqIni.WriteString('Dados', 'Texto', Texto);
    ArqIni.WriteBool('Dados', 'Condição', Condicao);
  finally
    ArqIni.Free;
  end;
end;

procedure LeIni(var Numero: longint; var Texto: string; var Condicao: boolean);

var
  ArqIni: tIniFile;
begin
  ArqIni := tIniFile.Create('F:\readers\SisED\SisED.cf');
  try
    //    Numero := ArqIni.ReadInteger('Dados', 'Numero', Numero);
    Texto := ArqIni.ReadString('OPFBroker', 'DefaultServiceName', Texto);
    //    Condicao := ArqIni.ReadBool('Dados', 'Condição', Condicao);
  finally
    ArqIni.Free;
  end;
end;

end.
