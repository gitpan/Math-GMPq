#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <stdio.h>
#include <stdlib.h>
#include <gmp.h>

#if __GNU_MP_VERSION < 5
#define mp_bitcnt_t unsigned long int
#endif

SV * Rgmp_randinit_default() {
     gmp_randstate_t * rand_obj;
     SV * obj_ref, * obj;

     New(1, rand_obj, 1, gmp_randstate_t);
     if(rand_obj == NULL) croak("Failed to allocate memory in Math::GMPq::Random::Rgmp_randinit_default function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::GMPq::Random");
     gmp_randinit_default(*rand_obj);

     sv_setiv(obj, INT2PTR(IV, rand_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * Rgmp_randinit_mt() {
     gmp_randstate_t * rand_obj;
     SV * obj_ref, * obj;

     New(1, rand_obj, 1, gmp_randstate_t);
     if(rand_obj == NULL) croak("Failed to allocate memory in Math::GMPq::Random::Rgmp_randinit_mt function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::GMPq::Random");
     gmp_randinit_mt(*rand_obj);

     sv_setiv(obj, INT2PTR(IV, rand_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * Rgmp_randinit_lc_2exp(mpz_t* a, SV * c, SV * m2exp) {
     gmp_randstate_t * rand_obj;
     SV * obj_ref, * obj;

     New(1, rand_obj, 1, gmp_randstate_t);
     if(rand_obj == NULL) croak("Failed to allocate memory in Math::GMPq::Random::Rgmp_randinit_lc_2exp function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::GMPq::Random");
     gmp_randinit_lc_2exp(*rand_obj, *a, (unsigned long)SvUV(c), (mp_bitcnt_t)SvUV(m2exp));

     sv_setiv(obj, INT2PTR(IV, rand_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * Rgmp_randinit_lc_2exp_size(SV * size) {
     gmp_randstate_t * rand_obj, t;
     SV * obj_ref, * obj;
     int ret;

     /* Check that 'size' is not too large ... and croak immediately if it is. */
     /* This way we should be able to croak cleanly. If we croak near the end of the sub */
     /* we're liable to get strange segfaults and/or free to wrong pool errors */
     ret = gmp_randinit_lc_2exp_size(t,(mp_bitcnt_t)SvUV(size));
     if(!ret) croak ("gmp_randinit_lc_2exp_size function failed. Did you specify a value for 'size'that is bigger than the table provides ?");
     gmp_randclear(t); /* Served it's purpose ... no longer needed */

     New(1, rand_obj, 1, gmp_randstate_t);
     if(rand_obj == NULL) croak("Failed to allocate memory in Math::GMPq::Random::Rgmp_randinit_lc_2exp_size function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::GMPq::Random");
     ret = gmp_randinit_lc_2exp_size(*rand_obj,(mp_bitcnt_t)SvUV(size));
     sv_setiv(obj, INT2PTR(IV, rand_obj));
     SvREADONLY_on(obj);
     if(!ret) croak ("Second call to gmp_randinit_lc_2exp_size function failed. Did you specify a value for 'size'that is bigger than the table provides ?");
     return obj_ref;
}

SV * Rgmp_randinit_set(gmp_randstate_t * op) {
     gmp_randstate_t * rand_obj;
     SV * obj_ref, * obj;

     New(1, rand_obj, 1, gmp_randstate_t);
     if(rand_obj == NULL) croak("Failed to allocate memory in Math::GMPq::Random::Rgmp_randinit_set function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::GMPq::Random");
     gmp_randinit_set(*rand_obj, *op);

     sv_setiv(obj, INT2PTR(IV, rand_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * Rgmp_urandomb_ui(gmp_randstate_t * state, SV * n) {
     unsigned long max, req = (unsigned long)SvUV(n);
     max = sizeof(unsigned long) * 8;
     if(req > max) croak("In Math::GMPq::Random::Rgmp_urandomb_ui, requested %u bits, but %u is the maximum allowed", req, max);
     return newSVuv(gmp_urandomb_ui(*state, req));
}

SV * Rgmp_urandomm_ui(gmp_randstate_t * state, SV * n) {
     return newSVuv(gmp_urandomm_ui(*state, (unsigned long)SvUV(n)));
}

/*##########################################*/

SV * Rgmp_randinit_default_nobless() {
     gmp_randstate_t * rand_obj;
     SV * obj_ref, * obj;

     New(1, rand_obj, 1, gmp_randstate_t);
     if(rand_obj == NULL) croak("Failed to allocate memory in Math::GMPq::Random::Rgmp_randinit_default_nobless function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, NULL);
     gmp_randinit_default(*rand_obj);

     sv_setiv(obj, INT2PTR(IV, rand_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * Rgmp_randinit_mt_nobless() {
     gmp_randstate_t * rand_obj;
     SV * obj_ref, * obj;

     New(1, rand_obj, 1, gmp_randstate_t);
     if(rand_obj == NULL) croak("Failed to allocate memory in Math::GMPq::Random::Rgmp_randinit_mt_nobless function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, NULL);
     gmp_randinit_mt(*rand_obj);

     sv_setiv(obj, INT2PTR(IV, rand_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * Rgmp_randinit_lc_2exp_nobless(mpz_t* a, SV * c, SV * m2exp) {
     gmp_randstate_t * rand_obj;
     SV * obj_ref, * obj;

     New(1, rand_obj, 1, gmp_randstate_t);
     if(rand_obj == NULL) croak("Failed to allocate memory in Math::GMPq::Random::Rgmp_randinit_lc_2exp_nobless function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, NULL);
     gmp_randinit_lc_2exp(*rand_obj, *a, (unsigned long)SvUV(c), (mp_bitcnt_t)SvUV(m2exp));

     sv_setiv(obj, INT2PTR(IV, rand_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * Rgmp_randinit_lc_2exp_size_nobless(SV * size) {
     gmp_randstate_t * rand_obj;
     SV * obj_ref, * obj;
     int ret;

     New(1, rand_obj, 1, gmp_randstate_t);
     if(rand_obj == NULL) croak("Failed to allocate memory in Math::GMPq::Random::Rgmp_randinit_lc_2exp_size_nobless function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, NULL);
     ret = gmp_randinit_lc_2exp_size(*rand_obj,(mp_bitcnt_t)SvUV(size));
     if(!ret) croak ("gmp_randinit_lc_2exp_size_nobless function failed. Did you specify a value for 'size'that is bigger than the table provides ?");

     sv_setiv(obj, INT2PTR(IV, rand_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * Rgmp_randinit_set_nobless(gmp_randstate_t * op) {
     gmp_randstate_t * rand_obj;
     SV * obj_ref, * obj;

     New(1, rand_obj, 1, gmp_randstate_t);
     if(rand_obj == NULL) croak("Failed to allocate memory in Math::GMPq::Random::Rgmp_randinit_set_nobless function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, NULL);
     gmp_randinit_set(*rand_obj, *op);

     sv_setiv(obj, INT2PTR(IV, rand_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

/*##########################################*/

void Rgmp_randseed(gmp_randstate_t * state, mpz_t * seed) {
     gmp_randseed(*state, *seed);
}

void Rgmp_randseed_ui(gmp_randstate_t * state, SV * seed) {
     gmp_randseed_ui(*state, (unsigned long int)SvUV(seed));
}

void DESTROY(gmp_randstate_t * p) {
/*     printf("Destroying gmp_randstate "); */
     gmp_randclear(*p);
/*     printf("...cleared "); */
     Safefree(p);
/*     printf("...destroyed\n"); */
}

void Rgmp_randclear(gmp_randstate_t * p) {
/* clear gmp_randstate_t and free the perl object */
     gmp_randclear(*p);
     Safefree(p);
}

void Rgmp_randclear_state(gmp_randstate_t * p) {
/* clear gmp_randstate_t only */
     gmp_randclear(*p);
}

void Rgmp_randclear_ptr(gmp_randstate_t * p) {
/* free perl object only */
     Safefree(p);
}
MODULE = Math::GMPq::Random	PACKAGE = Math::GMPq::Random	

PROTOTYPES: DISABLE


SV *
Rgmp_randinit_default ()

SV *
Rgmp_randinit_mt ()

SV *
Rgmp_randinit_lc_2exp (a, c, m2exp)
	mpz_t *	a
	SV *	c
	SV *	m2exp

SV *
Rgmp_randinit_lc_2exp_size (size)
	SV *	size

SV *
Rgmp_randinit_set (op)
	gmp_randstate_t *	op

SV *
Rgmp_urandomb_ui (state, n)
	gmp_randstate_t *	state
	SV *	n

SV *
Rgmp_urandomm_ui (state, n)
	gmp_randstate_t *	state
	SV *	n

SV *
Rgmp_randinit_default_nobless ()

SV *
Rgmp_randinit_mt_nobless ()

SV *
Rgmp_randinit_lc_2exp_nobless (a, c, m2exp)
	mpz_t *	a
	SV *	c
	SV *	m2exp

SV *
Rgmp_randinit_lc_2exp_size_nobless (size)
	SV *	size

SV *
Rgmp_randinit_set_nobless (op)
	gmp_randstate_t *	op

void
Rgmp_randseed (state, seed)
	gmp_randstate_t *	state
	mpz_t *	seed
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rgmp_randseed(state, seed);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rgmp_randseed_ui (state, seed)
	gmp_randstate_t *	state
	SV *	seed
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rgmp_randseed_ui(state, seed);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
DESTROY (p)
	gmp_randstate_t *	p
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	DESTROY(p);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rgmp_randclear (p)
	gmp_randstate_t *	p
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rgmp_randclear(p);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rgmp_randclear_state (p)
	gmp_randstate_t *	p
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rgmp_randclear_state(p);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rgmp_randclear_ptr (p)
	gmp_randstate_t *	p
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rgmp_randclear_ptr(p);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

