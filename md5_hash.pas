unit md5_hash;

interface

type
  PByte16 = ^TByte16;
  TMD5Byte64  = packed array [0 .. 63] of Byte;
  TByte16     = packed array [0 .. 15] of Byte;
  TMD5Int16   = packed array [0 .. 15] of Cardinal;
  TMD5Int4    = packed array [0 .. 3] of Cardinal;
  TMD5Int2    = packed array [0 .. 1] of Cardinal;
  T_Digest    = TByte16;
  T_IdeaKey   = T_Digest;
  TMD5Digest  = TByte16;
  PMD5Digest  = ^TMD5Digest;
  PMD5Ctx = ^TMD5Ctx;

  TMD5Ctx = packed record
    State: TMD5Int4;
    Count: TMD5Int2;
    Buffer: TMD5Byte64;
    BLen: Integer;
    safe: Integer;
  end;

procedure MD5Init(var Context: TMD5Ctx);
procedure MD5Update(var Context: TMD5Ctx; const ChkBuf; len: Cardinal);
procedure MD5Final(var Digest: TMD5Digest; var Context: TMD5Ctx);


implementation

procedure MD5_Transform(var State: TMD5Int4; Buffer: Pointer); register; external;
{$IFDEF WIN64}
 {$IFDEF NASM}
  {$LINK md5_64_nasm.obj}
 {$ELSE}
  {$LINK md5_64.obj}
 {$ENDIF}
{$ELSE}
 {$IFDEF LINUX}
  {$LINK md5_64_nasm.o}
 {$ELSE}
  {$LINK md5_32.obj}
 {$ENDIF}
{$ENDIF}

procedure MD5Init(var Context: TMD5Ctx);
begin
  Context.BLen := 0;
  Context.Count[0] := 0;
  Context.Count[1] := 0;
  Cardinal(Context.State[0]) := $67452301;
  Cardinal(Context.State[1]) := $EFCDAB89;
  Cardinal(Context.State[2]) := $98BADCFE;
  Cardinal(Context.State[3]) := $10325476;
end;

procedure MD5Update(var Context: TMD5Ctx; const ChkBuf; len: Cardinal);
var
  BufPtr: ^Byte;
  Left: Cardinal;
begin
  if Context.Count[0] + Cardinal(len) shl 3 < Context.Count[0] then
  begin
    Inc(Context.Count[1]);
  end;

  Inc(Context.Count[0], Cardinal(len) shl 3);
  Inc(Context.Count[1], Cardinal(len) shr 29);

  BufPtr := @ChkBuf;
  if Context.BLen > 0 then
  begin
    Left := 64 - Context.BLen;
    if Left > len then
      Left := len;
    Move(BufPtr^, Context.Buffer[Context.BLen], Left);
    Inc(Context.BLen, Left);
    Inc(BufPtr, Left);
    if Context.BLen < 64 then
      Exit;
    MD5_Transform(Context.State, @Context.Buffer);
    Context.BLen := 0;
    Dec(len, Left);
  end;
  while len >= 64 do
  begin
    MD5_Transform(Context.State, BufPtr);
    Inc(BufPtr, 64);
    Dec(len, 64);
  end;
  if len > 0 then
  begin
    Context.BLen := len;
    Move(BufPtr^, Context.Buffer[0], Context.BLen);
  end;
end;

procedure MD5Final(var Digest: TMD5Digest; var Context: TMD5Ctx);
var
  WorkBuf: TMD5Byte64;
  WorkLen: Cardinal;
begin
  Digest := TMD5Digest(Context.State);
  Move(Context.Buffer, WorkBuf, Context.BLen); 
  WorkBuf[Context.BLen] := $80;
  WorkLen := Context.BLen + 1;
  if WorkLen > 56 then
  begin
    if WorkLen < 64 then
      FillChar(WorkBuf[WorkLen], 64 - WorkLen, 0);
    MD5_Transform(TMD5Int4(Digest), @WorkBuf);
    WorkLen := 0;
  end;
  FillChar(WorkBuf[WorkLen], 56 - WorkLen, 0);
  TMD5Int16(WorkBuf)[14] := Context.Count[0];
  TMD5Int16(WorkBuf)[15] := Context.Count[1];
  MD5_Transform(TMD5Int4(Digest), @WorkBuf);
end;


end.
