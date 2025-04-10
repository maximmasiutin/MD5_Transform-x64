; MD5_Transform-x64

; MD5 transform routine optimized for x86-64 processors

; Copyright (C) 2018-2020 Ritlabs, SRL. All rights reserved.
; Copyright (C) 2020-2025 Maxim Masiutin. All rights reserved.

; The 64-bit version is written
; by Maxim Masiutin <maxim@masiutin.com>
; Based on 32-bit code by Peter Sawatzki (see below).

; The performance is 4.94 CPU cycles per byte (on Skylake).

; The main advantage of this 64-bit version is that
; it loads 64 bytes of the hashed message into eight 64-bit registers
; (RBP, R8, R9, R10, R11, R12, R13, R14) at the beginning,
; to avoid excessive memory load operations
; throughout the routine.

; To operate with 32-bit values stored in the higher bits
; of a 64-bit register (bits 32-63), it uses "ROR" by 32
; (rotate the bits of the 64-bit register by 32).
;
; To manage the state of the registers and track whether 
; they have been rotated, eight macro variables (M1-M8) are used. 
; These variables ensure that the code maintains consistency and
; avoids unnecessary rotations, optimizing performance.


; It also has the ability to use the LEA instruction instead
; of two sequential ADDs (uncomment UseLea=1), but it is
; slower on Skylake processors. Additionally, Intel's
; Optimization Reference Manual discourages the use of
; LEA as a replacement for two ADDs, since it is slower
; on Atom processors.

; This implementation follows Microsoft's x64 
; Application Binary Interface (ABI), also known as the "x64 ABI" 
; calling convention, used for Win64. The registers RCX and RDX are 
; used to pass parameters, as per the x64 ABI.
; According to Microsoft, "The x64 ABI considers registers RBX, RBP, 
; RDI, RSI, RSP, R12, R13, R14, R15 nonvolatile. They must be saved 
; and restored by a function that uses them."

