program md5_test;

{$APPTYPE CONSOLE}

uses
  md5_hash;

function BufferToHexadecimal(const Data; Size: Integer): AnsiString;
const
  HexChars: AnsiString = '0123456789abcdef';
var
  i: Integer;
  D: PAnsiChar;
  R: AnsiString;
begin
  D := @Data;
  SetLength(R, Size * 2);
  for i := 0 to Size - 1 do
  begin
    R[1 + i * 2] := HexChars[(Byte(D[i]) shr 4) + 1];
    R[2 + i * 2] := HexChars[(Byte(D[i]) and 15) + 1];
  end;
  BufferToHexadecimal := R;
end;

function MD5DigestToHexadecimal(const D: TMD5Digest): AnsiString;
begin
  MD5DigestToHexadecimal := BufferToHexadecimal(D, SizeOf(D));
end;


function MD5OfStr(const S: AnsiString): AnsiString;
var
  c: TMD5Ctx;
  D: TMD5Digest;
begin
  MD5Init(c);
  MD5Update(c, PAnsiChar(S)^, length(S));
  MD5Final(D, c);
  MD5OfStr := MD5DigestToHexadecimal(D);
end;

function TestMD5: Boolean;
begin
  { Test suite from rfc1321 }
  TestMD5 :=
    (MD5OfStr('') = 'd41d8cd98f00b204e9800998ecf8427e') and
    (MD5OfStr('a') = '0cc175b9c0f1b6a831c399e269772661') and
    (MD5OfStr('abc') = '900150983cd24fb0d6963f7d28e17f72') and
    (MD5OfStr('message digest') = 'f96b697d7cb7938d525a2f31aaf161d0') and
    (MD5OfStr('abcdefghijklmnopqrstuvwxyz') = 'c3fcd3d76192e4007dfb496cca67e13b') and
    (MD5OfStr('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789') = 'd174ab98d277d9f5a5611c2c9f419d9f') and
    (MD5OfStr('12345678901234567890123456789012345678901234567890123456789012345678901234567890') = '57edf4a22be3c955ac49da2e2107b67a');
end;


begin
  if TestMD5 then
  begin
    WriteLn('MD5 test passed');
    {ExitCode = 0;}
  end else
  begin
    WriteLn('MD5 test failed');
    {ExitCode = 1;}
  end;
end.
