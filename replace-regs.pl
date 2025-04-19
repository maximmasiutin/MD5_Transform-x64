#!/usr/bin/perl
use strict;
use warnings;

my @regs = qw(EBP R8d R9d R10d R11d R12d R13d R14d R15d R16d R17d R18d R19d R20d R21d R22d);

while (<>) {
    # Replace the 5th argument (index) with the corresponding register
    s/^(\s*\w+\s+\w+,\w+,\w+,\w+,\s*)(\d+)(\s*,.*)$/$1 . $regs[$2] . $3/e;
    print;
}
