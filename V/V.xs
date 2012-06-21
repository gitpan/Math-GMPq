#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <gmp.h>

SV * ___GNU_MP_VERSION(void) {
     return newSVuv(__GNU_MP_VERSION);
}

SV * ___GNU_MP_VERSION_MINOR(void) {
     return newSVuv(__GNU_MP_VERSION_MINOR);
}

SV * ___GNU_MP_VERSION_PATCHLEVEL(void) {
     return newSVuv(__GNU_MP_VERSION_PATCHLEVEL);
}

SV * ___GMP_CC(void) {
#ifdef __GMP_CC
     char * ret = __GMP_CC;
     return newSVpv(ret, 0);
#else
     return &PL_sv_undef;
#endif
}

SV * ___GMP_CFLAGS(void) {
#ifdef __GMP_CFLAGS
     char * ret = __GMP_CFLAGS;
     return newSVpv(ret, 0);
#else
     return &PL_sv_undef;
#endif
}

SV * gmp_v(void) {
     return newSVpv(gmp_version, 0);
}


MODULE = Math::GMPq::V	PACKAGE = Math::GMPq::V	

PROTOTYPES: DISABLE


SV *
___GNU_MP_VERSION ()
		

SV *
___GNU_MP_VERSION_MINOR ()
		

SV *
___GNU_MP_VERSION_PATCHLEVEL ()
		

SV *
___GMP_CC ()
		

SV *
___GMP_CFLAGS ()
		

SV *
gmp_v ()
		

