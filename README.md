# MD5_Transform-x64
MD5 transform routine oprimized for x86-64 processors written using Macro Assembler

Copyright 2018 Ritlabs, SRL

The 64-bit version is written by Maxim Masiutin <max@ritlabs.com>

Based on code by Peter Sawatzki (see below).

The performance is 4.94 CPU cycles per byte (on Skylake).

The main advantage of this 64-bit version is that
it loads 64 bytes of hashed message into 8 64-bit registers 
(RBP, R8, R9, R10, R11, R12, R13, R14) at the beginning,
to avoid excessive memory load operations 
througout the routine.

To operate with 32-bit values store in higher bits
of a 64-bit register (bits 32-63) uses "Ror" by 32;
8 macro variables (M1-M8) are used to keep record
or current state of whether the register has been
Ror'ed or not.

It also has an ability to use LEA instruction instead
of two sequental ADDs (uncomment UseLea=1), but it is 
slower on Skylake processors. Also, Intel in the 
Optimization Reference Maual discourages use of
LEA as a replacement of two ADDs, since it is slower 
on the Atom processors.

This code is used in "The Bat!" email client
https://www.ritlabs.com/en/products/thebat/

MD5_Transform-x64 is released under a dual license, 
and you may choose to use it under either the 
Mozilla Public License 2.0 (MPL 2.1, available from
https://www.mozilla.org/en-US/MPL/2.0/) or the 
GNU Lesser General Public License Version 3, 
dated 29 June 2007 (LGPL 3, available from
https://www.gnu.org/licenses/lgpl.html).

MD5_Transform-x64 is based 
on the following code by Peter Sawatzki. 

The original notice by Peter Sawatzki follows.

# MD5_386.Asm
386 optimized helper routine for calculating MD Message-Digest values

written 2/2/94 by

Peter Sawatzki
Buchenhof 3
D58091 Hagen, Germany Fed Rep

EMail: Peter@Sawatzki.de
EMail: 100031.3002@compuserve.com
WWW:   http://www.sawatzki.de


original C Source was found in Dr. Dobbs Journal Sep 91
MD5 algorithm from RSA Data Security, Inc.
