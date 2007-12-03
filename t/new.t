use warnings;
use strict;
use Math::GMPq qw(:mpq);
use Math::BigInt;
use Config;

print "1..4\n";

print "# Using gmp version ", Math::GMPq::gmp_v(), "\n";

my $ui = 123569;
my $si = -19907;
my $d = -1.625;
my $str = '-119125/1000';

my $ok = '';

my $f000 = new Math::GMPq('z/1', 62);
if($f000 == 61) {$ok .= 'a'}

my $f00 = new Math::GMPq();
Rmpq_set_ui($f00, $ui, 1);
if($f00 == $ui) {$ok .= 'b'}

my $f01 = new Math::GMPq($ui);
if($f01 == $ui) {$ok .= 'c'}

my $f02 = new Math::GMPq($si);
if($f02 == $si) {$ok .= 'd'}

my $f03 = new Math::GMPq($d);
if($f03 == $d) {$ok .= 'e'}

my $f04 = new Math::GMPq($str);
if($f04 == $str) {$ok .= 'f'}

my $f05 = new Math::GMPq($str, 10);
if($f05 == $str) {$ok .= 'g'}

my $f06 = new Math::GMPq($d);
if($f06 == $d) {$ok .= 'h'}

if($ok eq 'abcdefgh') {print "ok 1\n"}
else {print "not ok 1 $ok\n"}

#############################


$ok = '';

my $f09 = Math::GMPq::new('z/1', 62);
if($f09 == 61) {$ok .= 'a'}

my $f10 = Math::GMPq::new();
Rmpq_set_ui($f10, $ui, 1);
if($f10 == $ui) {$ok .= 'b'}

my $f11 = Math::GMPq::new($ui);
if($f11 == $ui) {$ok .= 'c'}

my $f12 = Math::GMPq::new($si);
if($f12 == $si) {$ok .= 'd'}

my $f13 = Math::GMPq::new($d);
if($f13 == $d) {$ok .= 'e'}

my $f14 = Math::GMPq::new($str);
if($f14 == $str) {$ok .= 'f'}

my $f15 = Math::GMPq::new($str, 10);
if($f15 == $str) {$ok .= 'g'}

my $f16 = Math::GMPq::new($d);
if($f16 == $d) {$ok .= 'h'}

if($ok eq 'abcdefgh') {print "ok 2\n"}
else {print "not ok 2 $ok\n"}

################################

$ok = '';

my $f19 = Math::GMPq->new('z/1', 62);
if($f19 == 61) {$ok .= 'a'}

my $f20 = Math::GMPq->new();
Rmpq_set_ui($f20, $ui, 1);
if($f20 == $ui) {$ok .= 'b'}

my $f21 = Math::GMPq->new($ui);
if($f21 == $ui) {$ok .= 'c'}

my $f22 = Math::GMPq->new($si);
if($f22 == $si) {$ok .= 'd'}

my $f23 = Math::GMPq->new($d);
if($f23 == $d) {$ok .= 'e'}

my $f24 = Math::GMPq->new($str);
if($f24 == $str) {$ok .= 'f'}

my $f25 = Math::GMPq->new($str, 10);
if($f25 == $str) {$ok .= 'g'}

my $f26 = Math::GMPq->new($d);
if($f26 == $d) {$ok .= 'h'}

my $f27 = Math::GMPq->new(36028797018964023);
my $f28 = Math::GMPq->new('36028797018964023');

if(defined($Config::Config{use64bitint})) {
  if($f27 == $f28) {$ok .= 'i'}
}
else {
  if($f27 != $f28) {$ok .= 'i'}
}

if($ok eq 'abcdefghi') {print "ok 3\n"}
else {print "not ok 3 $ok\n"}

#############################

my $bi = Math::BigInt->new(123456789);

$ok = '';

eval{my $f30 = Math::GMPq->new(17, 12);};
if($@ =~ /Too many arguments supplied to new\(\) \- expected only one/) {$ok = 'a'}

eval{my $f31 = Math::GMPq::new(17, 12);};
if($@ =~ /Too many arguments supplied to new\(\) \- expected only one/) {$ok .= 'b'}

eval{my $f32 = Math::GMPq->new($str, 12, 7);};
if($@ =~ /Too many arguments supplied to new\(\)/) {$ok .= 'c'}

eval{my $f33 = Math::GMPq::new($str, 12, 7);};
if($@ =~ /Too many arguments supplied to new\(\) \- expected no more than two/) {$ok .= 'd'}

eval{my $f34 = Math::GMPq->new($bi);};
if($@ =~ /Inappropriate argument/) {$ok .= 'e'}

eval{my $f35 = Math::GMPq::new($bi);};
if($@ =~ /Inappropriate argument/) {$ok .= 'f'}

eval{my $f30 = Math::GMPq->new($f27, 12);};
if($@ =~ /Too many arguments supplied to new\(\) \- expected only one/) {$ok .= 'g'}

eval{my $f31 = Math::GMPq::new($f27, 12);};
if($@ =~ /Too many arguments supplied to new\(\) \- expected only one/) {$ok .= 'h'}

eval{my $f32 = Math::GMPq->new($str, -1);};
if($@ =~ /Invalid value for base/) {$ok .= 'i'}

if($ok eq 'abcdefghi') {print "ok 4\n"}
else {print "not ok 4 $ok\n"}

