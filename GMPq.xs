#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <stdio.h>
#include <stdlib.h>
#include <gmp.h>

#if defined USE_64_BIT_INT || defined USE_LONG_DOUBLE
#include <inttypes.h>
#endif

#ifdef OLDPERL
#define SvUOK SvIsUV
#endif

void Rmpq_canonicalize (SV * p) {
     mpq_canonicalize(*(INT2PTR(mpq_t *, SvIV(SvRV(p)))));
}

SV * Rmpq_init() {
     mpq_t * mpq_t_obj;
     SV * obj_ref, * obj;

     New(1, mpq_t_obj, 1, mpq_t);
     if(mpq_t_obj == NULL) croak("Failed to allocate memory in Rmpq_init function");
     obj_ref = newSViv(0);
     obj = newSVrv(obj_ref, "Math::GMPq");
     mpq_init (*mpq_t_obj);

     sv_setiv(obj, INT2PTR(IV, mpq_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * Rmpq_init_nobless() {
     mpq_t * mpq_t_obj;
     SV * obj_ref, * obj;

     New(1, mpq_t_obj, 1, mpq_t);
     if(mpq_t_obj == NULL) croak("Failed to allocate memory in Rmpq_init_nobless function");
     obj_ref = newSViv(0);
     obj = newSVrv(obj_ref, NULL);
     mpq_init (*mpq_t_obj);

     sv_setiv(obj, INT2PTR(IV, mpq_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

void DESTROY(SV * p) {
/*     printf("Destroying mpq "); */
     mpq_clear(*(INT2PTR(mpq_t *, SvIV(SvRV(p)))));
     Safefree(INT2PTR(mpq_t *, SvIV(SvRV(p))));
/*     printf("...destroyed\n"); */
}

void Rmpq_clear(SV * p) {
     mpq_clear(*(INT2PTR(mpq_t *, SvIV(SvRV(p)))));
     Safefree(INT2PTR(mpq_t *, SvIV(SvRV(p))));
}

void Rmpq_clear_mpq(SV * p) {
     mpq_clear(*(INT2PTR(mpq_t *, SvIV(SvRV(p)))));
}

void Rmpq_clear_ptr(SV * p) {
     Safefree(INT2PTR(mpq_t *, SvIV(SvRV(p))));
}

void Rmpq_set(SV * p1, SV * p2) {
     mpq_set(*(INT2PTR(mpq_t *, SvIV(SvRV(p1)))), *(INT2PTR(mpq_t *, SvIV(SvRV(p2)))));   
}

void Rmpq_swap(SV * p1, SV * p2) {
     mpq_swap(*(INT2PTR(mpq_t *, SvIV(SvRV(p1)))), *(INT2PTR(mpq_t *, SvIV(SvRV(p2)))));   
}

void Rmpq_set_z(SV * p1, SV * p2) {
     mpq_set_z(*(INT2PTR(mpq_t *, SvIV(SvRV(p1)))), *(INT2PTR(mpz_t *, SvIV(SvRV(p2)))));   
}

void Rmpq_set_ui(SV * p1, SV * p2, SV * p3) {
     mpq_set_ui(*(INT2PTR(mpq_t *, SvIV(SvRV(p1)))), SvUV(p2), SvUV(p3));   
}

void Rmpq_set_si(SV * p1, SV * p2, SV * p3) {
     mpq_set_si(*(INT2PTR(mpq_t *, SvIV(SvRV(p1)))), SvIV(p2), SvIV(p3));   
}

void Rmpq_set_str(SV * p1, SV * p2, SV * base) {
     unsigned long b = SvUV(base);
     if(b == 1 || b > 36) croak ("%u is not a valid base in Rmpq_set_str", b);
     if(mpq_set_str(*(INT2PTR(mpq_t *, SvIV(SvRV(p1)))), SvPV_nolen(p2), SvUV(base)))
       croak("String supplied to Rmpq_set_str function is not a valid base %u number", SvUV(base));   
}


SV * Rmpq_get_d(SV * p) {
     return newSVnv(mpq_get_d(*(INT2PTR(mpq_t *, SvIV(SvRV(p))))));
}

void Rmpq_set_d(SV * p, SV * d){
     mpq_set_d(*(INT2PTR(mpq_t *, SvIV(SvRV(p)))), SvNV(d));
}

void Rmpq_set_f(SV * p, SV * f) {
     mpq_set_f(*(INT2PTR(mpq_t *, SvIV(SvRV(p)))), *(INT2PTR(mpf_t *, SvIV(SvRV(f)))));
}

SV * Rmpq_get_str(SV * p, SV * base){
     char * out;
     SV * outsv;
     unsigned long b = SvUV(base);

     New(123, out, mpz_sizeinbase(mpq_numref(*(INT2PTR(mpq_t *, SvIV(SvRV(p))))), b) + mpz_sizeinbase(mpq_denref(*(INT2PTR(mpq_t *, SvIV(SvRV(p))))), b) + 3, char);
     if(out == NULL) croak ("Failed to allocate memory in Rmpq_get_str function");

     mpq_get_str(out, b, *(INT2PTR(mpq_t *, SvIV(SvRV(p)))));
     outsv = newSVpv(out, 0);
     Safefree(out);
     return outsv;
}

SV * Rmpq_cmp(SV * p1, SV * p2) {
     return newSViv(mpq_cmp(*(INT2PTR(mpq_t *, SvIV(SvRV(p1)))), *(INT2PTR(mpq_t *, SvIV(SvRV(p2))))));   
}

SV * Rmpq_cmp_ui(SV * p1, SV * n, SV * d) {
     return newSViv(mpq_cmp_ui(*(INT2PTR(mpq_t *, SvIV(SvRV(p1)))), SvUV(n), SvUV(d)));   
}

SV * Rmpq_cmp_si(SV * p1, SV * n, SV * d) {
     return newSViv(mpq_cmp_si(*(INT2PTR(mpq_t *, SvIV(SvRV(p1)))), SvIV(n), SvUV(d)));   
}

SV * Rmpq_sgn(SV * p) {
     return newSViv(mpq_sgn(*(INT2PTR(mpq_t *, SvIV(SvRV(p))))));
}

SV * Rmpq_equal(SV * p1, SV * p2) {
     return newSViv(mpq_equal(*(INT2PTR(mpq_t *, SvIV(SvRV(p1)))), *(INT2PTR(mpq_t *, SvIV(SvRV(p2))))));   
}

void Rmpq_add(SV * p1, SV * p2, SV * p3) {
     mpq_add(*(INT2PTR(mpq_t *, SvIV(SvRV(p1)))), *(INT2PTR(mpq_t *, SvIV(SvRV(p2)))), *(INT2PTR(mpq_t *, SvIV(SvRV(p3)))));   
}

void Rmpq_sub(SV * p1, SV * p2, SV * p3) {
     mpq_sub(*(INT2PTR(mpq_t *, SvIV(SvRV(p1)))), *(INT2PTR(mpq_t *, SvIV(SvRV(p2)))), *(INT2PTR(mpq_t *, SvIV(SvRV(p3)))));   
}

void Rmpq_mul(SV * p1, SV * p2, SV * p3) {
     mpq_mul(*(INT2PTR(mpq_t *, SvIV(SvRV(p1)))), *(INT2PTR(mpq_t *, SvIV(SvRV(p2)))), *(INT2PTR(mpq_t *, SvIV(SvRV(p3)))));   
}

void Rmpq_div(SV * p1, SV * p2, SV * p3) {
     mpq_div(*(INT2PTR(mpq_t *, SvIV(SvRV(p1)))), *(INT2PTR(mpq_t *, SvIV(SvRV(p2)))), *(INT2PTR(mpq_t *, SvIV(SvRV(p3)))));   
}

void Rmpq_mul_2exp(SV * p1, SV * p2, SV * p3) {
     mpq_mul_2exp(*(INT2PTR(mpq_t *, SvIV(SvRV(p1)))), *(INT2PTR(mpq_t *, SvIV(SvRV(p2)))), SvUV(p3));   
}

void Rmpq_div_2exp(SV * p1, SV * p2, SV * p3) {
     mpq_div_2exp(*(INT2PTR(mpq_t *, SvIV(SvRV(p1)))), *(INT2PTR(mpq_t *, SvIV(SvRV(p2)))), SvUV(p3));   
}

void Rmpq_neg(SV * p1, SV * p2) {
     mpq_neg(*(INT2PTR(mpq_t *, SvIV(SvRV(p1)))), *(INT2PTR(mpq_t *, SvIV(SvRV(p2)))));   
}

void Rmpq_abs(SV * p1, SV * p2) {
     mpq_abs(*(INT2PTR(mpq_t *, SvIV(SvRV(p1)))), *(INT2PTR(mpq_t *, SvIV(SvRV(p2)))));   
}

void Rmpq_inv(SV * p1, SV * p2) {
     mpq_inv(*(INT2PTR(mpq_t *, SvIV(SvRV(p1)))), *(INT2PTR(mpq_t *, SvIV(SvRV(p2)))));   
}

SV * Rmpq_out_str(SV * p, SV *base){
     return newSVuv(mpq_out_str(NULL, SvUV(base), *(INT2PTR(mpq_t *, SvIV(SvRV(p))))));
}

SV * Rmpq_inp_str(SV * p, SV *base){
     return newSVuv(mpq_inp_str(*(INT2PTR(mpq_t *, SvIV(SvRV(p)))), NULL, SvUV(base)));
}

void Rmpq_numref(SV * z, SV * r) {
     mpz_set(*(INT2PTR(mpz_t *, SvIV(SvRV(z)))), mpq_numref(*(INT2PTR(mpq_t *, SvIV(SvRV(r))))));
}

void Rmpq_denref(SV * z, SV * r) {
     mpz_set(*(INT2PTR(mpz_t *, SvIV(SvRV(z)))), mpq_denref(*(INT2PTR(mpq_t *, SvIV(SvRV(r))))));
}

void Rmpq_get_num(SV * z, SV * r) {
     mpq_get_num(*(INT2PTR(mpz_t *, SvIV(SvRV(z)))), *(INT2PTR(mpq_t *, SvIV(SvRV(r)))));
}

void Rmpq_get_den(SV * z, SV * r) {
     mpq_get_den(*(INT2PTR(mpz_t *, SvIV(SvRV(z)))), *(INT2PTR(mpq_t *, SvIV(SvRV(r)))));
}

void Rmpq_set_num(SV * r, SV * z) {
     mpq_set_num(*(INT2PTR(mpq_t *, SvIV(SvRV(r)))), *(INT2PTR(mpz_t *, SvIV(SvRV(z)))));
}

void Rmpq_set_den(SV * r, SV * z) {
     mpq_set_den(*(INT2PTR(mpq_t *, SvIV(SvRV(r)))), *(INT2PTR(mpz_t *, SvIV(SvRV(z)))));
}

SV * get_refcnt(SV * s) {
     return newSVuv(SvREFCNT(s));
}

SV * overload_mul(SV * a, SV * b, SV * third) {
     mpq_t * mpq_t_obj;
     SV * obj_ref, * obj;

     New(1, mpq_t_obj, 1, mpq_t);
     if(mpq_t_obj == NULL) croak("Failed to allocate memory in overload_mul function");
     obj_ref = newSViv(0);
     obj = newSVrv(obj_ref, "Math::GMPq");
     mpq_init(*mpq_t_obj);
     sv_setiv(obj, INT2PTR(IV, mpq_t_obj));
     SvREADONLY_on(obj);

#ifndef USE_64_BIT_INT
     if(SvNOK(b) || SvIOK(b)) {
       mpq_set_d(*mpq_t_obj, SvNV(b));
       mpq_mul(*mpq_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *mpq_t_obj);
       return obj_ref;
       }
#else
     if(SvIOK(b)) {
       if(mpq_set_str(*mpq_t_obj, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_mul");
       mpq_mul(*mpq_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *mpq_t_obj);
       return obj_ref;
       }

     if(SvNOK(b)) {
       mpq_set_d(*mpq_t_obj, SvNV(b));
       mpq_mul(*mpq_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *mpq_t_obj);
       return obj_ref;
       }
#endif

     if(SvPOK(b)) {
       if(mpq_set_str(*mpq_t_obj, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_mul");
       mpq_canonicalize(*mpq_t_obj);
       mpq_mul(*mpq_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *mpq_t_obj);
       return obj_ref;
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq")) {
         mpq_mul(*mpq_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(b)))));
         return obj_ref;
         }
       }

     croak("Invalid argument supplied to Math::GMPq::overload_mul");
}

SV * overload_mul_eq(SV * a, SV * b, SV * third) {
     mpq_t t;

     SvREFCNT_inc(a);

#ifndef USE_64_BIT_INT
     if(SvNOK(b) || SvIOK(b)) {
       mpq_init(t);
       mpq_set_d(t, SvNV(b));
       mpq_mul(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       return a;
       }
#else
     if(SvIOK(b)) {
       mpq_init(t);
       if(mpq_set_str(t, SvPV_nolen(b), 0)) {
         SvREFCNT_dec(a);
         croak("Invalid string supplied to Math::GMPq::overload_mul_eq");
         }
       mpq_mul(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       return a;
       }

     if(SvNOK(b)) {
       mpq_init(t);
       mpq_set_d(t, SvNV(b));
       mpq_mul(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       return a;
       }
#endif

     if(SvPOK(b)) {
       mpq_init(t);
       if(mpq_set_str(t, SvPV_nolen(b), 0)) {
         SvREFCNT_dec(a);
         croak("Invalid string supplied to Math::GMPq::overload_mul_eq");
         }
       mpq_canonicalize(t);
       mpq_mul(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       return a;
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq")) {
         mpq_mul(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(b)))));
         return a;
         }
       }

     SvREFCNT_dec(a);
     croak("Invalid argument supplied to Math::GMPq::overload_mul_eq");
}

SV * overload_add(SV * a, SV * b, SV * third) {
     mpq_t * mpq_t_obj;
     SV * obj_ref, * obj;

     New(1, mpq_t_obj, 1, mpq_t);
     if(mpq_t_obj == NULL) croak("Failed to allocate memory in overload_add function");
     obj_ref = newSViv(0);
     obj = newSVrv(obj_ref, "Math::GMPq");
     mpq_init(*mpq_t_obj);
     sv_setiv(obj, INT2PTR(IV, mpq_t_obj));
     SvREADONLY_on(obj);

#ifndef USE_64_BIT_INT
     if(SvNOK(b) || SvIOK(b)) {
       mpq_set_d(*mpq_t_obj, SvNV(b));
       mpq_add(*mpq_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *mpq_t_obj);
       return obj_ref;
       }
#else
     if(SvIOK(b)) {
       if(mpq_set_str(*mpq_t_obj, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_add");
       mpq_add(*mpq_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *mpq_t_obj);
       return obj_ref;
       }

     if(SvNOK(b)) {
       mpq_set_d(*mpq_t_obj, SvNV(b));
       mpq_add(*mpq_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *mpq_t_obj);
       return obj_ref;
       }
#endif

     if(SvPOK(b)) {
       if(mpq_set_str(*mpq_t_obj, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_add");
       mpq_canonicalize(*mpq_t_obj);
       mpq_add(*mpq_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *mpq_t_obj);
       return obj_ref;
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq")) {
         mpq_add(*mpq_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(b)))));
         return obj_ref;
         }
       }

     croak("Invalid argument supplied to Math::GMPq::overload_add");
}

SV * overload_add_eq(SV * a, SV * b, SV * third) {
     mpq_t t;

     SvREFCNT_inc(a);

#ifndef USE_64_BIT_INT
     if(SvNOK(b) || SvIOK(b)) {
       mpq_init(t);
       mpq_set_d(t, SvNV(b));
       mpq_add(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       return a;
       }
#else
     if(SvIOK(b)) {
       mpq_init(t);
       if(mpq_set_str(t, SvPV_nolen(b), 0)) {
         SvREFCNT_dec(a);
         croak("Invalid string supplied to Math::GMPq::overload_add_eq");
         }
       mpq_add(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       return a;
       }

     if(SvNOK(b)) {
       mpq_init(t);
       mpq_set_d(t, SvNV(b));
       mpq_add(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       return a;
       }
#endif

     if(SvPOK(b)) {
       mpq_init(t);
       if(mpq_set_str(t, SvPV_nolen(b), 0)) {
         SvREFCNT_dec(a);
         croak("Invalid string supplied to Math::GMPq::overload_add_eq");
         }
       mpq_canonicalize(t);
       mpq_add(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       return a;
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq")) {
         mpq_add(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(b)))));
         return a;
         }
       }

     SvREFCNT_dec(a);
     croak("Invalid argument supplied to Math::GMPq::overload_add_eq");
}

SV * overload_sub(SV * a, SV * b, SV * third) {
     mpq_t * mpq_t_obj;
     SV * obj_ref, * obj;

     New(1, mpq_t_obj, 1, mpq_t);
     if(mpq_t_obj == NULL) croak("Failed to allocate memory in overload_sub function");
     obj_ref = newSViv(0);
     obj = newSVrv(obj_ref, "Math::GMPq");
     mpq_init(*mpq_t_obj);
     sv_setiv(obj, INT2PTR(IV, mpq_t_obj));
     SvREADONLY_on(obj);

#ifndef USE_64_BIT_INT
     if(SvNOK(b) || SvIOK(b)) {
       mpq_set_d(*mpq_t_obj, SvNV(b));
       if(third == &PL_sv_yes) mpq_sub(*mpq_t_obj, *mpq_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(a)))));
       else mpq_sub(*mpq_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *mpq_t_obj);
       return obj_ref;
       }
#else
     if(SvIOK(b)) {
       if(mpq_set_str(*mpq_t_obj, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_sub");
       if(third == &PL_sv_yes) mpq_sub(*mpq_t_obj, *mpq_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(a)))));
       else mpq_sub(*mpq_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *mpq_t_obj);
       return obj_ref;
       }

     if(SvNOK(b)) {
       mpq_set_d(*mpq_t_obj, SvNV(b));
       if(third == &PL_sv_yes) mpq_sub(*mpq_t_obj, *mpq_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(a)))));
       else mpq_sub(*mpq_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *mpq_t_obj);
       return obj_ref;
       }
