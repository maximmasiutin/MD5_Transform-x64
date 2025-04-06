# MD5_Transform-x64
MD5 transform routine optimized for x86-64 processors written using Macro Assembler.

Copyright (C) 2018-2020 Ritlabs, SRL. All rights reserved.

Copyright (C) 2020-2025 Maxim Masiutin. All rights reserved.

The 64-bit version was written by Maxim Masiutin <maxim@masiutin.com>.

It is based on 32-bit code by Peter Sawatzki (see below).

You can compile this code using Microsoft Macro Assembler (MASM for x64),
which is a part of Microsoft Visual Studio.
```
ml64.exe /c md5_64.asm
```

You can also compile the code on Linux or Windows using Netwide Assembler (nasm) - see `md5_64_nasm.asm` for details.

The performance is 4.94 CPU cycles per byte (on Skylake processors).

The main advantage of this 64-bit version is that it loads 64 bytes of the hashed message into 8 64-bit registers (RBP, R8, R9, R10, R11, R12, R13, R14) at the beginning to avoid excessive memory load operations throughout the routine.

To operate with 32-bit values stored in the higher bits of a 64-bit register (bits 32-63), it uses the "ROR" (rotate right) instruction to rotate the bits of a 64-bit register by 32 so that the lower 32 and higher 32 bits of the 64-bit register swap, allowing efficient manipulation of these values without additional memory accesses or instructions. Eight macro variables (M1-M8) are used to keep track of whether the register has been rotated or not.

It also has the ability to use the LEA instruction instead of two sequential ADDs (uncomment `UseLea=1`), but this is slower on Skylake processors. Additionally, Intel's Optimization Reference Manual discourages the use of LEA as a replacement for two ADDs, as it is slower on Atom processors.

This implementation follows Microsoft's x64 Application Binary Interface (ABI), also known as the "x64 ABI" calling convention, used for Win64. The registers RCX and RDX are used to pass parameters, as per the x64 ABI. According to Microsoft, "The x64 ABI considers registers RBX, RBP, RDI, RSI, RSP, R12, R13, R14, R15 nonvolatile. They must be saved and restored by a function that uses them."

For Unix (Linux), Netwide Assembler (nasm) is used, to assemble the code for "System V AMD64 ABI" calling convention which uses RDI to pass first argument, and RSI to pass second argument. According to System V AMD64 ABI, the registers RBX, RBP and R12-R15 should be preserved by the callee (the function being called), while the other registers, including RDI and RSI, can be modified by the callee.

This code is used in "The Bat!" email client:  
https://www.ritlabs.com/en/products/thebat/

MD5_Transform-x64 is released under a dual license, and you may choose to use it under either the Mozilla Public License 2.0 (MPL 2.1, available from https://www.mozilla.org/en-US/MPL/2.0/) or the GNU Lesser General Public License Version 3, dated 29 June 2007 (LGPL 3, available from https://www.gnu.org/licenses/lgpl.html).

MD5_Transform-x64 is based on the following code by Peter Sawatzki.

The original notice by Peter Sawatzki follows.

# MD5_386.Asm
MD5_386.Asm   -  386 optimized helper routine for calculating
                 MD Message-Digest values

written 2/2/94 by

Peter Sawatzki
Buchenhof 3
D58091 Hagen, Germany Fed Rep

EMail: Peter@Sawatzki.de
EMail: 100031.3002@compuserve.com
WWW:   http://www.sawatzki.de


original C Source was found in Dr. Dobbs Journal Sep 91
MD5 algorithm from RSA Data Security, Inc.
