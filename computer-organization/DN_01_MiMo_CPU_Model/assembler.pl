#!/usr/bin/perl
use strict;
use warnings;

# Assembler for Warren's 16-bit microcontrolled CPU.
# (c) GPL3 Warren Toomey, 2012
# v0 : Original file
# v1 : Bug fixed: X processing option (11/2017)
#                 few instructions' definitions changed
# v2 : corrected bug for swi,lwi ( from 'dX' to 'dsi' )

die("Usage: $0 inputfile\n") if (@ARGV!=1);

# Table of opcode names, the values
# and their arguments
# Meaning of abbreviations in %Opcode:
    # D-reg 				if ($atype eq 'd') {
    # D-reg, S-reg is D-reg if ($atype eq 'D') {
    # S-reg  				if ($atype eq 's') {
    # T-reg 				if ($atype eq 't') {
    # Absolute immediate	if ($atype eq 'i') {
    # Relative immediate 	if ($atype eq 'I') {

    # Indexed addressing. We want to allow these types of argument:
    # (Rn) where immed=0, immed(Rn), Rn(immed) and 
	#    immed can be numeric or a label and 
	#    Rn is the s-reg
    #						if ($atype eq 'X') {

    # Register indexed addressing. We want to see Rs(Rt) only.
    #						if ($atype eq 'S') {

my %Opcode= (
	add =>  [ 0, 'dst'  ],
	sub =>  [ 1, 'dst'  ],
	mul =>  [ 2, 'dst'  ],
	div =>  [ 3, 'dst'  ],
	rem =>  [ 4, 'dst'  ],
	and =>  [ 5, 'dst'  ],
	or =>   [ 6, 'dst'  ],
	xor =>  [ 7, 'dst'  ],
	nand => [ 8, 'dst'  ],
	nor =>  [ 9, 'dst'  ],
	not =>  [ 10, 'ds'  ],
	lsl =>  [ 11, 'dst' ],
	lsr =>  [ 12, 'dst' ],
	asr =>  [ 13, 'dst' ],
	rol =>  [ 14, 'dst' ],
	ror =>  [ 15, 'dst' ],
	addi => [ 16, 'dsi' ],
	subi => [ 17, 'dsi' ],
	muli => [ 18, 'dsi' ],
	divi => [ 19, 'dsi' ],
	remi => [ 20, 'dsi' ],
	andi => [ 21, 'dsi' ],
	ori =>  [ 22, 'dsi' ],
	xori => [ 23, 'dsi' ],
	nandi => [ 24, 'dsi'],
	nori => [ 25, 'dsi' ],
	lsli => [ 26, 'dsi' ],
	lsri => [ 27, 'dsi' ],
	asri => [ 28, 'dsi' ],
	roli => [ 29, 'dsi' ],
	rori => [ 30, 'dsi' ],
#	addc => [ 31, 'dstI'],
#	subc => [ 32, 'dstI'],
	addc => [ 31, 'dsti'],   # addc Rd,Rs,Rt,immed
	subc => [ 32, 'dsti'],   # subc Rd,Rs,Rt,immed
	jeq =>  [ 33, 'sti' ],
	jne =>  [ 34, 'sti' ],
	jgt =>  [ 35, 'sti' ],
	jle =>  [ 36, 'sti' ],
	jlt =>  [ 37, 'sti' ],
	jge =>  [ 38, 'sti' ],
	jeqz => [ 39, 'si'  ],
	jnez => [ 40, 'si'  ],
	jgtz => [ 41, 'si'  ],
	jlez => [ 42, 'si'  ],
	jltz => [ 43, 'si'  ],
	jgez => [ 44, 'si'  ],
	jmp =>  [ 45, 'i'   ],
	beq =>  [ 46, 'stI' ],
	bne =>  [ 47, 'stI' ],
	bgt =>  [ 48, 'stI' ],
	ble =>  [ 49, 'stI' ],
	blt =>  [ 50, 'stI' ],
	bge =>  [ 51, 'stI' ],
	beqz => [ 52, 'sI'  ],
	bnez => [ 53, 'sI'  ],
	bgtz => [ 54, 'sI'  ],
	blez => [ 55, 'sI'  ],
	bltz => [ 56, 'sI'  ],
	bgez => [ 57, 'sI'  ],
	br =>   [ 58, 'I'   ],
	jsr =>  [ 59, 'i',	'$Mcode[$PC]+= 7<<3; # sp' ],
	rts =>  [ 60, '', 	'$Mcode[$PC]+= 7<<3; # sp' ],
	inc =>  [ 61, 's'   ],
	dec =>  [ 62, 's'   ],
	li =>   [ 63, 'di'  ],
	lw =>   [ 64, 'di'  ],
	sw =>   [ 65, 'di'  ],
#	lwi =>  [ 66, 'dX'  ],
#	swi =>  [ 67, 'dX'  ],
	lwi =>  [ 66, 'dsi'  ],
	swi =>  [ 67, 'dsi'  ],
	push => [ 68, 'd',	'$Mcode[$PC]+= 7<<3; # sp' ],
	pop =>  [ 69, 'd',	'$Mcode[$PC]+= 7<<3; # sp' ],
	move => [ 70, 'ds'  ],
	clr =>  [ 71, 's'   ],
	neg =>  [ 72, 's'   ],
	lwri => [ 73, 'dst' ],    # lwri Rd,Rs,Rt
	swri => [ 74, 'dst' ],	  # swri Rd,Rs,Rt
#	lwri => [ 73, 'dS' ],
#	swri => [ 74, 'dS' ],
);

