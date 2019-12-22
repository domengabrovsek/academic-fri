#!/usr/bin/perl
use strict;
use warnings;

# Microassembler for Warren's 16-bit microcontrolled CPU.
# (c) GPL3 Warren Toomey, 2012

# v0 : Original file
# v1 : Bug fixed: conz changed to corz   (line 75, RR 11/2017)

die("Usage: $0 inputfile\n") if (@ARGV!=1);

# Table of control ROM values for the
# known control=value pairs
my %Cvalue= (
	'aluop=add' =>      0,
	'aluop=sub' =>      1,
	'aluop=mul' =>      2,
	'aluop=div' =>      3,
	'aluop=rem' =>      4,
	'aluop=and' =>      5,
	'aluop=or'  =>      6,
	'aluop=xor' =>      7,
	'aluop=nand' =>     8,
	'aluop=nor' =>      9,
	'aluop=not' =>      10,
	'aluop=lsl' =>      11,
	'aluop=lsr' =>      12,
	'aluop=asr' =>      13,
	'aluop=rol'  =>     14,
	'aluop=ror' =>      15,
	'op2sel=treg' =>    0 << 4,
	'op2sel=immed' =>   1 << 4,
	'op2sel=const0' =>       2 << 4,
	'op2sel=const1' =>       3 << 4,
	'datawrite=0' =>    0 << 6,
	'datawrite=1' =>    1 << 6,
	'addrsel=pc' =>     0 << 7,
	'addrsel=immed' =>  1 << 7,
	'addrsel=aluout' => 2 << 7,
	'addrsel=sreg' =>   3 << 7,
	'pcsel=pc' =>       0 << 9,
	'pcsel=immed' =>    1 << 9,
	'pcsel=pcimmed' =>  2 << 9,
	'pcsel=sreg' =>     3 << 9,
	'pcload=0' =>       0 << 11,
	'pcload=1' =>       1 << 11,
	'dwrite=0' =>       0 << 12,
	'dwrite=1' =>       1 << 12,
	'irload=0' =>       0 << 13,
	'irload=1' =>       1 << 13,
	'imload=0' =>       0 << 14,
	'imload=1' =>       1 << 14,
	'regsrc=databus' => 0 << 15,
	'regsrc=immed' =>   1 << 15,
	'regsrc=aluout' =>  2 << 15,
	'regsrc=sreg' =>    3 << 15,
	'cond=c' =>         0 << 17,
	'cond=corz' =>      1 << 17,
	'cond=z' =>         2 << 17,
	'cond=n' =>         3 << 17,
	'indexsel=0' =>     0 << 19,
	'indexsel=opcode' =>1 << 19,
	'datasel=pc' =>     0 << 20,
	'datasel=dreg' =>   1 << 20,
	'datasel=treg' =>   2 << 20,
	'datasel=aluout' => 3 << 20,
	'swrite=0' =>       0 << 22,
	'swrite=1' =>       1 << 22,
);

# Condition values
my %Cond= (
  z => 2,
  corz => 1,
  n => 3,
  c => 0
);

# Label to address lookup table
my %Label;

# The control and jump ROMs
my (@CROM, @JROM, @Origline);

my $nextaddr=0;		# Next address to use
my $offset=0;		# Offset to opcode 0

