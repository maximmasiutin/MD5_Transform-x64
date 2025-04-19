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


# This is a 32-bit version of MD5_Transform
# modified by Maxim Masiutin for Borland 32-bit "register"
# calling convention. For more information on this calling convension, see
# https://en.wikipedia.org/wiki/X86_calling_conventions#Borland_register

# This is a version for the GNU Assembler (GAS)
# To compile, call: 
# as -msyntax=intel -mnaked-reg --32 -o md5_32_gas.obj md5_32_gas.asm 



# FF Macro: a := ROL(a + [x] + y + (b AND c OR NOT b AND d), s) + b
.macro FF a, b, c, d, x, s, y
  add \a, DWORD PTR [ebp + 4*\x]
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

# GG Macro: a := ROL(a + [x] + y + (b AND d OR c AND NOT d), s) + b
.macro GG a, b, c, d, x, s, y
  add \a, DWORD PTR [ebp + 4*\x]
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

# HH Macro: a := ROL(a + [x] + y + (b XOR c XOR d), s) + b
.macro HH a, b, c, d, x, s, y
  add \a, DWORD PTR [ebp + 4*\x]
  add \a, \y
  mov esi, \d
  xor esi, \c
  xor esi, \b
  add \a, esi
  rol \a, \s
  add \a, \b
.endm

# II Macro: a := ROL(a + [x] + y + (c XOR (b OR NOT d)), s) + b
.macro II a, b, c, d, x, s, y
  add \a, DWORD PTR [ebp + 4*\x]
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
  Push EBx
  Push ESi
  Push EDi
  Push EBp

  Mov EBp, EDx        
  Push EAx
  Mov EDx, [EAx+12]
  Mov ECx, [EAx+8]
  Mov EBx, [EAx+4]
  Mov EAx, [EAx]

  FF EAx,EBx,ECx,EDx,  0,  7, 0xd76aa478  
  FF EDx,EAx,EBx,ECx,  1, 12, 0xe8c7b756  
  FF ECx,EDx,EAx,EBx,  2, 17, 0x242070db  
  FF EBx,ECx,EDx,EAx,  3, 22, 0xc1bdceee  
  FF EAx,EBx,ECx,EDx,  4,  7, 0xf57c0faf  
  FF EDx,EAx,EBx,ECx,  5, 12, 0x4787c62a  
  FF ECx,EDx,EAx,EBx,  6, 17, 0xa8304613  
  FF EBx,ECx,EDx,EAx,  7, 22, 0xfd469501  
  FF EAx,EBx,ECx,EDx,  8,  7, 0x698098d8  
  FF EDx,EAx,EBx,ECx,  9, 12, 0x8b44f7af  
  FF ECx,EDx,EAx,EBx, 10, 17, 0xffff5bb1  
  FF EBx,ECx,EDx,EAx, 11, 22, 0x895cd7be  
  FF EAx,EBx,ECx,EDx, 12,  7, 0x6b901122  
  FF EDx,EAx,EBx,ECx, 13, 12, 0xfd987193  
  FF ECx,EDx,EAx,EBx, 14, 17, 0xa679438e  
  FF EBx,ECx,EDx,EAx, 15, 22, 0x49b40821  

  GG EAx,EBx,ECx,EDx,  1,  5, 0xf61e2562
  GG EDx,EAx,EBx,ECx,  6,  9, 0xc040b340
  GG ECx,EDx,EAx,EBx, 11, 14, 0x265e5a51  
  GG EBx,ECx,EDx,EAx,  0, 20, 0xe9b6c7aa  
  GG EAx,EBx,ECx,EDx,  5,  5, 0xd62f105d  
  GG EDx,EAx,EBx,ECx, 10,  9, 0x02441453  
  GG ECx,EDx,EAx,EBx, 15, 14, 0xd8a1e681  
  GG EBx,ECx,EDx,EAx,  4, 20, 0xe7d3fbc8  
  GG EAx,EBx,ECx,EDx,  9,  5, 0x21e1cde6  
  GG EDx,EAx,EBx,ECx, 14,  9, 0xc33707d6  
  GG ECx,EDx,EAx,EBx,  3, 14, 0xf4d50d87  
  GG EBx,ECx,EDx,EAx,  8, 20, 0x455a14ed  
  GG EAx,EBx,ECx,EDx, 13,  5, 0xa9e3e905  
  GG EDx,EAx,EBx,ECx,  2,  9, 0xfcefa3f8  
  GG ECx,EDx,EAx,EBx,  7, 14, 0x676f02d9  
  GG EBx,ECx,EDx,EAx, 12, 20, 0x8d2a4c8a  

  HH EAx,EBx,ECx,EDx,  5,  4, 0xfffa3942  
  HH EDx,EAx,EBx,ECx,  8, 11, 0x8771f681  
  HH ECx,EDx,EAx,EBx, 11, 16, 0x6d9d6122 
  HH EBx,ECx,EDx,EAx, 14, 23, 0xfde5380c  
  HH EAx,EBx,ECx,EDx,  1,  4, 0xa4beea44  
  HH EDx,EAx,EBx,ECx,  4, 11, 0x4bdecfa9  
  HH ECx,EDx,EAx,EBx,  7, 16, 0xf6bb4b60  
  HH EBx,ECx,EDx,EAx, 10, 23, 0xbebfbc70  
  HH EAx,EBx,ECx,EDx, 13,  4, 0x289b7ec6
  HH EDx,EAx,EBx,ECx,  0, 11, 0xeaa127fa
  HH ECx,EDx,EAx,EBx,  3, 16, 0xd4ef3085
  HH EBx,ECx,EDx,EAx,  6, 23, 0x04881d05
  HH EAx,EBx,ECx,EDx,  9,  4, 0xd9d4d039
  HH EDx,EAx,EBx,ECx, 12, 11, 0xe6db99e5
  HH ECx,EDx,EAx,EBx, 15, 16, 0x1fa27cf8
  HH EBx,ECx,EDx,EAx,  2, 23, 0xc4ac5665

  II EAx,EBx,ECx,EDx,  0,  6, 0xf4292244
  II EDx,EAx,EBx,ECx,  7, 10, 0x432aff97
  II ECx,EDx,EAx,EBx, 14, 15, 0xab9423a7
  II EBx,ECx,EDx,EAx,  5, 21, 0xfc93a039
  II EAx,EBx,ECx,EDx, 12,  6, 0x655b59c3
  II EDx,EAx,EBx,ECx,  3, 10, 0x8f0ccc92
  II ECx,EDx,EAx,EBx, 10, 15, 0xffeff47d
  II EBx,ECx,EDx,EAx,  1, 21, 0x85845dd1
  II EAx,EBx,ECx,EDx,  8,  6, 0x6fa87e4f
  II EDx,EAx,EBx,ECx, 15, 10, 0xfe2ce6e0
  II ECx,EDx,EAx,EBx,  6, 15, 0xa3014314
  II EBx,ECx,EDx,EAx, 13, 21, 0x4e0811a1
  II EAx,EBx,ECx,EDx,  4,  6, 0xf7537e82
  II EDx,EAx,EBx,ECx, 11, 10, 0xbd3af235
  II ECx,EDx,EAx,EBx,  2, 15, 0x2ad7d2bb
  II EBx,ECx,EDx,EAx,  9, 21, 0xeb86d391

  Pop ESi
  Add [ESi],    EAx
  Add [ESi+4],  EBx
  Add [ESi+8],  ECx
  Add [ESi+12], EDx

  Pop EBp
  Pop EDi
  Pop ESi
  Pop EBx

  Ret