#endif

     if(SvPOK(b)) {
       if(mpq_set_str(*mpq_t_obj, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_sub");
       mpq_canonicalize(*mpq_t_obj);
       if(third == &PL_sv_yes) mpq_sub(*mpq_t_obj, *mpq_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(a)))));
       else mpq_sub(*mpq_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *mpq_t_obj);
       return obj_ref;
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq")) {
         mpq_sub(*mpq_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(b)))));
         return obj_ref;
         }
       }

     croak("Invalid argument supplied to Math::GMPq::overload_sub function");

}

SV * overload_sub_eq(SV * a, SV * b, SV * third) {
     mpq_t t;

     SvREFCNT_inc(a);

#ifndef USE_64_BIT_INT
     if(SvNOK(b) || SvIOK(b)) {
       mpq_init(t);
       mpq_set_d(t, SvNV(b));
       mpq_sub(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       return a;
       }
#else
     if(SvIOK(b)) {
       mpq_init(t);
       if(mpq_set_str(t, SvPV_nolen(b), 0)) {
         SvREFCNT_dec(a);
         croak("Invalid string supplied to Math::GMPq::overload_sub_eq");
         }
       mpq_sub(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       return a;
       }

     if(SvNOK(b)) {
       mpq_init(t);
       mpq_set_d(t, SvNV(b));
       mpq_sub(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       return a;
       }
#endif

     if(SvPOK(b)) {
       mpq_init(t);
       if(mpq_set_str(t, SvPV_nolen(b), 0)) {
         SvREFCNT_dec(a);
         croak("Invalid string supplied to Math::GMPq::overload_sub_eq");
         }
       mpq_canonicalize(t);
       mpq_sub(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       return a;
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq")) {
         mpq_sub(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(b)))));
         return a;
         }
       }

     SvREFCNT_dec(a);
     croak("Invalid argument supplied to Math::GMPq::overload_sub_eq function");

}

