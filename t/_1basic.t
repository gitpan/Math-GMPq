use warnings;
use strict;
use Math::GMPq qw(__GNU_MP_VERSION __GNU_MP_VERSION_MINOR __GNU_MP_VERSION_PATCHLEVEL);

print "1..9\n";

warn "\n# Using Math::GMPq version ", $Math::GMPq::VERSION, "\n";
warn "# Using gmp library version ", Math::GMPq::gmp_v(), "\n";
warn "# CC is ", Math::GMPq::__GMP_CC, "\n" if defined Math::GMPq::__GMP_CC;
warn "# CFLAGS are ", Math::GMPq::__GMP_CFLAGS, "\n" if defined Math::GMPq::__GMP_CFLAGS;

if($Math::GMPq::VERSION eq '0.37' && $Math::GMPq::Random::VERSION eq '0.37' &&
   Math::GMPq::_get_xs_version() eq $Math::GMPq::VERSION) {print "ok 1\n"}
else {print "not ok 1 $Math::GMPq::VERSION $Math::GMPq::Random::VERSION ", Math::GMPq::_get_xs_version(), "\n"}

my @version = split /\./, Math::GMPq::gmp_v();

if(scalar(@version) == 3) {print "ok 2\n"}
else {print "not ok 2\n"}

if (__GNU_MP_VERSION == $version[0]) {print "ok 3\n"}
else {print "not ok 3\n"}

if (__GNU_MP_VERSION_MINOR == $version[1]) {print "ok 4\n"}
else {print "not ok 4\n"}

if (__GNU_MP_VERSION_PATCHLEVEL == $version[2]) {print "ok 5\n"}
else {print "not ok 5\n"}

eval {Math::GMPq::__GMP_CC;};
unless($@) {print "ok 6\n"}
else {
  warn "$@\n";
  print "not ok 6\n"
}

eval {Math::GMPq::__GMP_CFLAGS;};
unless($@) {print "ok 7\n"}
else {
  warn "$@\n";
  print "not ok 7\n"
}

my $version_num = version_num(__GNU_MP_VERSION, __GNU_MP_VERSION_MINOR, __GNU_MP_VERSION_PATCHLEVEL);

print $version_num < 262659 ? !defined(Math::GMPq::__GMP_CC) ? "ok 8\n" : "not ok 8\n"
                            :  defined(Math::GMPq::__GMP_CC) ? "ok 8\n" : "not ok 8\n";

print $version_num < 262659 ? !defined(Math::GMPq::__GMP_CFLAGS) ? "ok 9\n" : "not ok 9\n"
                            :  defined(Math::GMPq::__GMP_CFLAGS) ? "ok 9\n" : "not ok 9\n";

sub version_num {
    return ($_[0] << 16) | ($_[1] << 8) | $_[2];
}
