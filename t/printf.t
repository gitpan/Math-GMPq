use warnings;
use strict;
use Math::GMPq qw(:mpq);
use Math::BigInt; # for some error checks

print "1..7\n";

print "# Using gmp version ", Math::GMPq::gmp_v(), "\n";

open(WR1, '>', 'out1.txt') or die "Can't open WR1: $!";
open(WR2, '>', 'out2.txt') or die "Can't open WR2: $!";

my $mp = Math::GMPq->new(-1234567);
my $int = -17;
my $ul = 56789;
my $string = "A string";

Rmpq_fprintf(\*WR1, "An mpq object: %Qd ", $mp);

$mp++;
Rmpq_fprintf(\*WR2, "An mpq object: %Qd ", $mp);

Rmpq_fprintf(\*WR1, "followed by a signed int: $int ");
$int++;
Rmpq_fprintf(\*WR2, "followed by a signed int: $int ");

Rmpq_fprintf(\*WR1, "followed by an unsigned long: $ul\n");
$ul++;
Rmpq_fprintf(\*WR2, "followed by an unsigned long: $ul\n");

Rmpq_fprintf(\*WR1, "%s ", $string);
Rmpq_fprintf(\*WR2, "%s ", $string);

Rmpq_fprintf(\*WR1, "and an mpq object in hex: %Qx\n", $mp);
$mp++;
Rmpq_fprintf(\*WR2, "and an mpq object in hex: %Qx\n", $mp);

close(WR1) or die "Can't close WR1: $!";
close(WR2) or die "Can't close WR2: $!";
open(RD1, '<', 'out1.txt') or die "Can't open RD1: $!";
open(RD2, '<', 'out2.txt') or die "Can't open RD2: $!";

my $ok;

while(<RD1>) {
     chomp;
     if($. == 1) {
       if($_ eq 'An mpq object: -1234567 followed by a signed int: -17 followed by an unsigned long: 56789') {$ok .= 'a'}
        else {warn "1a got: $_\n"}
     }
     if($. == 2) {
       if($_ =~ /A string and an mpq object in hex: \-12D686/i) {$ok .= 'b'}
        else {warn "1b got: $_\n"}
     }
}

while(<RD2>) {
     chomp;
     if($. == 1) {
       if($_ eq 'An mpq object: -1234566 followed by a signed int: -16 followed by an unsigned long: 56790') {$ok .= 'c'}
        else {warn "1c got: $_\n"}
     }
     if($. == 2) {
       if($_ =~ /A string and an mpq object in hex: \-12D685/i) {$ok .= 'd'}
        else {warn "1d got: $_\n"}
     }
}

close(RD1) or die "Can't close RD1: $!";
close(RD2) or die "Can't close RD2: $!";

if($ok eq 'abcd') {print "ok 1\n"}
else {print "not ok 1 $ok\n"}

$ok = '';
my $buffer = 'XOXO' x 10;
my $buf = $buffer;

Rmpq_sprintf($buf, "The mpq object: %Qd", $mp);
if ($buf eq 'The mpq object: -1234565') {$ok .= 'a'}
else {warn "2a got: $buf\n"}

$buf = $buffer;
$mp *= -1;

my $ret = Rmpq_sprintf_ret($buf, "The mpq object: %Qd", $mp);
if ($ret eq 'The mpq object: 1234565') {$ok .= 'b'}
else {warn "2b got: $ret\n"}
if ($buf eq 'The mpq object: 1234565' . "\0" . 'XOXO' x 4) {$ok .= 'c'}
else {warn "2c got: $buf\n"}

$ret = Rmpq_sprintf($buf, "$ul");
if($ret == 5) {$ok .= 'd'}
else {warn "2d got: $ret\n"}
if ($buf eq '56790') {$ok .= 'e'}
else {warn "2e got: $buf\n"}

if($ok eq 'abcde') {print "ok 2\n"}
else {print "not ok 2 $ok\n"}

$ok = '';

my $mbi = Math::BigInt->new(123);
eval {Rmpq_printf("%Qd", $mbi);};
if($@ =~ /Unrecognised object/) {$ok .= 'a'}
else {warn "3a got: $@\n"}