SV * overload_div(SV * a, SV * b, SV * third) {
     mpq_t * mpq_t_obj;
     SV * obj_ref, * obj;

     New(1, mpq_t_obj, 1, mpq_t);
     if(mpq_t_obj == NULL) croak("Failed to allocate memory in overload_div function");
     obj_ref = newSViv(0);
     obj = newSVrv(obj_ref, "Math::GMPq");
     mpq_init(*mpq_t_obj);
     sv_setiv(obj, INT2PTR(IV, mpq_t_obj));
     SvREADONLY_on(obj);

#ifndef USE_64_BIT_INT
     if(SvNOK(b) || SvIOK(b)) {
       mpq_set_d(*mpq_t_obj, SvNV(b));
       if(third == &PL_sv_yes) mpq_div(*mpq_t_obj, *mpq_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(a)))));
       else mpq_div(*mpq_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *mpq_t_obj);
       return obj_ref;
       }
#else
     if(SvIOK(b)) {
       if(mpq_set_str(*mpq_t_obj, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_div");
       if(third == &PL_sv_yes) mpq_div(*mpq_t_obj, *mpq_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(a)))));
       else mpq_div(*mpq_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *mpq_t_obj);
       return obj_ref;
       }

     if(SvNOK(b)) {
       mpq_set_d(*mpq_t_obj, SvNV(b));
       if(third == &PL_sv_yes) mpq_div(*mpq_t_obj, *mpq_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(a)))));
       else mpq_div(*mpq_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *mpq_t_obj);
       return obj_ref;
       }
