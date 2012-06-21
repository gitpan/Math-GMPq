use warnings;
use strict;

print "1..1\n";

eval {use Math::GMPq::V;};

if($@) {
  warn "\$\@: $@";
  print "not ok 1\n";
}
else {
  warn "\nGMP Header version (major): ", Math::GMPq::V::___GNU_MP_VERSION(), "\n";
  warn "GMP Header version (minor): ", Math::GMPq::V::___GNU_MP_VERSION_MINOR(), "\n";
  warn "GMP Header version (patchlevel): ", Math::GMPq::V::___GNU_MP_VERSION_PATCHLEVEL(), "\n";
  warn "GMP Library version: ", Math::GMPq::V::gmp_v(), "\n";
  warn "GMP CC: ", Math::GMPq::V::___GMP_CC(), "\n";
  warn "GMP CFLAGS: ", Math::GMPq::V::___GMP_CFLAGS(), "\n";
  print "ok 1\n";
}