# Open up the input from file
open(my $IN, "<", $ARGV[0]) || die("Cannot open $ARGV[0]: $!\n");
while (<$IN>) {
  chomp;
  s{\s*#.*}{};		# Trim comments
  next if (m{^\s*$});	# Skip blank lines
  #print("$_\n");

  my $this= $nextaddr;
  my $label="";
  my $origline= $_;

  # Deal with labels
  if (m{(.*):\s+(.*)}) {
    $label= $1; $_= $2;

    # Set this address up if its an opcode number
    $this= $label + $offset if ($label =~ m{^\d+$});

    # Save the label
    die("Error: label $label already defined\n") if (defined($Label{$label}));
    $Label{$label}= $this;
  }

  # If this isn't the first line of an opcode,
  # bump up nextaddr as we are going to fill that position
  $nextaddr++ if ($label !~ m{^\d+$});

  # Trim leading whitespace
  $_ =~ s{^\s+}{};

  # Split the line up into control/val pairs and any jump
  #print("nolabel line $_\n");
  my ($cpairs, $jump)= split(/,/, $_);
  #printf("cpairs >$cpairs< jump >%s<\n", $jump ? $jump : "");

  # Deal with the control lines, build up the 32-bit control value
  my $cvalue=0;
  foreach my $cpair (split(/\s+/, $cpairs)) {
    die("Error: unrecognised  control/val $cpair\n")
					if (!defined($Cvalue{$cpair}));
    $cvalue += $Cvalue{$cpair};
    #print("$cpair => $Cvalue{$cpair}\n");
  }

  # Deal with any jump
  my $tjump= $nextaddr;
  my $fjump= $nextaddr;

  if (defined($jump)) {
    my $cond;
    # End of the fetch logic, so we now know the opcode offset
    if ($jump =~ m{opcode_jump}) {
      $offset= $nextaddr;
      $nextaddr= $offset+128;
      $cvalue += $Cvalue{"indexsel=opcode"};
      goto jumpend;
    }

    # Explicit goto
    if ($jump =~ m{goto\s+(\S+)}) {
      $tjump= $1;
      $fjump= $1;
      goto jumpend;
    }

    # Full if decision
    if ($jump =~ m{if\s+(\S+)\s+then\s(\S+)\s+else\s+(\S+)}) {
      ($cond,$tjump,$fjump)=($1,$2,$3);
      die("Error: unknown condition $cond\n") if (!defined($Cond{$cond}));
      $cvalue += $Cvalue{"cond=$cond"};
      goto jumpend;
    }

    # Partial if decision
    if ($jump =~ m{if\s+(\S+)\s+then\s(\S+)}) {
      ($cond,$jump)=($1,$2);
      die("Error: unknown condition $cond\n") if (!defined($Cond{$cond}));
      $cvalue += $Cvalue{"cond=$cond"};
      goto jumpend;
    }

    # Unrecognised jump command
      die("Error: unrecognised jump command $jump\n");
  }

jumpend:

  #printf("$label ($this): control 0x%x, jump $tjump $fjump\n\n", $cvalue);
  $CROM[$this]= $cvalue;
  $JROM[$this]= [$tjump,$fjump];
  $Origline[$this]= $origline;
}
close($IN);

# Patch in the labels in the @JROM
for my $i (0 .. 255) {
  my $tjump= $JROM[$i]->[0] ? $JROM[$i]->[0] : 0;
  my $fjump= $JROM[$i]->[1] ? $JROM[$i]->[1] : 0;
  # Deal with the actual labels
  if ($tjump !~ m{^\d+$}) {
    die("Error: unknown label $tjump\n") if (!defined($Label{$tjump}));
    $tjump= $Label{$tjump};
  }
  if ($fjump !~ m{^\d+$}) {
    die("Error: unknown label $fjump\n") if (!defined($Label{$fjump}));
    $fjump= $Label{$fjump};
  }
  $JROM[$i]= ($tjump << 8) + $fjump;
}

# Print out the ROMs
for my $i (0 .. 255) {
  next if (!defined($Origline[$i]));
  printf("%02x: %08x %04x\t# %s\n", $i, $CROM[$i], $JROM[$i], $Origline[$i]);
}

# Write out the ROMs
open(my $OUT, ">", "ucontrol.rom") || die("Can't write to ucontrol.rom: $!\n");
print($OUT "v2.0 raw\n");
for my $i (0 .. 255) {
  printf($OUT "%x ", $CROM[$i] ? $CROM[$i] : 0);
  print($OUT "\n") if (($i % 8)==7);
}
close($OUT);
open($OUT, ">", "udecision.rom") || die("Can't write to udecision.rom: $!\n");
print($OUT "v2.0 raw\n");
for my $i (0 .. 255) {
  printf($OUT "%x ", $JROM[$i] ? $JROM[$i] : 0);
  print($OUT "\n") if (($i % 8)==7);
}
close($OUT);
exit(0);
