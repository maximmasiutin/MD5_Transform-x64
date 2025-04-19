
# This is a 64-bit version of MD5_Transform
# developed by Maxim Masiutin based on MD5_386.Asm (see below)
# This implementation follows Microsoft's x64 
# Application Binary Interface (ABI), also known as the "x64 ABI" 
# calling convention, used for Win64. The registers RCX and RDX are 
# used to pass parameters, as per the x64 ABI.
#
# This is a version for the GNU Assembler (GAS) with Intel syntax.
# It uses Intel Advanced Performance Extensions (Intel APX).
# In particular, it uses additional general-purpose registers (GPRs),
# also known as Extended GPRs (EGPRs).
# It doesn't use other APX features, such as three-operand instruction formats.
#
# This code is intended to be used with the GNU assembler (GAS).
# To compile, call: 
# as -msyntax=intel -mnaked-reg --64 -o md5_64_gas_apx.obj md5_64_gas_apx.asm 
#
# This implementation is based on:
#
# MD5_386.Asm   -  386 optimized helper routine for calculating
#                  MD Message-Digest values
# written 2/2/94 by
#
# Peter Sawatzki
# Buchenhof 3
# D58091 Hagen, Germany Fed Rep
#
# EMail: Peter@Sawatzki.de
# EMail: 100031.3002@compuserve.com
# WWW:   http://www.sawatzki.de
#
#
# original C Source was found in Dr. Dobbs Journal Sep 91
# MD5 algorithm from RSA Data Security, Inc.



# FF Macro: a := ROL(a + x + y + (b AND c OR NOT b AND d), s) + b
.macro FF a, b, c, d, x, s, y
  add \a, \x
  add \a, \y
  mov esi, \b
  not esi
  and esi, \d
  mov edi, \c
  and edi, \b
  or esi, edi
  add \a, esi
  rol \a, \s
  add \a, \b
.endm

# GG Macro: a := ROL(a + x + y + (b AND d OR c AND NOT d), s) + b
.macro GG a, b, c, d, x, s, y
  add \a, \x
  add \a, \y
  mov esi, \d
  not esi
  and esi, \c
  mov edi, \d
  and edi, \b
  or esi, edi
  add \a, esi
  rol \a, \s
  add \a, \b
.endm

# HH Macro: a := ROL(a + x + y + (b XOR c XOR d), s) + b
.macro HH a, b, c, d, x, s, y
  add \a, \x
  add \a, \y
  mov esi, \d
  xor esi, \c
  xor esi, \b
  add \a, esi
  rol \a, \s
  add \a, \b
.endm

# II Macro: a := ROL(a + x + y + (c XOR (b OR NOT d)), s) + b
.macro II a, b, c, d, x, s, y
  add \a, \x
  add \a, \y
  mov esi, \d
  not esi
  or esi, \b
  xor esi, \c
  add \a, esi
  rol \a, \s
  add \a, \b
.endm

.global MD5_Transform
MD5_Transform:
# save registers that the caller requires to be preserved according to the x64 ABI
  Push RBX
  Push RSI
  Push RDI
  Push RBP
  Push R12
  Push R13
  Push R14
  Push R15
  Push R16
  Push R17
  Push R18
  Push R19
  Push R20
  Push R21
  Push R22
   
# First parameter is passed in RCX, Second - in RDX