eval {Rmpq_fprintf(\*STDOUT, "%Qd", $mbi);};
if($@ =~ /Unrecognised object/) {$ok .= 'b'}
else {warn "3b got: $@\n"}

eval {Rmpq_sprintf($buf, "%Qd", $mbi);};
if($@ =~ /Unrecognised object/) {$ok .= 'c'}
else {warn "3c got: $@\n"}

eval {Rmpq_sprintf_ret($buf, "%Qd", $mbi);};
if($@ =~ /Unrecognised object/) {$ok .= 'd'}
else {warn "3d got: $@\n"}

eval {Rmpq_fprintf(\*STDOUT, "%Qd", $mbi, $ul);};
if($@ =~ /must pass 3 arguments/) {$ok .= 'e'}
else {warn "3e got: $@\n"}

eval {Rmpq_sprintf($buf, "%Qd", $mbi, $ul);};
if($@ =~ /must pass 3 arguments/) {$ok .= 'f'}
else {warn "3f got: $@\n"}

if($ok eq 'abcdef') {print "ok 3\n"}
else {print "not ok 3 $ok\n"}

$ok = '';

$ret = Rmpq_printf("40%% of %Qd", $mp);
if($ret == 14) {$ok .= 'a'}

my $w = 10;

$ret = Rmpq_printf("40%% of %${w}Qd", $mp);
if($ret == 17) {$ok .= 'b'}

$ret = Rmpq_printf("$string of %${w}Qd", $mp);
if($ret == 22) {$ok .= 'c'}

$ret = Rmpq_printf("$ul of %${w}Qd", $mp);
if($ret == 19) {$ok .= 'd'}

$ret = Rmpq_printf('hello world');
if($ret == 11) {$ok .= 'e'}

if($ok eq 'abcde') {print "\nok 4\n"}
else {print "not ok 4 $ok\n"}

eval{require Math::GMPz;};
if(!$@) {
  my $ok = '';
  my $mpz = Math::GMPz->new(1234567);

  my $ret = Rmpq_printf("40%% of %Zd", $mpz);
  if($ret == 14) {$ok .= 'a'}

  my $w = 10;

  $ret = Rmpq_printf("40%% of %${w}Zd", $mpz);
  if($ret == 17) {$ok .= 'b'}

  $ret = Rmpq_printf("$string of %${w}Zd", $mpz);
  if($ret == 22) {$ok .= 'c'}

  $ret = Rmpq_printf("$ul of %${w}Zd", $mpz);
  if($ret == 19) {$ok .= 'd'}

  if($ok eq 'abcd') {print "\nok 5\n"}
  else {print "not ok 5 $ok\n"}
}
else {
  warn "Skipping test 5 - Math::GMPz not available\n";
  print "ok 5\n";
}

eval{require Math::GMPf;};
if(!$@) {
  my $ok = '';
  my $mp = Math::GMPf->new(1234567);
  my $ret = Rmpq_printf("40%% of %Ff", $mp);
  if($ret == 21) {$ok .= 'a'}

  my $w = 16;

  $ret = Rmpq_printf("40%% of %${w}Ff", $mp);
  if($ret == 23) {$ok .= 'b'}

  $ret = Rmpq_printf("$string of %${w}Ff", $mp);
  if($ret == 28) {$ok .= 'c'}

  $ret = Rmpq_printf("$ul of %${w}Ff", $mp);
  if($ret == 25) {$ok .= 'd'}

  if($ok eq 'abcd') {print "\nok 6\n"}
  else {print "not ok 6 $ok\n"}
}
else {
  warn "Skipping test 6 - Math::GMPf not available\n";
  print "ok 6\n";
}

$ok = '';

$mp *= -1;

$buf = 'X' x 10;
$ret = Rmpq_snprintf_ret($buf, 5, "%Qd", $mp);

if($ret eq '-123') {$ok .= 'a'}
else {warn "7a: $ret\n"}

$ret = Rmpq_snprintf($buf, 6, "%Qd", $mp);

if($ret == 8) {$ok .= 'b'}
else {warn "7b: $ret\n"}

if($buf eq '-1234') {$ok .= 'c'}
else {warn "7c: $buf\n"}

if($ok eq 'abc') {print "ok 7\n"}
else {print "not ok 7\n"}