my %Label;	# Hash of label -> PC values
my @Mcode;	# Machine code for each PC value
my @Origline;	# Original line
my @Ltype;	# Type of label? undef is not, 1 is abs, 2 is rel
my $PC=0;	# Current progam counter

# Open up the input
open(my $IN, "<", $ARGV[0]) || die("Cannot open $ARGV[0]: $!\n");
while (<$IN>) {
  chomp;
  s{\s*#.*}{};          # Trim comments
  s{\t\t}{\t};          # Trim tabs
  next if (m{^\s*$});   # Skip blank lines

  $Origline[$PC]= $_;

  # Assume no immediate value
  my $hadImmed=0;

  # Deal with labels
  if (m{(.*):\s+(.*)}) {
    $Label{$1}= $PC;
    $_= $2;
  }

  # Trim leading whitespace
  $_ =~ s{^\s+}{};

  # Split the line up into the opcode and the arguments
  my ($opcode, $args)= split(/\s+/, $_,2);

  # Check that the opcode exists
  die("Unknown opcode $opcode\n") if (!defined($Opcode{$opcode}));

  # Fill in the opcode of the machine instruction
  $Mcode[$PC]= $Opcode{$opcode}->[0] << 9;	# Shift past 3 regs

  # Run any code associated with this instruction
  eval($Opcode{$opcode}->[2]) if (defined($Opcode{$opcode}->[2]));

  # Get the arguments as a list
  my @alist= split(/,\s*/, $args?$args:'');

  # Check the correct # of arguments
  die("Bad # args: $_\n") if (length($Opcode{$opcode}->[1]) != @alist);

  # Process the arguments
  foreach my $atype (split(//, $Opcode{$opcode}->[1])) {

    # Get the arg
    my $arg= shift(@alist);

    # D-reg
    if ($atype eq 'd') {
      # Lose leading text
      $arg =~ s{^\D*}{};
      $Mcode[$PC] += ($arg & 7); next;
    }

    # D-reg, S-reg is D-reg
    if ($atype eq 'D') {
      # Lose leading text
      $arg =~ s{^\D*}{};
      $Mcode[$PC] += ($arg & 7);
      $Mcode[$PC] += ($arg & 7) << 3; next;
    }

    # S-reg
    if ($atype eq 's') {
      # Lose leading text
      $arg =~ s{^\D*}{};
      $Mcode[$PC] += ($arg & 7) << 3; next;
    }

    # T-reg
    if ($atype eq 't') {
      # Lose leading text
      $arg =~ s{^\D*}{};
      $Mcode[$PC] += ($arg & 7) << 6; next;
    }

    # Absolute immediate
    if ($atype eq 'i') {
	# Deal with hex values
	$arg= hex($arg) if ($arg =~ m{^0x});
	# Simply bump up the PC and save the value for now
	$PC++; $Mcode[$PC]= $arg; $Ltype[$PC]=1;
    }

    # Relative immediate
    if ($atype eq 'I') {
	# Deal with hex values
	$arg= hex($arg) if ($arg =~ m{^0x});
	# Bump up the PC and save the value, mark as relative
	$PC++; $Mcode[$PC]= $arg; $Ltype[$PC]=2;
    }

    # Indexed addressing. We want to allow these types of argument:
    # (Rn) where immed=0, immed(Rn), Rn(immed) and 
	#    immed can be numeric or a label and 
	#    Rn is the s-reg
    if ($atype eq 'X') {
	my ($regnum, $immed);
	if ($arg=~ m{(\S*)\([Rr](\d+)\)}) {
	  $immed= $1; $regnum=$2;
	}
	if ($arg=~ m{[Rr](\d+)\((\S+)\)}) {
	  $immed= $2; $regnum=$1;
	}
	if ($arg=~ m{[Rr](\d+),(\S+)}) {   # [ls]wi Rd,Rs,immed
	  $immed= $2; $regnum=$1;
	}
        die("Bad indexed arg: $arg\n") if (!defined($regnum));
	$immed=0 if ($immed eq "");
	$immed= hex($immed) if ($immed =~ m{^0x});
        $Mcode[$PC] += ($regnum & 7) << 3;
	$PC++; $Mcode[$PC]= $immed; $Ltype[$PC]=1; next;
    }

    # Register indexed addressing. We want to see Rs(Rt) only.
    if ($atype eq 'S') {
	my ($sreg, $treg);
	if ($arg=~ m{[Rr](\d+)\([Rr](\d+)\)}) {
	  $sreg= $1; $treg=$2;
	} else {
          die("Bad indexed arg: $arg\n");
	}
        $Mcode[$PC] += ($sreg & 7) << 3;
        $Mcode[$PC] += ($treg & 7) << 6; next;
    }
  }
  # Next instruction
  $PC++;
}
close($IN);

# Time to backpatch the label values in the machine code
for (my $i=0; $i < @Mcode; $i++) {
  next if (!$Ltype[$i]);

  # Get the label's value, lookup if not numeric:
  # optional leading - sign, followed by 1 or more digits
  my $label= $Mcode[$i];
  if (!($label=~ m{^-?\d+$})) {
    die("Undefined label >$label<\n") if (!defined($Label{$label}));
    $label= $Label{$label};
  }

  # Calculate absolute value if it is relative
  $label= $label - $i if ($Ltype[$i]==2);
  
  # Save the final value;
  $Mcode[$i]= $label & 0xffff;
}

# Print out the machine code in hex for now
for (my $i=0; $i < @Mcode; $i++) {
  printf("%04x: %08x  %016b\t%s\n", $i, $Mcode[$i], $Mcode[$i], $Origline[$i] ? $Origline[$i] : "");
}

# Create and save the RAM file
my $outfile= $ARGV[0];
$outfile=~ s{\.[^\.*]$}{.ram};
open(my $OUT, ">", $outfile) || die("Can't write to $outfile: $!\n");
print($OUT "v2.0 raw\n");
for (my $i=0; $i < @Mcode; $i++) {
  printf($OUT "%x ", $Mcode[$i]);
  print($OUT "\n") if (($i % 8)==7);
}
print($OUT "\n");
exit(0);