#endif

     if(SvPOK(b)) {
       if(mpq_set_str(*mpq_t_obj, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_div");
       mpq_canonicalize(*mpq_t_obj);
       if(third == &PL_sv_yes) mpq_div(*mpq_t_obj, *mpq_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(a)))));
       else mpq_div(*mpq_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *mpq_t_obj);
       return obj_ref;
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq")) {
         mpq_div(*mpq_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(b)))));
         return obj_ref;
         }
       }

     croak("Invalid argument supplied to Math::GMPq::overload_div function");

}

SV * overload_div_eq(SV * a, SV * b, SV * third) {
     mpq_t t;

     SvREFCNT_inc(a);

#ifndef USE_64_BIT_INT
     if(SvNOK(b) || SvIOK(b)) {
       mpq_init(t);
       mpq_set_d(t, SvNV(b));
       mpq_div(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       return a;
       }
#else
     if(SvIOK(b)) {
       mpq_init(t);
       if(mpq_set_str(t, SvPV_nolen(b), 0)) {
         SvREFCNT_dec(a);
         croak("Invalid string supplied to Math::GMPq::overload_div_eq");
         }
       mpq_div(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       return a;
       }

     if(SvNOK(b)) {
       mpq_init(t);
       mpq_set_d(t, SvNV(b));
       mpq_div(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       return a;
       }
#endif

     if(SvPOK(b)) {
       mpq_init(t);
       if(mpq_set_str(t, SvPV_nolen(b), 0)) {
         SvREFCNT_dec(a);
         croak("Invalid string supplied to Math::GMPq::overload_div_eq");
         }
       mpq_canonicalize(t);
       mpq_div(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       return a;
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq")) {
         mpq_div(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(b)))));
         return a;
         }
       }

     SvREFCNT_dec(a);
     croak("Invalid argument supplied to Math::GMPq::overload_div_eq function");

}