# State   - in RCX
# Message - in RDX

  Mov RSI, RCX # State is now in RSI
  Mov RDI, RDX # Message is now in RDI

  Mov EAX, [RSI]
  Mov EBX, [RSI+4]
  Mov ECX, [RSI+8]
  Mov EDX, [RSI+12]
 
  Mov EBP,  [RDI+0]       # 0
  Mov R8d,  [RDI+4]       # 1
  Mov R9d,  [RDI+8]       # 2  
  Mov R10d, [RDI+12]      # 3
  Mov R11d, [RDI+16]      # 4
  Mov R12d, [RDI+20]      # 5
  Mov R13d, [RDI+24]      # 6
  Mov R14d, [RDI+28]      # 7
  Mov R15d, [RDI+32]      # 8
  Mov R16d, [RDI+36]      # 9
  Mov R17d, [RDI+40]      # 10
  Mov R18d, [RDI+44]      # 11
  Mov R19d, [RDI+48]      # 12
  Mov R20d, [RDI+52]      # 13
  Mov R21d, [RDI+56]      # 14
  Mov R22d, [RDI+60]      # 15
  
  FF EAx,EBx,ECx,EDx, EBP,   7, 0xd76aa478  
  FF EDx,EAx,EBx,ECx, R8d,  12, 0xe8c7b756  
  FF ECx,EDx,EAx,EBx, R9d,  17, 0x242070db  
  FF EBx,ECx,EDx,EAx, R10d, 22, 0xc1bdceee  
  FF EAx,EBx,ECx,EDx, R11d,  7, 0xf57c0faf  
  FF EDx,EAx,EBx,ECx, R12d, 12, 0x4787c62a  
  FF ECx,EDx,EAx,EBx, R13d, 17, 0xa8304613  
  FF EBx,ECx,EDx,EAx, R14d, 22, 0xfd469501  
  FF EAx,EBx,ECx,EDx, R15d,  7, 0x698098d8  
  FF EDx,EAx,EBx,ECx, R16d, 12, 0x8b44f7af  
  FF ECx,EDx,EAx,EBx, R17d, 17, 0xffff5bb1  
  FF EBx,ECx,EDx,EAx, r18d, 22, 0x895cd7be  
  FF EAx,EBx,ECx,EDx, r19d,  7, 0x6b901122  
  FF EDx,EAx,EBx,ECx, r20d, 12, 0xfd987193  
  FF ECx,EDx,EAx,EBx, r21d, 17, 0xa679438e  
  FF EBx,ECx,EDx,EAx, r22d, 22, 0x49b40821  

  GG EAx,EBx,ECx,EDx, R8d,   5, 0xf61e2562
  GG EDx,EAx,EBx,ECx, R13d,  9, 0xc040b340
  GG ECx,EDx,EAx,EBx, R18d, 14, 0x265e5a51  
  GG EBx,ECx,EDx,EAx, EBP,  20, 0xe9b6c7aa  
  GG EAx,EBx,ECx,EDx, R12d,  5, 0xd62f105d  
  GG EDx,EAx,EBx,ECx, R17d,  9, 0x02441453  
  GG ECx,EDx,EAx,EBx, R22d, 14, 0xd8a1e681  
  GG EBx,ECx,EDx,EAx, R11d, 20, 0xe7d3fbc8  
  GG EAx,EBx,ECx,EDx, R16d,  5, 0x21e1cde6  
  GG EDx,EAx,EBx,ECx, R21d,  9, 0xc33707d6  
  GG ECx,EDx,EAx,EBx, R10d, 14, 0xf4d50d87  
  GG EBx,ECx,EDx,EAx, R15d, 20, 0x455a14ed  
  GG EAx,EBx,ECx,EDx, R20d,  5, 0xa9e3e905  
  GG EDx,EAx,EBx,ECx, R9d,   9, 0xfcefa3f8  
  GG ECx,EDx,EAx,EBx, R14d, 14, 0x676f02d9  
  GG EBx,ECx,EDx,EAx, R19d, 20, 0x8d2a4c8a  

  HH EAx,EBx,ECx,EDx, R12d,  4, 0xfffa3942  
  HH EDx,EAx,EBx,ECx, R15d, 11, 0x8771f681  
  HH ECx,EDx,EAx,EBx, R18d, 16, 0x6d9d6122 
  HH EBx,ECx,EDx,EAx, R21d, 23, 0xfde5380c  
  HH EAx,EBx,ECx,EDx, R8d,   4, 0xa4beea44  
  HH EDx,EAx,EBx,ECx, R11d, 11, 0x4bdecfa9  
  HH ECx,EDx,EAx,EBx, R14d, 16, 0xf6bb4b60  
  HH EBx,ECx,EDx,EAx, R17d, 23, 0xbebfbc70  
  HH EAx,EBx,ECx,EDx, R20d,  4, 0x289b7ec6
  HH EDx,EAx,EBx,ECx, EBP,  11, 0xeaa127fa
  HH ECx,EDx,EAx,EBx, R10d, 16, 0xd4ef3085
  HH EBx,ECx,EDx,EAx, R13d, 23, 0x04881d05
  HH EAx,EBx,ECx,EDx, R16d,  4, 0xd9d4d039
  HH EDx,EAx,EBx,ECx, R19d, 11, 0xe6db99e5
  HH ECx,EDx,EAx,EBx, R22d, 16, 0x1fa27cf8
  HH EBx,ECx,EDx,EAx,  R9d, 23, 0xc4ac5665

  II EAx,EBx,ECx,EDx, EBP,   6, 0xf4292244
  II EDx,EAx,EBx,ECx, R14d, 10, 0x432aff97
  II ECx,EDx,EAx,EBx, R21d, 15, 0xab9423a7
  II EBx,ECx,EDx,EAx, R12d, 21, 0xfc93a039
  II EAx,EBx,ECx,EDx, R19d,  6, 0x655b59c3
  II EDx,EAx,EBx,ECx, R10d, 10, 0x8f0ccc92
  II ECx,EDx,EAx,EBx, R17d, 15, 0xffeff47d
  II EBx,ECx,EDx,EAx, R8d,  21, 0x85845dd1
  II EAx,EBx,ECx,EDx, R15d,  6, 0x6fa87e4f
  II EDx,EAx,EBx,ECx, R22d, 10, 0xfe2ce6e0
  II ECx,EDx,EAx,EBx, R13d, 15, 0xa3014314
  II EBx,ECx,EDx,EAx, R20d, 21, 0x4e0811a1
  II EAx,EBx,ECx,EDx, R11d,  6, 0xf7537e82
  II EDx,EAx,EBx,ECx, R18d, 10, 0xbd3af235
  II ECx,EDx,EAx,EBx, R9d,  15, 0x2ad7d2bb
  II EBx,ECx,EDx,EAx, R16d, 21, 0xeb86d391

  Add [RSI],    EAX
  Add [RSI+4],  EBX
  Add [RSI+8],  ECX
  Add [RSI+12], EDX

  Pop R22
  Pop R21
  Pop R20
  Pop R19
  Pop R18
  Pop R17
  Pop R16
  Pop R15
  Pop R14
  Pop R13
  Pop R12
  Pop RBP
  Pop RDI
  Pop RSI
  Pop RBX

  Ret
