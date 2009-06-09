#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <stdio.h>
#include <stdlib.h>
#include <gmp.h>

#ifdef _MSC_VER
#pragma warning(disable:4700 4715 4716)
#endif

#if defined USE_64_BIT_INT || defined USE_LONG_DOUBLE
#ifndef _MSC_VER
#include <inttypes.h>
#endif
#endif

#ifdef OLDPERL
#define SvUOK SvIsUV
#endif

void Rmpq_canonicalize (mpq_t * p) {
     mpq_canonicalize(*p);
}

SV * Rmpq_init() {
     mpq_t * mpq_t_obj;
     SV * obj_ref, * obj;

     New(1, mpq_t_obj, 1, mpq_t);
     if(mpq_t_obj == NULL) croak("Failed to allocate memory in Rmpq_init function");
     obj_ref = newSV(0);
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
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, NULL);
     mpq_init (*mpq_t_obj);

     sv_setiv(obj, INT2PTR(IV, mpq_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

void DESTROY(mpq_t * p) {
/*     printf("Destroying mpq "); */
     mpq_clear(*p);
     Safefree(p);
/*     printf("...destroyed\n"); */
}

void Rmpq_clear(mpq_t * p) {
     mpq_clear(*p);
     Safefree(p);
}

void Rmpq_clear_mpq(mpq_t * p) {
     mpq_clear(*p);
}

void Rmpq_clear_ptr(mpq_t * p) {
     Safefree(p);
}

void Rmpq_set(mpq_t * p1, mpq_t * p2) {
     mpq_set(*p1, *p2);   
}

void Rmpq_swap(mpq_t * p1, mpq_t * p2) {
     mpq_swap(*p1, *p2);   
}

void Rmpq_set_z(mpq_t * p1, mpz_t * p2) {
     mpq_set_z(*p1, *p2);   
}

void Rmpq_set_ui(mpq_t * p1, SV * p2, SV * p3) {
     mpq_set_ui(*p1, SvUV(p2), SvUV(p3));   
}

void Rmpq_set_si(mpq_t * p1, SV * p2, SV * p3) {
     mpq_set_si(*p1, SvIV(p2), SvIV(p3));   
}

void Rmpq_set_str(mpq_t * p1, SV * p2, SV * base) {
     unsigned long b = SvUV(base);
     if(b == 1 || b > 62) croak ("%u is not a valid base in Rmpq_set_str", b);
     if(mpq_set_str(*p1, SvPV_nolen(p2), SvUV(base)))
       croak("String supplied to Rmpq_set_str function is not a valid base %u number", SvUV(base));   
}


SV * Rmpq_get_d(mpq_t * p) {
     return newSVnv(mpq_get_d(*p));
}

void Rmpq_set_d(mpq_t * p, SV * d){
     mpq_set_d(*p, SvNV(d));
}

void _Rmpq_set_ld(mpq_t * q, SV * p) {
#ifdef USE_LONG_DOUBLE
     char buffer[50];
     int exp, exp2 = 0;
     long double fr;

     fr = frexpl((long double)SvNV(p), &exp);

     while(fr != floorl(fr)) {
          fr *= 2;
          exp2 += 1;
     }

     sprintf(buffer, "%.0Lf", fr);

     mpq_set_str(*q, buffer, 10);

     if (exp2 > exp) mpq_div_2exp(*q, *q, exp2 - exp);
     else mpq_mul_2exp(*q, *q, exp - exp2);
#else
     croak("_Rmpq_set_ld not implemented on this build of perl");
#endif
}

void Rmpq_set_f(mpq_t * p, mpf_t * f) {
     mpq_set_f(*p, *f);
}

SV * Rmpq_get_str(mpq_t * p, SV * base){
     char * out;
     SV * outsv;
     unsigned long b = SvUV(base);

     New(123, out, mpz_sizeinbase(mpq_numref(*p), b) + mpz_sizeinbase(mpq_denref(*p), b) + 3, char);
     if(out == NULL) croak ("Failed to allocate memory in Rmpq_get_str function");

     mpq_get_str(out, b, *p);
     outsv = newSVpv(out, 0);
     Safefree(out);
     return outsv;
}

SV * Rmpq_cmp(mpq_t * p1, mpq_t * p2) {
     return newSViv(mpq_cmp(*p1, *p2));   
}

SV * Rmpq_cmp_ui(mpq_t * p1, SV * n, SV * d) {
     return newSViv(mpq_cmp_ui(*p1, SvUV(n), SvUV(d)));   
}

SV * Rmpq_cmp_si(mpq_t * p1, SV * n, SV * d) {
     return newSViv(mpq_cmp_si(*p1, SvIV(n), SvUV(d)));   
}

SV * Rmpq_sgn(mpq_t * p) {
     return newSViv(mpq_sgn(*p));
}

SV * Rmpq_equal(mpq_t * p1, mpq_t * p2) {
     return newSViv(mpq_equal(*p1, *p2));   
}

void Rmpq_add(mpq_t * p1, mpq_t * p2, mpq_t * p3) {
     mpq_add(*p1, *p2, *p3);   
}

void Rmpq_sub(mpq_t * p1, mpq_t * p2, mpq_t * p3) {
     mpq_sub(*p1, *p2, *p3);   
}

void Rmpq_mul(mpq_t * p1, mpq_t * p2, mpq_t * p3) {
     mpq_mul(*p1, *p2, *p3);   
}

void Rmpq_div(mpq_t * p1, mpq_t * p2, mpq_t * p3) {
     mpq_div(*p1, *p2, *p3);   
}

void Rmpq_mul_2exp(mpq_t * p1, mpq_t * p2, SV * p3) {
     mpq_mul_2exp(*p1, *p2, SvUV(p3));   
}

void Rmpq_div_2exp(mpq_t * p1, mpq_t * p2, SV * p3) {
     mpq_div_2exp(*p1, *p2, SvUV(p3));   
}

void Rmpq_neg(mpq_t * p1, mpq_t * p2) {
     mpq_neg(*p1, *p2);   
}

void Rmpq_abs(mpq_t * p1, mpq_t * p2) {
     mpq_abs(*p1, *p2);   
}

void Rmpq_inv(mpq_t * p1, mpq_t * p2) {
     mpq_inv(*p1, *p2);   
}

SV * _Rmpq_out_str(mpq_t * p, SV *base){
     unsigned long ret;
     if(SvIV(base) < 2 || SvIV(base) > 36)
       croak("2nd argument supplied to Rmpq_out_str is out of allowable range (must be between 2 and 36 inclusive)");
     ret = mpq_out_str(NULL, SvUV(base), *p);
     fflush(stdout);
     return newSVuv(ret);
}

SV * _Rmpq_out_strS(mpq_t * p, SV * base, SV * suff) {
     unsigned long ret;
     if(SvIV(base) < 2 || SvIV(base) > 36)
       croak("2nd argument supplied to Rmpq_out_str is out of allowable range (must be between 2 and 36 inclusive)");
     ret = mpq_out_str(NULL, SvUV(base), *p);
     printf("%s", SvPV_nolen(suff));
     fflush(stdout);
     return newSVuv(ret);
}

SV * _Rmpq_out_strP(SV * pre, mpq_t * p, SV * base) {
     unsigned long ret;
     if(SvIV(base) < 2 || SvIV(base) > 36)
       croak("2nd argument supplied to Rmpq_out_str is out of allowable range (must be between 2 and 36 inclusive)");
     printf("%s", SvPV_nolen(pre));
     ret = mpq_out_str(NULL, SvUV(base), *p);
     fflush(stdout);
     return newSVuv(ret);
}

SV * _Rmpq_out_strPS(SV * pre, mpq_t * p, SV * base, SV * suff) {
     unsigned long ret;
     if(SvIV(base) < 2 || SvIV(base) > 36)
       croak("2nd argument supplied to Rmpq_out_str is out of allowable range (must be between 2 and 36 inclusive)");
     printf("%s", SvPV_nolen(pre));
     ret = mpq_out_str(NULL, SvUV(base), *p);
     printf("%s", SvPV_nolen(suff));
     fflush(stdout);
     return newSVuv(ret);
}



SV * _TRmpq_out_str(FILE * stream, SV * base, mpq_t * p) {
     size_t ret;
     ret = mpq_out_str(stream, (int)SvIV(base), *p);
     fflush(stream);
     return newSVuv(ret);
}

SV * _TRmpq_out_strS(FILE * stream, SV * base, mpq_t * p, SV * suff) {
     size_t ret;
     ret = mpq_out_str(stream, (int)SvIV(base), *p);
     fflush(stream);
     fprintf(stream, "%s", SvPV_nolen(suff));
     fflush(stream);
     return newSVuv(ret);
}

SV * _TRmpq_out_strP(SV * pre, FILE * stream, SV * base, mpq_t * p) {
     size_t ret;
     fprintf(stream, "%s", SvPV_nolen(pre));
     fflush(stream);
     ret = mpq_out_str(stream, (int)SvIV(base), *p);
     fflush(stream);
     return newSVuv(ret);
}

SV * _TRmpq_out_strPS(SV * pre, FILE * stream, SV * base, mpq_t * p, SV * suff) {
     size_t ret;
     fprintf(stream, "%s", SvPV_nolen(pre));
     fflush(stream);
     ret = mpq_out_str(stream, (int)SvIV(base), *p);
     fflush(stream);
     fprintf(stream, "%s", SvPV_nolen(suff));
     fflush(stream);
     return newSVuv(ret);
}

SV * TRmpq_inp_str(mpq_t * p, FILE * stream, SV * base) {
     size_t ret;
     ret = mpq_inp_str(*p, stream, (int)SvIV(base));
     /* fflush(stream); */
     return newSVuv(ret);
}

SV * Rmpq_inp_str(mpq_t * p, SV *base){
     size_t ret;
     ret = mpq_inp_str(*p, NULL, SvUV(base));
     /* fflush(stdin); */
     return newSVuv(ret);
}

void Rmpq_numref(mpz_t * z, mpq_t * r) {
     mpz_set(*z, mpq_numref(*r));
}

void Rmpq_denref(mpz_t * z, mpq_t * r) {
     mpz_set(*z, mpq_denref(*r));
}

void Rmpq_get_num(mpz_t * z, mpq_t * r) {
     mpq_get_num(*z, *r);
}

void Rmpq_get_den(mpz_t * z, mpq_t * r) {
     mpq_get_den(*z, *r);
}

void Rmpq_set_num(mpq_t * r, mpz_t * z) {
     mpq_set_num(*r, *z);
}

void Rmpq_set_den(mpq_t * r, mpz_t * z) {
     mpq_set_den(*r, *z);
}

SV * get_refcnt(SV * s) {
     return newSVuv(SvREFCNT(s));
}

/* Finish typemapping - typemap 1st arg only */

SV * overload_mul(mpq_t * a, SV * b, SV * third) {
     mpq_t * mpq_t_obj;
     SV * obj_ref, * obj;

     New(1, mpq_t_obj, 1, mpq_t);
     if(mpq_t_obj == NULL) croak("Failed to allocate memory in overload_mul function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::GMPq");
     mpq_init(*mpq_t_obj);
     sv_setiv(obj, INT2PTR(IV, mpq_t_obj));
     SvREADONLY_on(obj);

#ifndef USE_64_BIT_INT
     if(SvIOK(b)) {
       mpq_set_d(*mpq_t_obj, SvNV(b));
       mpq_mul(*mpq_t_obj, *a, *mpq_t_obj);
       return obj_ref;
       }
#else
     if(SvIOK(b)) {
       if(mpq_set_str(*mpq_t_obj, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_mul");
       mpq_mul(*mpq_t_obj, *a, *mpq_t_obj);
       return obj_ref;
       }
#endif

     if(SvNOK(b)) {
#ifdef USE_LONG_DOUBLE
       _Rmpq_set_ld(mpq_t_obj, b);
#else
       mpq_set_d(*mpq_t_obj, SvNV(b));
#endif
       mpq_mul(*mpq_t_obj, *a, *mpq_t_obj);
       return obj_ref;
       }

     if(SvPOK(b)) {
       if(mpq_set_str(*mpq_t_obj, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_mul");
       mpq_canonicalize(*mpq_t_obj);
       mpq_mul(*mpq_t_obj, *a, *mpq_t_obj);
       return obj_ref;
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq")) {
         mpq_mul(*mpq_t_obj, *a, *(INT2PTR(mpq_t *, SvIV(SvRV(b)))));
         return obj_ref;
         }
       }

     croak("Invalid argument supplied to Math::GMPq::overload_mul");
}

SV * overload_add(mpq_t * a, SV * b, SV * third) {
     mpq_t * mpq_t_obj;
     SV * obj_ref, * obj;

     New(1, mpq_t_obj, 1, mpq_t);
     if(mpq_t_obj == NULL) croak("Failed to allocate memory in overload_add function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::GMPq");
     mpq_init(*mpq_t_obj);
     sv_setiv(obj, INT2PTR(IV, mpq_t_obj));
     SvREADONLY_on(obj);

#ifndef USE_64_BIT_INT
     if(SvIOK(b)) {
       mpq_set_d(*mpq_t_obj, SvNV(b));
       mpq_add(*mpq_t_obj, *a, *mpq_t_obj);
       return obj_ref;
       }
#else
     if(SvIOK(b)) {
       if(mpq_set_str(*mpq_t_obj, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_add");
       mpq_add(*mpq_t_obj, *a, *mpq_t_obj);
       return obj_ref;
       }
#endif

     if(SvNOK(b)) {
#ifdef USE_LONG_DOUBLE
       _Rmpq_set_ld(mpq_t_obj, b);
#else
       mpq_set_d(*mpq_t_obj, SvNV(b));
#endif
       mpq_add(*mpq_t_obj, *a, *mpq_t_obj);
       return obj_ref;
       }


     if(SvPOK(b)) {
       if(mpq_set_str(*mpq_t_obj, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_add");
       mpq_canonicalize(*mpq_t_obj);
       mpq_add(*mpq_t_obj, *a, *mpq_t_obj);
       return obj_ref;
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq")) {
         mpq_add(*mpq_t_obj, *a, *(INT2PTR(mpq_t *, SvIV(SvRV(b)))));
         return obj_ref;
         }
       }

     croak("Invalid argument supplied to Math::GMPq::overload_add");
}

SV * overload_sub(mpq_t * a, SV * b, SV * third) {
     mpq_t * mpq_t_obj;
     SV * obj_ref, * obj;

     New(1, mpq_t_obj, 1, mpq_t);
     if(mpq_t_obj == NULL) croak("Failed to allocate memory in overload_sub function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::GMPq");
     mpq_init(*mpq_t_obj);
     sv_setiv(obj, INT2PTR(IV, mpq_t_obj));
     SvREADONLY_on(obj);

#ifndef USE_64_BIT_INT
     if(SvIOK(b)) {
       mpq_set_d(*mpq_t_obj, SvNV(b));
       if(third == &PL_sv_yes) mpq_sub(*mpq_t_obj, *mpq_t_obj, *a);
       else mpq_sub(*mpq_t_obj, *a, *mpq_t_obj);
       return obj_ref;
       }
#else
     if(SvIOK(b)) {
       if(mpq_set_str(*mpq_t_obj, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_sub");
       if(third == &PL_sv_yes) mpq_sub(*mpq_t_obj, *mpq_t_obj, *a);
       else mpq_sub(*mpq_t_obj, *a, *mpq_t_obj);
       return obj_ref;
       }
#endif

     if(SvNOK(b)) {
#ifdef USE_LONG_DOUBLE
       _Rmpq_set_ld(mpq_t_obj, b);
#else
       mpq_set_d(*mpq_t_obj, SvNV(b));
#endif
       if(third == &PL_sv_yes) mpq_sub(*mpq_t_obj, *mpq_t_obj, *a);
       else mpq_sub(*mpq_t_obj, *a, *mpq_t_obj);
       return obj_ref;
       }

     if(SvPOK(b)) {
       if(mpq_set_str(*mpq_t_obj, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_sub");
       mpq_canonicalize(*mpq_t_obj);
       if(third == &PL_sv_yes) mpq_sub(*mpq_t_obj, *mpq_t_obj, *a);
       else mpq_sub(*mpq_t_obj, *a, *mpq_t_obj);
       return obj_ref;
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq")) {
         mpq_sub(*mpq_t_obj, *a, *(INT2PTR(mpq_t *, SvIV(SvRV(b)))));
         return obj_ref;
         }
       }

     croak("Invalid argument supplied to Math::GMPq::overload_sub function");

}

SV * overload_div(mpq_t * a, SV * b, SV * third) {
     mpq_t * mpq_t_obj;
     SV * obj_ref, * obj;

     New(1, mpq_t_obj, 1, mpq_t);
     if(mpq_t_obj == NULL) croak("Failed to allocate memory in overload_div function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::GMPq");
     mpq_init(*mpq_t_obj);
     sv_setiv(obj, INT2PTR(IV, mpq_t_obj));
     SvREADONLY_on(obj);

#ifndef USE_64_BIT_INT
     if(SvIOK(b)) {
       mpq_set_d(*mpq_t_obj, SvNV(b));
       if(third == &PL_sv_yes) mpq_div(*mpq_t_obj, *mpq_t_obj, *a);
       else mpq_div(*mpq_t_obj, *a, *mpq_t_obj);
       return obj_ref;
       }
#else
     if(SvIOK(b)) {
       if(mpq_set_str(*mpq_t_obj, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_div");
       if(third == &PL_sv_yes) mpq_div(*mpq_t_obj, *mpq_t_obj, *a);
       else mpq_div(*mpq_t_obj, *a, *mpq_t_obj);
       return obj_ref;
       }
#endif

     if(SvNOK(b)) {
#ifdef USE_LONG_DOUBLE
       _Rmpq_set_ld(mpq_t_obj, b);
#else
       mpq_set_d(*mpq_t_obj, SvNV(b));
#endif
       if(third == &PL_sv_yes) mpq_div(*mpq_t_obj, *mpq_t_obj, *a);
       else mpq_div(*mpq_t_obj, *a, *mpq_t_obj);
       return obj_ref;
       }


     if(SvPOK(b)) {
       if(mpq_set_str(*mpq_t_obj, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_div");
       mpq_canonicalize(*mpq_t_obj);
       if(third == &PL_sv_yes) mpq_div(*mpq_t_obj, *mpq_t_obj, *a);
       else mpq_div(*mpq_t_obj, *a, *mpq_t_obj);
       return obj_ref;
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq")) {
         mpq_div(*mpq_t_obj, *a, *(INT2PTR(mpq_t *, SvIV(SvRV(b)))));
         return obj_ref;
         }
       }

     croak("Invalid argument supplied to Math::GMPq::overload_div function");

}

SV * overload_string(mpq_t * p, SV * second, SV * third) {
     char * out;
     SV * outsv;

     New(123, out, mpz_sizeinbase(mpq_numref(*p), 10) + mpz_sizeinbase(mpq_denref(*p), 10) + 3, char);
     if(out == NULL) croak ("Failed to allocate memory in overload_string function");

     mpq_get_str(out, 10, *p);
     outsv = newSVpv(out, 0);
     Safefree(out);
     return outsv;
}

SV * overload_copy(mpq_t * p, SV * second, SV * third) {
     mpq_t * mpq_t_obj;
     SV * obj_ref, * obj;

     New(1, mpq_t_obj, 1, mpq_t);
     if(mpq_t_obj == NULL) croak("Failed to allocate memory in overload_copy function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::GMPq");

     mpq_init(*mpq_t_obj);
     mpq_set(*mpq_t_obj, *p);
     sv_setiv(obj, INT2PTR(IV, mpq_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * overload_abs(mpq_t * p, SV * second, SV * third) {
     mpq_t * mpq_t_obj;
     SV * obj_ref, * obj;

     New(1, mpq_t_obj, 1, mpq_t);
     if(mpq_t_obj == NULL) croak("Failed to allocate memory in overload_abs function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::GMPq");
     mpq_init(*mpq_t_obj);

     mpq_abs(*mpq_t_obj, *p);
     sv_setiv(obj, INT2PTR(IV, mpq_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * overload_gt(mpq_t * a, SV * b, SV * third) {
     mpq_t t;
     int ret;

#ifdef USE_64_BIT_INT
     if(SvIOK(b)) {
       mpq_init(t);
       if(mpq_set_str(t, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_gt");
       ret = mpq_cmp(*a, t);
       mpq_clear(t);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret > 0) return newSViv(1);
       return newSViv(0);
       }
#else
     if(SvUOK(b)) {
       ret = mpq_cmp_ui(*a, SvUV(b), 1);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret > 0) return newSViv(1);
       return newSViv(0);
       }

     if(SvIOK(b)) {
       ret = mpq_cmp_si(*a, SvIV(b), 1);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret > 0) return newSViv(1);
       return newSViv(0);
       }
#endif

     if(SvNOK(b)) {
       mpq_init(t);
#ifdef USE_LONG_DOUBLE
       _Rmpq_set_ld(&t, b);
#else
       mpq_set_d(t, SvNV(b));
#endif
       ret = mpq_cmp(*a, t);
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
       ret = mpq_cmp(*a, t);
       mpq_clear(t);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret > 0) return newSViv(1);
       return newSViv(0);
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq")) {
         ret = mpq_cmp(*a, *(INT2PTR(mpq_t *, SvIV(SvRV(b)))));
         if(ret > 0) return newSViv(1);
         return newSViv(0);
         }
       }

     croak("Invalid argument supplied to Math::GMPq::overload_gt");
}

SV * overload_gte(mpq_t * a, SV * b, SV * third) {
     mpq_t t;
     int ret;

#ifdef USE_64_BIT_INT
     if(SvIOK(b)) {
       mpq_init(t);
       if(mpq_set_str(t, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_gte");
       ret = mpq_cmp(*a, t);
       mpq_clear(t);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret >= 0) return newSViv(1);
       return newSViv(0);
       }
#else
     if(SvUOK(b)) {
       ret = mpq_cmp_ui(*a, SvUV(b), 1);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret >= 0) return newSViv(1);
       return newSViv(0);
       }

     if(SvIOK(b)) {
       ret = mpq_cmp_si(*a, SvIV(b), 1);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret >= 0) return newSViv(1);
       return newSViv(0);
       }
#endif

     if(SvNOK(b)) {
       mpq_init(t);
#ifdef USE_LONG_DOUBLE
       _Rmpq_set_ld(&t, b);
#else
       mpq_set_d(t, SvNV(b));
#endif
       ret = mpq_cmp(*a, t);
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
       ret = mpq_cmp(*a, t);
       mpq_clear(t);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret >= 0) return newSViv(1);
       return newSViv(0);
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq")) {
         ret = mpq_cmp(*a, *(INT2PTR(mpq_t *, SvIV(SvRV(b)))));
         if(ret >= 0) return newSViv(1);
         return newSViv(0);
         }
       }

     croak("Invalid argument supplied to Math::GMPq::overload_gte");
}

SV * overload_lt(mpq_t * a, SV * b, SV * third) {
     mpq_t t;
     int ret;

#ifdef USE_64_BIT_INT
     if(SvIOK(b)) {
       mpq_init(t);
       if(mpq_set_str(t, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_lt");
       ret = mpq_cmp(*a, t);
       mpq_clear(t);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret < 0) return newSViv(1);
       return newSViv(0);
       }
#else
     if(SvUOK(b)) {
       ret = mpq_cmp_ui(*a, SvUV(b), 1);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret < 0) return newSViv(1);
       return newSViv(0);
       }

     if(SvIOK(b)) {
       ret = mpq_cmp_si(*a, SvIV(b), 1);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret < 0) return newSViv(1);
       return newSViv(0);
       }
#endif

     if(SvNOK(b)) {
       mpq_init(t);
#ifdef USE_LONG_DOUBLE
       _Rmpq_set_ld(&t, b);
#else
       mpq_set_d(t, SvNV(b));
#endif
       ret = mpq_cmp(*a, t);
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
       ret = mpq_cmp(*a, t);
       mpq_clear(t);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret < 0) return newSViv(1);
       return newSViv(0);
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq")) {
         ret = mpq_cmp(*a, *(INT2PTR(mpq_t *, SvIV(SvRV(b)))));
         if(ret < 0) return newSViv(1);
         return newSViv(0);
         }
       }

     croak("Invalid argument supplied to Math::GMPq::overload_lt");
}

SV * overload_lte(mpq_t * a, SV * b, SV * third) {
     mpq_t t;
     int ret;

#ifdef USE_64_BIT_INT
     if(SvIOK(b)) {
       mpq_init(t);
       if(mpq_set_str(t, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_lte");
       ret = mpq_cmp(*a, t);
       mpq_clear(t);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret <= 0) return newSViv(1);
       return newSViv(0);
       }
#else
     if(SvUOK(b)) {
       ret = mpq_cmp_ui(*a, SvUV(b), 1);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret <= 0) return newSViv(1);
       return newSViv(0);
       }

     if(SvIOK(b)) {
       ret = mpq_cmp_si(*a, SvIV(b), 1);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret <= 0) return newSViv(1);
       return newSViv(0);
       }
#endif

     if(SvNOK(b)) {
       mpq_init(t);
#ifdef USE_LONG_DOUBLE
       _Rmpq_set_ld(&t, b);
#else
       mpq_set_d(t, SvNV(b));
#endif
       ret = mpq_cmp(*a, t);
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
       ret = mpq_cmp(*a, t);
       mpq_clear(t);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret <= 0) return newSViv(1);
       return newSViv(0);
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq")) {
         ret = mpq_cmp(*a, *(INT2PTR(mpq_t *, SvIV(SvRV(b)))));
         if(ret <= 0) return newSViv(1);
         return newSViv(0);
         }
       }

     croak("Invalid argument supplied to Math::GMPq::overload_lte");
}

SV * overload_spaceship(mpq_t * a, SV * b, SV * third) {
     mpq_t t;
     int ret;

#ifdef USE_64_BIT_INT
     if(SvIOK(b)) {
       mpq_init(t);
       if(mpq_set_str(t, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_spaceship");
       ret = mpq_cmp(*a, t);
       mpq_clear(t);
       if(third == &PL_sv_yes) ret *= -1;
       return newSViv(ret);
       }
#else
     if(SvUOK(b)) {
       ret = mpq_cmp_ui(*a, SvUV(b), 1);
       if(third == &PL_sv_yes) ret *= -1;
       return newSViv(ret);
       }

     if(SvIOK(b)) {
       ret = mpq_cmp_si(*a, SvIV(b), 1);
       if(third == &PL_sv_yes) ret *= -1;
       return newSViv(ret);
       }
#endif

     if(SvNOK(b)) {
       mpq_init(t);
#ifdef USE_LONG_DOUBLE
       _Rmpq_set_ld(&t, b);
#else
       mpq_set_d(t, SvNV(b));
#endif
       ret = mpq_cmp(*a, t);
       mpq_clear(t);
       if(third == &PL_sv_yes) ret *= -1;
       return newSViv(ret);
       }

     if(SvPOK(b)) {
       mpq_init(t);
       if(mpq_set_str(t, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_spaceship");
       mpq_canonicalize(t);
       ret = mpq_cmp(*a, t);
       mpq_clear(t);
       if(third == &PL_sv_yes) ret *= -1;
       return newSViv(ret);
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq")) {
         ret = mpq_cmp(*a, *(INT2PTR(mpq_t *, SvIV(SvRV(b)))));
         return newSViv(ret);
         }
       }

     croak("Invalid argument supplied to Math::GMPq::overload_spaceship");
}

SV * overload_equiv(mpq_t * a, SV * b, SV * third) {
     mpq_t t;
     int ret;



#ifdef USE_64_BIT_INT
     if(SvIOK(b)) {
       mpq_init(t);
       if(mpq_set_str(t, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_equiv");
       ret = mpq_cmp(*a, t);
       mpq_clear(t);
       if(ret == 0) return newSViv(1);
       return newSViv(0);
       }
#else
     if(SvUOK(b)) {
       ret = mpq_cmp_ui(*a, SvUV(b), 1);
       if(ret == 0) return newSViv(1);
       return newSViv(0);
       }

     if(SvIOK(b)) {
       ret = mpq_cmp_si(*a, SvIV(b), 1);
       if(ret == 0) return newSViv(1);
       return newSViv(0);
       }
#endif

     if(SvNOK(b)) {
       mpq_init(t);
#ifdef USE_LONG_DOUBLE
       _Rmpq_set_ld(&t, b);
#else
       mpq_set_d(t, SvNV(b));
#endif
       ret = mpq_cmp(*a, t);
       mpq_clear(t);
       if(ret == 0) return newSViv(1);
       return newSViv(0);
       }

     if(SvPOK(b)) {
       mpq_init(t);
       if(mpq_set_str(t, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_equiv");
       mpq_canonicalize(t);
       ret = mpq_cmp(*a, t);
       mpq_clear(t);
       if(ret == 0) return newSViv(1);
       return newSViv(0);
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq")) {
         ret = mpq_cmp(*a, *(INT2PTR(mpq_t *, SvIV(SvRV(b)))));
         if(ret == 0) return newSViv(1);
         return newSViv(0);
         }
       }

     croak("Invalid argument supplied to Math::GMPq::overload_equiv");
}

SV * overload_not_equiv(mpq_t * a, SV * b, SV * third) {
     mpq_t t;
     int ret;

#ifdef USE_64_BIT_INT
     if(SvIOK(b)) {
       mpq_init(t);
       if(mpq_set_str(t, SvPV_nolen(b), 0))
         croak("Invalid string supplied to Math::GMPq::overload_not_equiv");
       ret = mpq_cmp(*a, t);
       mpq_clear(t);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret != 0) return newSViv(1);
       return newSViv(0);
       }
#else
     if(SvUOK(b)) {
       ret = mpq_cmp_ui(*a, SvUV(b), 1);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret != 0) return newSViv(1);
       return newSViv(0);
       }

     if(SvIOK(b)) {
       ret = mpq_cmp_si(*a, SvIV(b), 1);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret != 0) return newSViv(1);
       return newSViv(0);
       }
#endif

     if(SvNOK(b)) {
       mpq_init(t);
#ifdef USE_LONG_DOUBLE
       _Rmpq_set_ld(&t, b);
#else
       mpq_set_d(t, SvNV(b));
#endif
       ret = mpq_cmp(*a, t);
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
       ret = mpq_cmp(*a, t);
       mpq_clear(t);
       if(third == &PL_sv_yes) ret *= -1;
       if(ret != 0) return newSViv(1);
       return newSViv(0);
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq")) {
         ret = mpq_cmp(*a, *(INT2PTR(mpq_t *, SvIV(SvRV(b)))));
         if(ret != 0) return newSViv(1);
         return newSViv(0);
         }
       }

     croak("Invalid argument supplied to Math::GMPq::overload_not_equiv");
}

SV * overload_not(mpq_t * a, SV * second, SV * third) {
     if(mpq_cmp_ui(*a, 0, 1)) return newSViv(0);
     return newSViv(1);
}

SV * overload_int(mpq_t * p, SV * second, SV * third) {
     mpz_t z_num, z_den;
     mpq_t * mpq_t_obj;
     SV * obj_ref, * obj;

     New(1, mpq_t_obj, 1, mpq_t);
     if(mpq_t_obj == NULL) croak("Failed to allocate memory in overload_int function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::GMPq");
     mpq_init(*mpq_t_obj);

     mpz_init(z_num);
     mpz_init(z_den);

     mpz_set(z_num, mpq_numref(*p));
     mpz_set(z_den, mpq_denref(*p));

     mpz_tdiv_q(z_num, z_num, z_den);
     mpq_set_z(*mpq_t_obj, z_num);

     sv_setiv(obj, INT2PTR(IV, mpq_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

/* Finish typemapping */

SV * overload_mul_eq(SV * a, SV * b, SV * third) {
     mpq_t t;

     SvREFCNT_inc(a);

#ifndef USE_64_BIT_INT
     if(SvIOK(b)) {
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
#endif

     if(SvNOK(b)) {
       mpq_init(t);
#ifdef USE_LONG_DOUBLE
       _Rmpq_set_ld(&t, b);
#else
       mpq_set_d(t, SvNV(b));
#endif
       mpq_mul(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       return a;
       }

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

SV * overload_add_eq(SV * a, SV * b, SV * third) {
     mpq_t t;

     SvREFCNT_inc(a);

#ifndef USE_64_BIT_INT
     if(SvIOK(b)) {
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
#endif

     if(SvNOK(b)) {
       mpq_init(t);
#ifdef USE_LONG_DOUBLE
       _Rmpq_set_ld(&t, b);
#else
       mpq_set_d(t, SvNV(b));
#endif
       mpq_add(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       return a;
       }

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

SV * overload_sub_eq(SV * a, SV * b, SV * third) {
     mpq_t t;

     SvREFCNT_inc(a);

#ifndef USE_64_BIT_INT
     if(SvIOK(b)) {
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
#endif

     if(SvNOK(b)) {
       mpq_init(t);
#ifdef USE_LONG_DOUBLE
       _Rmpq_set_ld(&t, b);
#else
       mpq_set_d(t, SvNV(b));
#endif
       mpq_sub(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       return a;
       }

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

SV * overload_div_eq(SV * a, SV * b, SV * third) {
     mpq_t t;

     SvREFCNT_inc(a);

#ifndef USE_64_BIT_INT
     if(SvIOK(b)) {
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
#endif

     if(SvNOK(b)) {
       mpq_init(t);
#ifdef USE_LONG_DOUBLE
       _Rmpq_set_ld(&t, b);
#else
       mpq_set_d(t, SvNV(b));
#endif
       mpq_div(*(INT2PTR(mpq_t *, SvIV(SvRV(a)))), *(INT2PTR(mpq_t *, SvIV(SvRV(a)))), t);
       mpq_clear(t);
       return a;
       }

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

SV * gmp_v() {
     return newSVpv(gmp_version, 0);
}

SV * wrap_gmp_printf(SV * a, SV * b) {
     int ret;
     if(sv_isobject(b)) { 
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPz") ||
         strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMP") ||
         strEQ(HvNAME(SvSTASH(SvRV(b))), "GMP::Mpz")) {
         ret = gmp_printf(SvPV_nolen(a), *(INT2PTR(mpz_t *, SvIV(SvRV(b)))));
         fflush(stdout);
         return newSViv(ret);
       }
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq") ||
         strEQ(HvNAME(SvSTASH(SvRV(b))), "GMP::Mpq")) {
         ret = gmp_printf(SvPV_nolen(a), *(INT2PTR(mpq_t *, SvIV(SvRV(b)))));
         fflush(stdout);
         return newSViv(ret);
       }
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPf") ||
         strEQ(HvNAME(SvSTASH(SvRV(b))), "GMP::Mpf")) {
         ret = gmp_printf(SvPV_nolen(a), *(INT2PTR(mpf_t *, SvIV(SvRV(b)))));
         fflush(stdout);
         return newSViv(ret);
       }
   
       croak("Unrecognised object supplied as argument to Rmpq_printf");
     } 

     if(SvUOK(b)) {
       ret = gmp_printf(SvPV_nolen(a), SvUV(b));
       fflush(stdout);
       return newSViv(ret);
     }
     if(SvIOK(b)) {
       ret = gmp_printf(SvPV_nolen(a), SvIV(b));
       fflush(stdout);
       return newSViv(ret);
     }
     if(SvNOK(b)) {
       ret = gmp_printf(SvPV_nolen(a), SvNV(b));
       fflush(stdout);
       return newSViv(ret);
     }
     if(SvPOK(b)) {
       ret = gmp_printf(SvPV_nolen(a), SvPV_nolen(b));
       fflush(stdout);
       return newSViv(ret);
     }
  
     croak("Unrecognised type supplied as argument to Rmpq_printf");
}

SV * wrap_gmp_fprintf(FILE * stream, SV * a, SV * b) {
     int ret;
     if(sv_isobject(b)) { 
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPz") ||
         strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMP") ||
         strEQ(HvNAME(SvSTASH(SvRV(b))), "GMP::Mpz")) {
         ret = gmp_fprintf(stream, SvPV_nolen(a), *(INT2PTR(mpz_t *, SvIV(SvRV(b)))));
         fflush(stream);
         return newSViv(ret);
       }
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq") ||
         strEQ(HvNAME(SvSTASH(SvRV(b))), "GMP::Mpq")) {
         ret = gmp_fprintf(stream, SvPV_nolen(a), *(INT2PTR(mpq_t *, SvIV(SvRV(b)))));
         fflush(stream);
         return newSViv(ret);
       }
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPf") ||
         strEQ(HvNAME(SvSTASH(SvRV(b))), "GMP::Mpf")) {
         ret = gmp_fprintf(stream, SvPV_nolen(a), *(INT2PTR(mpf_t *, SvIV(SvRV(b)))));
         fflush(stream);
         return newSViv(ret);
       }
 
       else croak("Unrecognised object supplied as argument to Rmpq_fprintf");
     } 

     if(SvUOK(b)) {
       ret = gmp_fprintf(stream, SvPV_nolen(a), SvUV(b));
       fflush(stream);
       return newSViv(ret);
     }
     if(SvIOK(b)) {
       ret = gmp_fprintf(stream, SvPV_nolen(a), SvIV(b));
       fflush(stream);
       return newSViv(ret);
     }
     if(SvNOK(b)) {
       ret = gmp_fprintf(stream, SvPV_nolen(a), SvNV(b));
       fflush(stream);
       return newSViv(ret);
     }
     if(SvPOK(b)) {
       ret = gmp_fprintf(stream, SvPV_nolen(a), SvPV_nolen(b));
       fflush(stream);
       return newSViv(ret);
     }

     croak("Unrecognised type supplied as argument to Rmpq_fprintf");
}

SV * wrap_gmp_sprintf(char * stream, SV * a, SV * b) {
     int ret;
     if(sv_isobject(b)) { 
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPz") ||
         strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMP") ||
         strEQ(HvNAME(SvSTASH(SvRV(b))), "GMP::Mpz")) {
         ret = gmp_sprintf(stream, SvPV_nolen(a), *(INT2PTR(mpz_t *, SvIV(SvRV(b)))));
         return newSViv(ret);
       }

       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq") ||
         strEQ(HvNAME(SvSTASH(SvRV(b))), "GMP::Mpq")) {
         ret = gmp_sprintf(stream, SvPV_nolen(a), *(INT2PTR(mpq_t *, SvIV(SvRV(b)))));
         return newSViv(ret);
       }

       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPf") ||
         strEQ(HvNAME(SvSTASH(SvRV(b))), "GMP::Mpf")) {
         ret = gmp_sprintf(stream, SvPV_nolen(a), *(INT2PTR(mpf_t *, SvIV(SvRV(b)))));
         return newSViv(ret);
       }

       croak("Unrecognised object supplied as argument to Rmpq_sprintf");
     } 

     if(SvUOK(b)) {
       ret = gmp_sprintf(stream, SvPV_nolen(a), SvUV(b));
       return newSViv(ret);
     }

     if(SvIOK(b)) {
       ret = gmp_sprintf(stream, SvPV_nolen(a), SvIV(b));
       return newSViv(ret);
     }

     if(SvNOK(b)) {
       ret = gmp_sprintf(stream, SvPV_nolen(a), SvNV(b));
       return newSViv(ret);
     }

     if(SvPOK(b)) {
       ret = gmp_sprintf(stream, SvPV_nolen(a), SvPV_nolen(b));
       return newSViv(ret);
     }

     croak("Unrecognised type supplied as argument to Rmpq_sprintf");
}

SV * _itsa(SV * a) {
     if(SvUOK(a)) return newSVuv(1);
     if(SvIOK(a)) return newSVuv(2);
     if(SvNOK(a)) return newSVuv(3);
     if(SvPOK(a)) return newSVuv(4);
     if(sv_isobject(a)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(a))), "Math::GMPq")) return newSVuv(7);
       }
     return newSVuv(0);
}

int _has_longlong() {
#ifdef USE_64_BIT_INT
    return 1;
#else
    return 0;
#endif
}

int _has_longdouble() {
#ifdef USE_LONG_DOUBLE
    return 1;
#else
    return 0;
#endif
}

/* Has inttypes.h been included ? */
int _has_inttypes() {
#ifdef _MSC_VER
return 0;
#else
#if defined USE_64_BIT_INT || defined USE_LONG_DOUBLE
return 1;
#else
return 0;
#endif
#endif
}

SV * ___GNU_MP_VERSION() {
     return newSVuv(__GNU_MP_VERSION);
}

SV * ___GNU_MP_VERSION_MINOR() {
     return newSVuv(__GNU_MP_VERSION_MINOR);
}

SV * ___GNU_MP_VERSION_PATCHLEVEL() {
     return newSVuv(__GNU_MP_VERSION_PATCHLEVEL);
}

SV * ___GMP_CC() {
#ifdef __GMP_CC
     char * ret = __GMP_CC;
     return newSVpv(ret, 0);
#else
     return &PL_sv_undef;
#endif
}

SV * ___GMP_CFLAGS() {
#ifdef __GMP_CFLAGS
     char * ret = __GMP_CFLAGS;
     return newSVpv(ret, 0);
#else
     return &PL_sv_undef;
#endif
}


MODULE = Math::GMPq	PACKAGE = Math::GMPq	

PROTOTYPES: DISABLE


void
Rmpq_canonicalize (p)
	mpq_t *	p
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
	mpq_t *	p
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
	mpq_t *	p
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
	mpq_t *	p
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
	mpq_t *	p
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
	mpq_t *	p1
	mpq_t *	p2
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
	mpq_t *	p1
	mpq_t *	p2
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
	mpq_t *	p1
	mpz_t *	p2
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
	mpq_t *	p1
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
	mpq_t *	p1
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
	mpq_t *	p1
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
	mpq_t *	p

void
Rmpq_set_d (p, d)
	mpq_t *	p
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
_Rmpq_set_ld (q, p)
	mpq_t *	q
	SV *	p
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	_Rmpq_set_ld(q, p);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpq_set_f (p, f)
	mpq_t *	p
	mpf_t *	f
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
	mpq_t *	p
	SV *	base

SV *
Rmpq_cmp (p1, p2)
	mpq_t *	p1
	mpq_t *	p2

SV *
Rmpq_cmp_ui (p1, n, d)
	mpq_t *	p1
	SV *	n
	SV *	d

SV *
Rmpq_cmp_si (p1, n, d)
	mpq_t *	p1
	SV *	n
	SV *	d

SV *
Rmpq_sgn (p)
	mpq_t *	p

SV *
Rmpq_equal (p1, p2)
	mpq_t *	p1
	mpq_t *	p2

void
Rmpq_add (p1, p2, p3)
	mpq_t *	p1
	mpq_t *	p2
	mpq_t *	p3
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
	mpq_t *	p1
	mpq_t *	p2
	mpq_t *	p3
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
	mpq_t *	p1
	mpq_t *	p2
	mpq_t *	p3
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
	mpq_t *	p1
	mpq_t *	p2
	mpq_t *	p3
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
	mpq_t *	p1
	mpq_t *	p2
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
	mpq_t *	p1
	mpq_t *	p2
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
	mpq_t *	p1
	mpq_t *	p2
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
	mpq_t *	p1
	mpq_t *	p2
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
	mpq_t *	p1
	mpq_t *	p2
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
_Rmpq_out_str (p, base)
	mpq_t *	p
	SV *	base

SV *
_Rmpq_out_strS (p, base, suff)
	mpq_t *	p
	SV *	base
	SV *	suff

SV *
_Rmpq_out_strP (pre, p, base)
	SV *	pre
	mpq_t *	p
	SV *	base

SV *
_Rmpq_out_strPS (pre, p, base, suff)
	SV *	pre
	mpq_t *	p
	SV *	base
	SV *	suff

SV *
_TRmpq_out_str (stream, base, p)
	FILE *	stream
	SV *	base
	mpq_t *	p

SV *
_TRmpq_out_strS (stream, base, p, suff)
	FILE *	stream
	SV *	base
	mpq_t *	p
	SV *	suff

SV *
_TRmpq_out_strP (pre, stream, base, p)
	SV *	pre
	FILE *	stream
	SV *	base
	mpq_t *	p

SV *
_TRmpq_out_strPS (pre, stream, base, p, suff)
	SV *	pre
	FILE *	stream
	SV *	base
	mpq_t *	p
	SV *	suff

SV *
TRmpq_inp_str (p, stream, base)
	mpq_t *	p
	FILE *	stream
	SV *	base

SV *
Rmpq_inp_str (p, base)
	mpq_t *	p
	SV *	base

void
Rmpq_numref (z, r)
	mpz_t *	z
	mpq_t *	r
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
	mpz_t *	z
	mpq_t *	r
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
	mpz_t *	z
	mpq_t *	r
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
	mpz_t *	z
	mpq_t *	r
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
	mpq_t *	r
	mpz_t *	z
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
	mpq_t *	r
	mpz_t *	z
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
	mpq_t *	a
	SV *	b
	SV *	third

SV *
overload_add (a, b, third)
	mpq_t *	a
	SV *	b
	SV *	third

SV *
overload_sub (a, b, third)
	mpq_t *	a
	SV *	b
	SV *	third

SV *
overload_div (a, b, third)
	mpq_t *	a
	SV *	b
	SV *	third

SV *
overload_string (p, second, third)
	mpq_t *	p
	SV *	second
	SV *	third

SV *
overload_copy (p, second, third)
	mpq_t *	p
	SV *	second
	SV *	third

SV *
overload_abs (p, second, third)
	mpq_t *	p
	SV *	second
	SV *	third

SV *
overload_gt (a, b, third)
	mpq_t *	a
	SV *	b
	SV *	third

SV *
overload_gte (a, b, third)
	mpq_t *	a
	SV *	b
	SV *	third

SV *
overload_lt (a, b, third)
	mpq_t *	a
	SV *	b
	SV *	third

SV *
overload_lte (a, b, third)
	mpq_t *	a
	SV *	b
	SV *	third

SV *
overload_spaceship (a, b, third)
	mpq_t *	a
	SV *	b
	SV *	third

SV *
overload_equiv (a, b, third)
	mpq_t *	a
	SV *	b
	SV *	third

SV *
overload_not_equiv (a, b, third)
	mpq_t *	a
	SV *	b
	SV *	third

SV *
overload_not (a, second, third)
	mpq_t *	a
	SV *	second
	SV *	third

SV *
overload_int (p, second, third)
	mpq_t *	p
	SV *	second
	SV *	third

SV *
overload_mul_eq (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
overload_add_eq (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
overload_sub_eq (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
overload_div_eq (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
gmp_v ()

SV *
wrap_gmp_printf (a, b)
	SV *	a
	SV *	b

SV *
wrap_gmp_fprintf (stream, a, b)
	FILE *	stream
	SV *	a
	SV *	b

SV *
wrap_gmp_sprintf (stream, a, b)
	char *	stream
	SV *	a
	SV *	b

SV *
_itsa (a)
	SV *	a

int
_has_longlong ()

int
_has_longdouble ()

int
_has_inttypes ()

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