SV * overload_string(SV * p, SV * second, SV * third) {
     char * out;
     SV * outsv;

     New(123, out, mpz_sizeinbase(mpq_numref(*(INT2PTR(mpq_t *, SvIV(SvRV(p))))), 10) + mpz_sizeinbase(mpq_denref(*(INT2PTR(mpq_t *, SvIV(SvRV(p))))), 10) + 3, char);
     if(out == NULL) croak ("Failed to allocate memory in overload_string function");

     mpq_get_str(out, 10, *(INT2PTR(mpq_t *, SvIV(SvRV(p)))));
     outsv = newSVpv(out, 0);
     Safefree(out);
     return outsv;
}

SV * overload_copy(SV * p, SV * second, SV * third) {
     mpq_t * mpq_t_obj;
     SV * obj_ref, * obj;

     New(1, mpq_t_obj, 1, mpq_t);
     if(mpq_t_obj == NULL) croak("Failed to allocate memory in overload_copy function");
     obj_ref = newSViv(0);
     obj = newSVrv(obj_ref, "Math::GMPq");

     mpq_init(*mpq_t_obj);
     mpq_set(*mpq_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(p)))));
     sv_setiv(obj, INT2PTR(IV, mpq_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * overload_abs(SV * p, SV * second, SV * third) {
     mpq_t * mpq_t_obj;
     SV * obj_ref, * obj;

     New(1, mpq_t_obj, 1, mpq_t);
     if(mpq_t_obj == NULL) croak("Failed to allocate memory in overload_abs function");
     obj_ref = newSViv(0);
     obj = newSVrv(obj_ref, "Math::GMPq");
     mpq_init(*mpq_t_obj);

     mpq_abs(*mpq_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(p)))));
     sv_setiv(obj, INT2PTR(IV, mpq_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * overload_gt(SV * a, SV * b, SV * third) {
     mpq_t t;
     int ret;

#ifdef USE_64_BIT_INT
     if(SvIOK(b)) {
       mpq_init(t);
       if(mpq_set_str(t, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_gt");
       ret = mpq_cmp(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret > 0) return newSViv(1);
       return newSViv(0);
       }
#else
     if(SvUOK(b)) {
       ret = mpq_cmp_ui(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), SvUV(b), 1);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret > 0) return newSViv(1);
       return newSViv(0);
       }

     if(SvIOK(b)) {
       ret = mpq_cmp_si(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), SvIV(b), 1);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret > 0) return newSViv(1);
       return newSViv(0);
       }
#endif

     if(SvNOK(b)) {
       mpq_init(t);
       mpq_set_d(t, SvNV(b));
       ret = mpq_cmp(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret > 0) return newSViv(1);
       return newSViv(0);
       }

     if(SvPOK(b)) {
       mpq_init(t);
       if(mpq_set_str(t, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_gt");
       mpq_canonicalize(t);
       ret = mpq_cmp(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret > 0) return newSViv(1);
       return newSViv(0);
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq")) {
         ret = mpq_cmp(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(b)))));
         if(ret > 0) return newSViv(1);
         return newSViv(0);
         }
       }

     croak("Invalid argument supplied to Math::GMPq::overload_gt");
}