; MD5_Transform-x64 is released under a dual license,
; and you may choose to use it under either the
; Mozilla Public License 2.0 (MPL 2.1, available from
; https://www.mozilla.org/en-US/MPL/2.0/) or the
; GNU Lesser General Public License Version 3,
; dated 29 June 2007 (LGPL 3, available from
; https://www.gnu.org/licenses/lgpl.html).

; MD5_Transform-x64 is based
; on the following code by Peter Sawatzki.

; The original notice by Peter Sawatzki follows.

; ==============================================================
;
; MD5_386.Asm   -  386 optimized helper routine for calculating
;                  MD Message-Digest values
; written 2/2/94 by
;
; Peter Sawatzki
; Buchenhof 3
; D58091 Hagen, Germany Fed Rep
;
; EMail: Peter@Sawatzki.de
; EMail: 100031.3002@compuserve.com
; WWW:   http://www.sawatzki.de
;
;
; original C Source was found in Dr. Dobbs Journal Sep 91
; MD5 algorithm from RSA Data Security, Inc.


           .CODE


; You can compile this code using Microsoft Macro Assembler (MASM for x64),
; which is a part of Microsoft Visual Studio.
;     ml64.exe /c md5_64.asm



; Uncomment the line below if you wish to have
; a "Lea" instruction instead of two subsequent "Add".

; UseLea=1



; The AA macro adds r to ac to a and stores result to r
; r and a can be either 32-bit (for the "Add" version)
; or 64-bit (for the "Lea" version)

AA Macro r32,r64,ac,a32,a64
  IFDEF UseLea
     Lea r64, [r64+ac+a64]
  ELSE
     Add r32, ac
     Add r32, a32
  ENDIF
EndM

; The JJ macro adds value from state buffer to the "a" register
; The "a" register can be either 32-bit (for the "Add" version)
; or 64-bit (for "Lea") - in this case it is passed as "r"

JJ Macro a,x,ac,r
IFE x-0 ; if x is equal to 0
  IF M1 ; if the M1 macro variable is not 0
   Ror RBP, 32
   M1=0 ; set the M1 macro variable to 0
  ENDIF
   AA a, r, ac, EBP, RBP
ENDIF
IFE x-1 ; if x is equal to 1
  IFE M1
   Ror RBP, 32
   M1=1
  ENDIF
   AA a, r, ac, EBP, RBP
ENDIF
IFE x-2
  IF M2 ; if the M2 macro variable is not 0
   Ror R8, 32
   M2=0 ; set the M2 macro variable to 0
  ENDIF
   AA a, r, ac, R8D, R8
ENDIF
IFE x-3
  IFE M2
   Ror R8, 32
   M2=1
  ENDIF
   AA a, r, ac, R8D, R8
ENDIF
IFE x-4
  IF M3
   Ror R9, 32
   M3=0
  ENDIF
   AA a, r, ac, R9D, R9
ENDIF
IFE x-5
  IFE M3
   Ror R9, 32
   M3=1
  ENDIF
   AA a, r, ac, R9D, R9
ENDIF
IFE x-6
  IF M4
   Ror R10, 32
   M4=0
  ENDIF
   AA a, r, ac, R10D, R10
ENDIF
IFE x-7
  IFE M4
   Ror R10, 32
   M4=1
  ENDIF
   AA a, r, ac, R10D, R10
ENDIF
IFE x-8
  IF M5
   Ror R11, 32
   M5=0
  ENDIF
   AA a, r, ac, R11D, R11
ENDIF
IFE x-9
  IFE M5
   Ror R11, 32
   M5=1
  ENDIF
   AA a, r, ac, R11D, R11
ENDIF
IFE x-10
  IF M6
   Ror R12, 32
   M6=0
  ENDIF
   AA a, r, ac, R12D, R12
ENDIF
IFE x-11
  IFE M6
   Ror R12, 32
   M6=1
  ENDIF
   AA a, r, ac, R12D, R12
ENDIF
IFE x-12
  IF M7
   Ror R13, 32
   M7=0
  ENDIF
   AA a, r, ac, R13D, R13
ENDIF
IFE x-13
  IFE M7
   Ror R13, 32
   M7=1
  ENDIF
   AA a, r, ac, R13D, R13
ENDIF
IFE x-14
  IF M8
   Ror R14, 32
   M8=0
  ENDIF
   AA a, r, ac, R14D, R14
ENDIF
IFE x-15
  IFE M8
   Ror R14, 32
   M8=1
  ENDIF
   AA a, r, ac, R14D, R14
ENDIF
EndM


FF Macro a,b,c,d,x,s,ac,r
; a:= ROL (a+x+ac + (b And c Or Not b And d), s) + b
  JJ a, x, ac, r
  Mov ESI, b
  Not ESI
  And ESI, d
  Mov EDI, c
  And EDI, b
  Or  ESI, EDI
  Add a, ESI
  Rol a, s
  Add a, b
EndM

GG Macro a,b,c,d,x,s,ac,r
; a:= ROL (a+x+ac + (b And d Or c And Not d), s) + b
  JJ a, x, ac, r
  Mov ESI, d
  Not ESI
  And ESI, c
  Mov EDI, d
  And EDI, b
  Or  ESI, EDI
  Add a, ESI
  Rol a, s
  Add a, b
EndM

HH Macro a,b,c,d,x,s,ac,r
; a:= ROL (a+x+ac + (b Xor c Xor d), s) + b
  JJ a, x, ac, r
  Mov ESI, d
  Xor ESI, c
  Xor ESI, b
  Add a, ESI
  Rol a, s
  Add a, b
EndM

II Macro a,b,c,d,x,s,ac,r
; a:= ROL (a+x+ac + (c Xor (b Or Not d)), s) + b
  JJ a, x, ac, r
  Mov ESI, d
  Not ESI
  Or  ESI, b
  Xor ESI, c
  Add a, ESI
  Rol a, s
  Add a, b
EndM

MD5_Transform Proc
Public MD5_Transform

; save registers that the caller requires to be preserved
  Push RBX
  Push RSI
  Push RDI

  Push RBP
  Push R12
  Push R13
  Push R14
  Push R15

; First parameter is passed in RCX, Second - in RDX

; State   - in RCX
; Message - in RDX

  Mov R15, RCX ; Save the state structure offset to R15
  Mov R14, RDX ; Now the message buffer offset is in R14

  Mov EAX, [R15]
  Mov EBX, [R15+4]
  Mov ECX, [R15+8]
  Mov EDX, [R15+12]

  Mov RBP, [R14+4*0]
  Mov R8,  [R14+4*2]
  Mov R9,  [R14+4*4]
  Mov R10, [R14+4*6]
  Mov R11, [R14+4*8]
  Mov R12, [R14+4*10]
  Mov R13, [R14+4*12]
  Mov R14, [R14+4*14]

  M1 = 0
  M2 = 0
  M3 = 0
  M4 = 0
  M5 = 0
  M6 = 0
  M7 = 0
  M8 = 0

  FF EAX,EBX,ECX,EDX,  0,  7, 0d76aa478h, RAX  ; 1
  FF EDX,EAX,EBX,ECX,  1, 12, 0e8c7b756h, RDX  ; 2
  FF ECX,EDX,EAX,EBX,  2, 17, 0242070dbh, RCX  ; 3
  FF EBX,ECX,EDX,EAX,  3, 22, 0c1bdceeeh, RBX  ; 4
  FF EAX,EBX,ECX,EDX,  4,  7, 0f57c0fafh, RAX  ; 5
  FF EDX,EAX,EBX,ECX,  5, 12, 04787c62ah, RDX  ; 6
  FF ECX,EDX,EAX,EBX,  6, 17, 0a8304613h, RCX  ; 7
  FF EBX,ECX,EDX,EAX,  7, 22, 0fd469501h, RBX  ; 8
  FF EAX,EBX,ECX,EDX,  8,  7, 0698098d8h, RAX  ; 9
  FF EDX,EAX,EBX,ECX,  9, 12, 08b44f7afh, RDX  ; 10
  FF ECX,EDX,EAX,EBX, 10, 17, 0ffff5bb1h, RCX  ; 11
  FF EBX,ECX,EDX,EAX, 11, 22, 0895cd7beh, RBX  ; 12
  FF EAX,EBX,ECX,EDX, 12,  7, 06b901122h, RAX  ; 13
  FF EDX,EAX,EBX,ECX, 13, 12, 0fd987193h, RDX  ; 14
  FF ECX,EDX,EAX,EBX, 14, 17, 0a679438eh, RCX  ; 15
  FF EBX,ECX,EDX,EAX, 15, 22, 049b40821h, RBX  ; 16

  GG EAX,EBX,ECX,EDX,  1,  5, 0f61e2562h, RAX  ; 17
  GG EDX,EAX,EBX,ECX,  6,  9, 0c040b340h, RDX  ; 18
  GG ECX,EDX,EAX,EBX, 11, 14, 0265e5a51h, RCX  ; 19
  GG EBX,ECX,EDX,EAX,  0, 20, 0e9b6c7aah, RBX  ; 20
  GG EAX,EBX,ECX,EDX,  5,  5, 0d62f105dh, RAX  ; 21
  GG EDX,EAX,EBX,ECX, 10,  9, 002441453h, RDX  ; 22
  GG ECX,EDX,EAX,EBX, 15, 14, 0d8a1e681h, RCX  ; 23
  GG EBX,ECX,EDX,EAX,  4, 20, 0e7d3fbc8h, RBX  ; 24
  GG EAX,EBX,ECX,EDX,  9,  5, 021e1cde6h, RAX  ; 25
  GG EDX,EAX,EBX,ECX, 14,  9, 0c33707d6h, RDX  ; 26
  GG ECX,EDX,EAX,EBX,  3, 14, 0f4d50d87h, RCX  ; 27
  GG EBX,ECX,EDX,EAX,  8, 20, 0455a14edh, RBX  ; 28
  GG EAX,EBX,ECX,EDX, 13,  5, 0a9e3e905h, RAX  ; 29
  GG EDX,EAX,EBX,ECX,  2,  9, 0fcefa3f8h, RDX  ; 30
  GG ECX,EDX,EAX,EBX,  7, 14, 0676f02d9h, RCX  ; 31
  GG EBX,ECX,EDX,EAX, 12, 20, 08d2a4c8ah, RBX  ; 32

  HH EAX,EBX,ECX,EDX,  5,  4, 0fffa3942h, RAX  ; 33
  HH EDX,EAX,EBX,ECX,  8, 11, 08771f681h, RDX  ; 34
  HH ECX,EDX,EAX,EBX, 11, 16, 06d9d6122h, RCX  ; 35
  HH EBX,ECX,EDX,EAX, 14, 23, 0fde5380ch, RBX  ; 36
  HH EAX,EBX,ECX,EDX,  1,  4, 0a4beea44h, RAX  ; 37
  HH EDX,EAX,EBX,ECX,  4, 11, 04bdecfa9h, RDX  ; 38
  HH ECX,EDX,EAX,EBX,  7, 16, 0f6bb4b60h, RCX  ; 39
  HH EBX,ECX,EDX,EAX, 10, 23, 0bebfbc70h, RBX  ; 40
  HH EAX,EBX,ECX,EDX, 13,  4, 0289b7ec6h, RAX  ; 41
  HH EDX,EAX,EBX,ECX,  0, 11, 0eaa127fah, RDX  ; 42
  HH ECX,EDX,EAX,EBX,  3, 16, 0d4ef3085h, RCX  ; 43
  HH EBX,ECX,EDX,EAX,  6, 23, 004881d05h, RBX  ; 44
  HH EAX,EBX,ECX,EDX,  9,  4, 0d9d4d039h, RAX  ; 45
  HH EDX,EAX,EBX,ECX, 12, 11, 0e6db99e5h, RDX  ; 46
  HH ECX,EDX,EAX,EBX, 15, 16, 01fa27cf8h, RCX  ; 47
  HH EBX,ECX,EDX,EAX,  2, 23, 0c4ac5665h, RBX  ; 48

  II EAX,EBX,ECX,EDX,  0,  6, 0f4292244h, RAX  ; 49
  II EDX,EAX,EBX,ECX,  7, 10, 0432aff97h, RDX  ; 50
  II ECX,EDX,EAX,EBX, 14, 15, 0ab9423a7h, RCX  ; 51
  II EBX,ECX,EDX,EAX,  5, 21, 0fc93a039h, RBX  ; 52
  II EAX,EBX,ECX,EDX, 12,  6, 0655b59c3h, RAX  ; 53
  II EDX,EAX,EBX,ECX,  3, 10, 08f0ccc92h, RDX  ; 54
  II ECX,EDX,EAX,EBX, 10, 15, 0ffeff47dh, RCX  ; 55
  II EBX,ECX,EDX,EAX,  1, 21, 085845dd1h, RBX  ; 56
  II EAX,EBX,ECX,EDX,  8,  6, 06fa87e4fh, RAX  ; 57
  II EDX,EAX,EBX,ECX, 15, 10, 0fe2ce6e0h, RDX  ; 58
  II ECX,EDX,EAX,EBX,  6, 15, 0a3014314h, RCX  ; 59
  II EBX,ECX,EDX,EAX, 13, 21, 04e0811a1h, RBX  ; 60
  II EAX,EBX,ECX,EDX,  4,  6, 0f7537e82h, RAX  ; 61
  II EDX,EAX,EBX,ECX, 11, 10, 0bd3af235h, RDX  ; 62
  II ECX,EDX,EAX,EBX,  2, 15, 02ad7d2bbh, RCX  ; 63
  II EBX,ECX,EDX,EAX,  9, 21, 0eb86d391h, RBX  ; 64

; update state
  Add [R15],    EAX
  Add [R15+4],  EBX
  Add [R15+8],  ECX
  Add [R15+12], EDX

; restore nonvolatile registers
  Pop R15
  Pop R14
  Pop R13
  Pop R12
  Pop RBP

  Pop RDI
  Pop RSI
  Pop RBX

  Ret
MD5_Transform EndP

  End

; That's All Folks!