SV * overload_gte(SV * a, SV * b, SV * third) {
     mpq_t t;
     int ret;

#ifdef USE_64_BIT_INT
     if(SvIOK(b)) {
       mpq_init(t);
       if(mpq_set_str(t, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_gte");
       ret = mpq_cmp(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret >= 0) return newSViv(1);
       return newSViv(0);
       }
#else
     if(SvUOK(b)) {
       ret = mpq_cmp_ui(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), SvUV(b), 1);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret >= 0) return newSViv(1);
       return newSViv(0);
       }

     if(SvIOK(b)) {
       ret = mpq_cmp_si(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), SvIV(b), 1);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret >= 0) return newSViv(1);
       return newSViv(0);
       }
#endif

     if(SvNOK(b)) {
       mpq_init(t);
       mpq_set_d(t, SvNV(b));
       ret = mpq_cmp(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret >= 0) return newSViv(1);
       return newSViv(0);
       }

     if(SvPOK(b)) {
       mpq_init(t);
       if(mpq_set_str(t, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_gte");
       mpq_canonicalize(t);
       ret = mpq_cmp(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret >= 0) return newSViv(1);
       return newSViv(0);
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq")) {
         ret = mpq_cmp(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(b)))));
         if(ret >= 0) return newSViv(1);
         return newSViv(0);
         }
       }

     croak("Invalid argument supplied to Math::GMPq::overload_gte");
}

SV * overload_lt(SV * a, SV * b, SV * third) {
     mpq_t t;
     int ret;

#ifdef USE_64_BIT_INT
     if(SvIOK(b)) {
       mpq_init(t);
       if(mpq_set_str(t, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_lt");
       ret = mpq_cmp(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret < 0) return newSViv(1);
       return newSViv(0);
       }
#else
     if(SvUOK(b)) {
       ret = mpq_cmp_ui(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), SvUV(b), 1);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret < 0) return newSViv(1);
       return newSViv(0);
       }

     if(SvIOK(b)) {
       ret = mpq_cmp_si(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), SvIV(b), 1);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret < 0) return newSViv(1);
       return newSViv(0);
       }
#endif

     if(SvNOK(b)) {
       mpq_init(t);
       mpq_set_d(t, SvNV(b));
       ret = mpq_cmp(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret < 0) return newSViv(1);
       return newSViv(0);
       }

     if(SvPOK(b)) {
       mpq_init(t);
       if(mpq_set_str(t, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_lt");
       mpq_canonicalize(t);
       ret = mpq_cmp(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret < 0) return newSViv(1);
       return newSViv(0);
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq")) {
         ret = mpq_cmp(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(b)))));
         if(ret < 0) return newSViv(1);
         return newSViv(0);
         }
       }

     croak("Invalid argument supplied to Math::GMPq::overload_lt");
}

SV * overload_lte(SV * a, SV * b, SV * third) {
     mpq_t t;
     int ret;

#ifdef USE_64_BIT_INT
     if(SvIOK(b)) {
       mpq_init(t);
       if(mpq_set_str(t, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_lte");
       ret = mpq_cmp(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret <= 0) return newSViv(1);
       return newSViv(0);
       }
#else
     if(SvUOK(b)) {
       ret = mpq_cmp_ui(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), SvUV(b), 1);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret <= 0) return newSViv(1);
       return newSViv(0);
       }

     if(SvIOK(b)) {
       ret = mpq_cmp_si(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), SvIV(b), 1);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret <= 0) return newSViv(1);
       return newSViv(0);
       }
#endif

     if(SvNOK(b)) {
       mpq_init(t);
       mpq_set_d(t, SvNV(b));
       ret = mpq_cmp(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret <= 0) return newSViv(1);
       return newSViv(0);
       }

     if(SvPOK(b)) {
       mpq_init(t);
       if(mpq_set_str(t, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_lte");
       mpq_canonicalize(t);
       ret = mpq_cmp(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret <= 0) return newSViv(1);
       return newSViv(0);
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq")) {
         ret = mpq_cmp(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(b)))));
         if(ret <= 0) return newSViv(1);
         return newSViv(0);
         }
       }

     croak("Invalid argument supplied to Math::GMPq::overload_lte");
}

SV * overload_spaceship(SV * a, SV * b, SV * third) {
     mpq_t t;
     int ret;

#ifdef USE_64_BIT_INT
     if(SvIOK(b)) {
       mpq_init(t);
       if(mpq_set_str(t, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_spaceship");
       ret = mpq_cmp(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       if(third == &PL_sv_yes) ret *= -1;
       return newSViv(ret);
       }
#else
     if(SvUOK(b)) {
       ret = mpq_cmp_ui(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), SvUV(b), 1);
       if(third == &PL_sv_yes) ret *= -1;
       return newSViv(ret);
       }

     if(SvIOK(b)) {
       ret = mpq_cmp_si(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), SvIV(b), 1);
       if(third == &PL_sv_yes) ret *= -1;
       return newSViv(ret);
       }
#endif

     if(SvNOK(b)) {
       mpq_init(t);
       mpq_set_d(t, SvNV(b));
       ret = mpq_cmp(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       if(third == &PL_sv_yes) ret *= -1;
       return newSViv(ret);
       }

     if(SvPOK(b)) {
       mpq_init(t);
       if(mpq_set_str(t, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_spaceship");
       mpq_canonicalize(t);
       ret = mpq_cmp(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       if(third == &PL_sv_yes) ret *= -1;
       return newSViv(ret);
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq")) {
         ret = mpq_cmp(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(b)))));
         return newSViv(ret);
         }
       }

     croak("Invalid argument supplied to Math::GMPq::overload_spaceship");
}

SV * overload_equiv(SV * a, SV * b, SV * third) {
     mpq_t t;
     int ret;



#ifdef USE_64_BIT_INT
     if(SvIOK(b)) {
       mpq_init(t);
       if(mpq_set_str(t, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_equiv");
       ret = mpq_cmp(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       if(ret == 0) return newSViv(1);
       return newSViv(0);
       }
#else
     if(SvUOK(b)) {
       ret = mpq_cmp_ui(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), SvUV(b), 1);
       if(ret == 0) return newSViv(1);
       return newSViv(0);
       }

     if(SvIOK(b)) {
       ret = mpq_cmp_si(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), SvIV(b), 1);
       if(ret == 0) return newSViv(1);
       return newSViv(0);
       }
#endif

     if(SvNOK(b)) {
       mpq_init(t);
       mpq_set_d(t, SvNV(b));
       ret = mpq_cmp(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       if(ret == 0) return newSViv(1);
       return newSViv(0);
       }

     if(SvPOK(b)) {
       mpq_init(t);
       if(mpq_set_str(t, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_equiv");
       mpq_canonicalize(t);
       ret = mpq_cmp(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       if(ret == 0) return newSViv(1);
       return newSViv(0);
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq")) {
         ret = mpq_cmp(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(b)))));
         if(ret == 0) return newSViv(1);
         return newSViv(0);
         }
       }

     croak("Invalid argument supplied to Math::GMPq::overload_equiv");
}

SV * overload_not_equiv(SV * a, SV * b, SV * third) {
     mpq_t t;
     int ret;

#ifdef USE_64_BIT_INT
     if(SvIOK(b)) {
       mpq_init(t);
       if(mpq_set_str(t, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_not_equiv");
       ret = mpq_cmp(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret != 0) return newSViv(1);
       return newSViv(0);
       }
#else
     if(SvUOK(b)) {
       ret = mpq_cmp_ui(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), SvUV(b), 1);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret != 0) return newSViv(1);
       return newSViv(0);
       }

     if(SvIOK(b)) {
       ret = mpq_cmp_si(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), SvIV(b), 1);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret != 0) return newSViv(1);
       return newSViv(0);
       }
#endif

     if(SvNOK(b)) {
       mpq_init(t);
       mpq_set_d(t, SvNV(b));
       ret = mpq_cmp(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret != 0) return newSViv(1);
       return newSViv(0);
       }

     if(SvPOK(b)) {
       mpq_init(t);
       if(mpq_set_str(t, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_not_equiv");
       mpq_canonicalize(t);
       ret = mpq_cmp(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret != 0) return newSViv(1);
       return newSViv(0);
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq")) {
         ret = mpq_cmp(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(b)))));
         if(ret != 0) return newSViv(1);
         return newSViv(0);
         }
       }

     croak("Invalid argument supplied to Math::GMPq::overload_not_equiv");
}

SV * overload_not(SV * a, SV * second, SV * third) {
     if(mpq_cmp_ui(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), 0, 1)) return newSViv(0);
     return newSViv(1);
}

SV * gmp_v() {
     return newSVpv(gmp_version, 0);
}

void wrap_gmp_printf(SV * a, SV * b) {
     if(sv_isobject(b)) { 
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPz") ||
          strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMP") ||
          strEQ(HvNAME(SvSTASH(SvRV(b))), "GMP::Mpz"))
          gmp_printf(SvPV_nolen(a), *(INT2PTR(mpz_t *, SvIV(SvRV(b)))));
       else {
         if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq") ||
            strEQ(HvNAME(SvSTASH(SvRV(b))), "GMP::Mpq"))
            gmp_printf(SvPV_nolen(a), *(INT2PTR(mpq_t *, SvIV(SvRV(b)))));
         else {
           if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPf") ||
              strEQ(HvNAME(SvSTASH(SvRV(b))), "GMP::Mpf"))
              gmp_printf(SvPV_nolen(a), *(INT2PTR(mpf_t *, SvIV(SvRV(b)))));
              else croak("Unrecognised object supplied as argument to Rmpq_printf");
           }
         }
       } 

     else {
       if(SvUOK(b)) gmp_printf(SvPV_nolen(a), SvUV(b));
       else {
         if(SvIOK(b)) gmp_printf(SvPV_nolen(a), SvIV(b)); 
         else {
           if(SvNOK(b)) gmp_printf(SvPV_nolen(a), SvNV(b)); 
           else {
             if(SvPOK(b)) gmp_printf(SvPV_nolen(a), SvPV_nolen(b));
             else croak("Unrecognised type supplied as argument to Rmpq_printf");
             }
           } 
         }
       }
}

SV * _itsa(SV * a) {
     if(SvUOK(a)) return newSVuv(1);
     if(SvIOK(a)) return newSVuv(2);
     if(SvNOK(a)) return newSVuv(3);
     if(SvPOK(a)) return newSVuv(4);
     if(sv_isobject(a)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(a))), "Math::GMPq")) return newSVuv(5);
       }
     return newSVuv(0);
}

MODULE = Math::GMPq	PACKAGE = Math::GMPq	

PROTOTYPES: DISABLE


void
Rmpq_canonicalize (p)
	SV *	p
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpq_canonicalize(p);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

SV *
Rmpq_init ()

SV *
Rmpq_init_nobless ()

void
DESTROY (p)
	SV *	p
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
Rmpq_clear (p)
	SV *	p
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpq_clear(p);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpq_clear_mpq (p)
	SV *	p
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpq_clear_mpq(p);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpq_clear_ptr (p)
	SV *	p
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpq_clear_ptr(p);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpq_set (p1, p2)
	SV *	p1
	SV *	p2
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpq_set(p1, p2);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpq_swap (p1, p2)
	SV *	p1
	SV *	p2
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpq_swap(p1, p2);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpq_set_z (p1, p2)
	SV *	p1
	SV *	p2
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpq_set_z(p1, p2);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpq_set_ui (p1, p2, p3)
	SV *	p1
	SV *	p2
	SV *	p3
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpq_set_ui(p1, p2, p3);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpq_set_si (p1, p2, p3)
	SV *	p1
	SV *	p2
	SV *	p3
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpq_set_si(p1, p2, p3);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpq_set_str (p1, p2, base)
	SV *	p1
	SV *	p2
	SV *	base
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpq_set_str(p1, p2, base);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

SV *
Rmpq_get_d (p)
	SV *	p

void
Rmpq_set_d (p, d)
	SV *	p
	SV *	d
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpq_set_d(p, d);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpq_set_f (p, f)
	SV *	p
	SV *	f
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpq_set_f(p, f);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

SV *
Rmpq_get_str (p, base)
	SV *	p
	SV *	base

SV *
Rmpq_cmp (p1, p2)
	SV *	p1
	SV *	p2

SV *
Rmpq_cmp_ui (p1, n, d)
	SV *	p1
	SV *	n
	SV *	d

SV *
Rmpq_cmp_si (p1, n, d)
	SV *	p1
	SV *	n
	SV *	d

SV *
Rmpq_sgn (p)
	SV *	p

SV *
Rmpq_equal (p1, p2)
	SV *	p1
	SV *	p2

void
Rmpq_add (p1, p2, p3)
	SV *	p1
	SV *	p2
	SV *	p3
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpq_add(p1, p2, p3);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpq_sub (p1, p2, p3)
	SV *	p1
	SV *	p2
	SV *	p3
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpq_sub(p1, p2, p3);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpq_mul (p1, p2, p3)
	SV *	p1
	SV *	p2
	SV *	p3
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpq_mul(p1, p2, p3);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpq_div (p1, p2, p3)
	SV *	p1
	SV *	p2
	SV *	p3
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpq_div(p1, p2, p3);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpq_mul_2exp (p1, p2, p3)
	SV *	p1
	SV *	p2
	SV *	p3
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpq_mul_2exp(p1, p2, p3);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpq_div_2exp (p1, p2, p3)
	SV *	p1
	SV *	p2
	SV *	p3
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpq_div_2exp(p1, p2, p3);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpq_neg (p1, p2)
	SV *	p1
	SV *	p2
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpq_neg(p1, p2);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpq_abs (p1, p2)
	SV *	p1
	SV *	p2
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpq_abs(p1, p2);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpq_inv (p1, p2)
	SV *	p1
	SV *	p2
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpq_inv(p1, p2);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

SV *
Rmpq_out_str (p, base)
	SV *	p
	SV *	base

SV *
Rmpq_inp_str (p, base)
	SV *	p
	SV *	base

void
Rmpq_numref (z, r)
	SV *	z
	SV *	r
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpq_numref(z, r);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpq_denref (z, r)
	SV *	z
	SV *	r
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpq_denref(z, r);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpq_get_num (z, r)
	SV *	z
	SV *	r
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpq_get_num(z, r);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpq_get_den (z, r)
	SV *	z
	SV *	r
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpq_get_den(z, r);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpq_set_num (r, z)
	SV *	r
	SV *	z
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpq_set_num(r, z);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpq_set_den (r, z)
	SV *	r
	SV *	z
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpq_set_den(r, z);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

SV *
get_refcnt (s)
	SV *	s

SV *
overload_mul (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
overload_mul_eq (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
overload_add (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
overload_add_eq (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
overload_sub (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
overload_sub_eq (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
overload_div (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
overload_div_eq (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
overload_string (p, second, third)
	SV *	p
	SV *	second
	SV *	third

SV *
overload_copy (p, second, third)
	SV *	p
	SV *	second
	SV *	third

SV *
overload_abs (p, second, third)
	SV *	p
	SV *	second
	SV *	third

SV *
overload_gt (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
overload_gte (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
overload_lt (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
overload_lte (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
overload_spaceship (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
overload_equiv (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
overload_not_equiv (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
overload_not (a, second, third)
	SV *	a
	SV *	second
	SV *	third

SV *
gmp_v ()

void
wrap_gmp_printf (a, b)
	SV *	a
	SV *	b
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	wrap_gmp_printf(a, b);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

SV *
_itsa (a)
	SV *	a

