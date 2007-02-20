    package Math::GMPq;
    use strict;
    require Exporter;
    *import = \&Exporter::import;
    require DynaLoader;

use overload
    '+'    => \&overload_add,
    '-'    => \&overload_sub,
    '*'    => \&overload_mul,
    '/'    => \&overload_div,
    '+='   => \&overload_add_eq,
    '-='   => \&overload_sub_eq,
    '*='   => \&overload_mul_eq,
    '/='   => \&overload_div_eq,
    '""'   => \&overload_string,
    '>'    => \&overload_gt,
    '>='   => \&overload_gte,
    '<'    => \&overload_lt,
    '<='   => \&overload_lte,
    '<=>'  => \&overload_spaceship,
    '=='   => \&overload_equiv,
    '!='   => \&overload_not_equiv,
    '!'    => \&overload_not,
    'not'  => \&overload_not,
    '='    => \&overload_copy,
    'abs'  => \&overload_abs;

    @Math::GMPq::ISA = qw(Exporter DynaLoader);
    @Math::GMPq::EXPORT_OK = qw(
Rmpq_abs Rmpq_add Rmpq_canonicalize Rmpq_clear Rmpq_cmp Rmpq_cmp_si Rmpq_cmp_ui
Rmpq_create_noval Rmpq_denref Rmpq_div Rmpq_div_2exp Rmpq_equal Rmpq_get_d 
Rmpq_get_den Rmpq_get_num Rmpq_get_str Rmpq_init Rmpq_init_nobless Rmpq_inp_str
Rmpq_inv Rmpq_mul Rmpq_mul_2exp Rmpq_neg Rmpq_numref Rmpq_out_str Rmpq_printf 
Rmpq_set Rmpq_set_d Rmpq_set_den Rmpq_set_f Rmpq_set_num Rmpq_set_si Rmpq_set_str
Rmpq_set_ui Rmpq_set_z Rmpq_sgn Rmpq_sub Rmpq_swap
    );
    $Math::GMPq::VERSION = '0.10';

    DynaLoader::bootstrap Math::GMPq $Math::GMPq::VERSION;

    %Math::GMPq::EXPORT_TAGS =(mpq => [qw(
Rmpq_abs Rmpq_add Rmpq_canonicalize Rmpq_clear Rmpq_cmp Rmpq_cmp_si Rmpq_cmp_ui
Rmpq_create_noval Rmpq_denref Rmpq_div Rmpq_div_2exp Rmpq_equal Rmpq_get_d 
Rmpq_get_den Rmpq_get_num Rmpq_get_str Rmpq_init Rmpq_init_nobless Rmpq_inp_str
Rmpq_inv Rmpq_mul Rmpq_mul_2exp Rmpq_neg Rmpq_numref Rmpq_out_str Rmpq_printf 
Rmpq_set Rmpq_set_d Rmpq_set_den Rmpq_set_f Rmpq_set_num Rmpq_set_si Rmpq_set_str
Rmpq_set_ui Rmpq_set_z Rmpq_sgn Rmpq_sub Rmpq_swap
)]);

sub dl_load_flags {0} # Prevent DynaLoader from complaining and croaking

sub new {
    if(@_ > 3) {die "Too many arguments supplied to new()"}
    if(!@_) {return Rmpq_init()}
    if(ref($_[0]) || $_[0] ne "Math::GMPq") {
      my $ret = Rmpq_init();
      my $type = _itsa($_[0]);

      if(!$type) {die "Inappropriate argument supplied to new()"}

      if($type == 1 || $type == 2) { # UOK or IOK
        if(@_ > 1) {die "Too many arguments supplied to new() - expected only one"}
        Rmpq_set_str($ret, $_[0], 10);
        return $ret;

      }
      if($type == 3) { # NOK
        if(@_ > 1) {die "Too many arguments supplied to new() - expected only one"}
        Rmpq_set_d($ret, $_[0]);
        return $ret;
      }
      if($type == 4) { # POK
        if(@_ > 2) {die "Too many arguments supplied to new() - expected no more than two"}
        if(@_ == 2) {
          Rmpq_set_str($ret, $_[0], $_[1]);
          Rmpq_canonicalize($ret);
          return $ret;
        }
        else {
          Rmpq_set_str($ret, $_[0], 0);
          Rmpq_canonicalize($ret);
          return $ret;
        }
      }
      if($type == 5) { # Math::GMPq object
        if(@_ > 1) {die "Too many arguments supplied to new() - expected only one"}
        Rmpq_set($ret, $_[0]);
        return $ret;
      }
    }

    if($_[0] ne "Math::GMPq") {die "Invalid argument supplied to new()"} 

    if(@_ == 1) {return Rmpq_init()}

    my $type = _itsa($_[1]);
    my $ret = Rmpq_init();

    if(!$type) {die "Inappropriate argument supplied to new()"}

    if($type == 1 || $type == 2) { # UOK or IOK
      if(@_ > 2) {die "Too many arguments supplied to new() - expected only two"}
      Rmpq_set_str($ret, $_[1], 10);
      return $ret;
    }
    if($type == 3) { # NOK
      if(@_ > 2) {die "Too many arguments supplied to new() - expected only two"}
      Rmpq_set_d($ret, $_[1]);
      return $ret;
    }
    if($type == 4) { # POK
      if(@_ == 3) {
        Rmpq_set_str($ret, $_[1], $_[2]);
        Rmpq_canonicalize($ret);
        return $ret;
      }
      else {
        Rmpq_set_str($ret, $_[1], 0);
        Rmpq_canonicalize($ret);
        return $ret;
      }
    }
    if($type == 5) { # Math::GMPq object
      if(@_ > 2) {die "Too many arguments supplied to new() - expected only two"}
      Rmpq_set($ret, $_[1]);
      return $ret;
    }
}

sub _rewrite {
    my $len = length($_[0]);
    my @split = ();
    my @ret = ();
    for(my $i = 0; $i < $len - 1; $i++) {
       if(substr($_[0], $i, 1) eq '%') {
         if(substr($_[0], $i + 1, 1) eq '%') { $i++ }
         else { push(@split, $i) }
         }
       }

    push(@split, $len);
    shift(@split);

    my $start = 0;
    
    for(@split) {
       push(@ret, substr($_[0], $start, $_ - $start));
       $start = $_;
       }

    return @ret;
}

sub Rmpq_printf {
    local($| = 1); # Make sure the output gets presented in the correct sequence.
    if(@_ == 1) {printf(shift)}

    else {
      my @fmt = _rewrite(shift);
      my @args = @_;

     # It's expected that @fmt and @args are of equal size (though in the case
     # of both perl's and C's printf function that's not always the case).
     # Each member of @fmt is paired with one and only one member of @args, each
     # pair of arguments being passed on to either perl's printf function or
     # the gmp_printf function. Any excess (leftover) arguments are simply ignored.
      if(@fmt != @args) {warn "Mismatch in number of args provided to Rmpq_printf.",
                         " Perhaps the function has not parsed the format string as expected"};
      my $len = @fmt;


     # If $fmt[$i] contains a 'Z' or a 'Q' or an 'F', hand over $fmt[$i] and
     # $args[$i] to the gmp_printf function.
     # Else let perl's printf function take care of the formatting - though
     # the gmp_printf function is also probably capable of handling the task.
      for(my $i = 0; $i < $len; $i++) { 
         if($fmt[$i] =~ /Z|Q|F/) {wrap_gmp_printf($fmt[$i], $args[$i])}
         else {printf($fmt[$i], $args[$i])}
         }
      }
}

1;

__END__

=head1 NAME

   Math::GMPq - perl interface to the GMP library's rational (mpq) functions.   

=head1 DESCRIPTION

   A bigrational module utilising the Gnu MP (GMP) library.
   Basically this module simply wraps all of the 'mpq'
   (rational number) functions provided by that library.
   The documentation below extensively plagiarises the GMP
   documentation (which can be found at http://swox.com/gmp/manual/).
   See also the Math::GMPq test suite for examples of usage.

   IMPORTANT:
    If your perl was built with '-Duse64bitint' you need to assign
    all integers larger than 52-bit in a 'use integer;' block. 
    Failure to do so can result in the creation of the variable as 
    an NV (rather than an IV) - with a resultant loss of precision.

=head1 SYNOPSIS

   use Math::GMPq qw(:mpq);

   my $str = '123542/4'; # numerator = 123542
                         # denominator = 4
   my $base = 10;

   # Create the Math::GMPq object
   my $bn1 = Rmpq_init(); # Value set to 0/1

   # Assign a value.
   Rmpq_set_str($str, $base);

   # Remove any factors common to both numerator and
   # denominator so that gcd(numerator, denominator) == 1.
   Rmpq_canonicalize($bn1);

   # or just use the new() function:
   my $rational = Math::GMPq->new('1234/1179');

   # Perform some operations ... see 'FUNCTIONS' below.

   .
   .

   # print out the value held by $bn1 (in octal):
   print Rmpq_get_str($bn1, 8), "\n"; # prints '170513/2'

   # print out the value held by $bn1 (in decimal):
   print Rmpq_get_str($bn1, 10); # prints '61771/2'.

   # print out the value held by $bn1 (in base 29)
   # using the (alternative) Rmpq_out_str()
   # function. (This function doesn't print a newline.)
   Rmpq_out_str($bn1, 29);

=head1 MEMORY MANAGEMENT

   Objects created with Rmpq_create_init() have been
   blessed into package Math::GMPq. They will 
   therefore be automatically cleaned up by the
   DESTROY() function whenever they go out of scope.

   If you wish, you can create unblessed objects
   with Rmpq_init_nobless().
   It will then be up to you to clean up the memory
   associated with these objects by calling
   Rmpq_clear($op), for each object.
   Alternatively the objects will be cleaned up 
   when the script ends.
   I don't know why you would want to create unblessed
   objects - the point is you can if you want to :-) 

=head1 FUNCTIONS

   See the GMP documentation at http://swox.com/gmp/manual

   These next 3 functions are demonstrated above:
   $rop   = Rmpq_init();
   $rop   = Rmpq_set_strl($str, $base); # 1 < $base < 37
   $str = Rmpq_get_str($op, $base); # 1 < $base < 37 

   The following functions are simply wrappers around a GMP
   function of the same name. eg. Rmpq_swap() is a wrapper around
   mpq_swap() which is fully documented in the GMP manual at
   http://swox.com/gmp/manual.

   "$rop", "$op1", "$op2", etc. are simply  Math::GMPq objects -
   the return value of Rmpq_init or Rmpq_init_nobless
   functions. They are in fact references to GMP structures.
   The "$rop" argument(s) contain the result(s) of the calculation
   being done, the "$op" argument(s) being the input(s) into that 
   calculation.
   Generally, $rop, $op1, $op2, etc. can be the same perl variable,
   though usually they will be distinct perl variables referencing
   distinct GMP structures.
   Eg. something like Rmpq_add($r1, $r1, $r1),
   where $r1 *is* the same reference to the same GMP structure,
   would add $r1 to itself and store the result in $r1. Think of it
   as $r1 += $r1. Otoh, Rmpq_add($r1, $r2, $r3), where each of the
   arguments is a different reference to a different GMP structure
   would add $r2 to $r3 and store the result in $r1. Think of it as
   $r1 = $r2 + $r3. Mostly, the first argument is the argument that 
   stores the result and subsequent arguments provide the input values.
   Exceptions to this can be found in some of the functions that
   actually return a value. 
   Like I say, see the GMP manual for details. I hope it's 
   intuitively obvious or quickly becomes so. Also see the test
   suite that comes with the distro for some examples of usage.

   "$ui" means any integer that will fit into a C 'unsigned long int.

   "$si" means any integer that will fit into a C 'signed long int'.

   "$double" means any number (not necessarily integer) that will fit
   into a C 'double'.

   "$bool" means a value (usually a 'signed long int') in which
   the only interest is whether it evaluates as true or false.

   "$str" simply means a string of symbols that represent a number,
   eg "1234567890987654321234567/7" which might be a base 10 number,
   or "zsa34760sdfgq123r5/11" which would have to represent a base 36
   number (because "z" is a valid digit only in base 36). Valid
   bases for GMP numbers are 2 to 62 (inclusive).

   ############

   CANONICALIZE
   http://swox.com/gmp/manual/Rational-Number-Functions

   Rmpq_canonicalize($op);
    Remove any factors that are common to the numerator and
    denominator of $op, and make the denominator positive.

   ##########

   INITIALIZE

   Normally, a variable should be initialized once only or at least be
   cleared, using `Rmpq_clear', between initializations.
   'DESTROY' (which calls 'Rmpq_clear') is automatically called on 
   blessed objects whenever they go out of scope.

   See the section 'MEMORY MANAGEMENT' (above).

   $rop = Math::GMPq::new();
   $rop = Math::GMPq->new();
   $rop = new Math::GMPq();
   $rop = Rmpq_init();
   $rop = Rmpq_init_nobless();
    Initialize $rop and set it to 0/1.

   ####################

   ASSIGNMENT FUNCTIONS
   http://swox.com/gmp/manual/Initializing-Rationals

   Rmpq_set($rop, $op);
   Rmpq_set_z($rop, $z); # $z is a Math::GMPz object
    Set $rop to value contained in 2nd arg.

   Rmpq_set_ui($rop, $ui1, $ui2);
   Rmpq_set_si($rop, $si1, $si2);
    Set $rop to 2nd arg / 3rd arg.

   Rmpq_set_str($rop, $str, $base);
    Set $rop from $str in the given base $base. The string can be
    an integer like "41" or a fraction like "41/152".  The fraction
    must be in canonical form, or if not then `Rmpq_canonicalize'
    must be called. The numerator and optional denominator are 
    parsed the same as in `Rmpz_set_str'. $base can vary from 2 to
    62, or if $base is 0 then the leading characters are used: `0x'
    for hex, `0' for octal, or decimal otherwise.  Note that this
    is done separately for the numerator and denominator, so for
    instance `0xEF/100' is 239/100, whereas `0xEF/0x100' is 239/256.

   Rmpq_swap($rop1, $rop2);
    Swap the values.

   ####################

   COMBINED INITIALIZATION AND ASSIGNMENT

   NOTE: Do NOT use these functions if $rop has already
   been initialised. Instead use the Rmpq_set* functions 
   in 'Assignment Functions' (above)

   First read the section 'MEMORY MANAGEMENT' (above).

   $rop = Math::GMPq->new($arg);
   $rop = Math::GMPq::new($arg);
   $rop = new Math::GMPq($arg);
    Returns a Math::GMPq object with the value of $arg, with default
    precision. $arg can be either an integer (signed integer, unsigned
    integer) or a string that represents a numeric value. If $arg is a
    string, an optional additional argument that specifies the base of
    the number can be supplied to new(). If base is 0 (or not supplied)
    then the leading characters are used: 0x or 0X for hex, 0b or 0B
    for binary, 0 for octal, or decimal otherwise. Note that this is
    done separately for the numerator and denominator, so for instance
    0xEF/100 is 239/100, whereas 0xEF/0x100 is 239/256.

   ####################

   RATIONAL CONVERSIONS
   http://swox.com/gmp/manual/Rational-Conversions.html

   $double = Rmpq_get_d($op);
    Convert $op to a 'double'.

   Rmpq_set_d($rop, $double);
   Rmpq_set_f($rop, $f); # $f is a Math::GnumMPf object
     Set $rop to the value of the 2nd arg, without rounding.

   $str = Rmpq_get_str($op, $base);
    Convert $op to a string of digits in base $base. The base may
    vary from 2 to 36.  The string will be of the form `num/den',
    or if the denominator is 1 then just `num'.

   ###################

   RATIONAL ARITHMETIC
   http://swox.com/gmp/manual/Rational-Arithmetic.html

   Rmpq_add($rop, $op1, $op2);
    $rop = $op1 + $op2.

   Rmpq_sub($rop, $op1, $op2);
    $rop = $op1 - $op2.

   Rmpq_mul($rop, $op1, $op2);
    $rop = $op1 * $op2.

   Rmpq_mul_2exp($rop, $op, $ui);
    $rop = $op * (2 ** $ui).

   Rmpq_div($rop, $op1, $op2);
    $rop = $op1 / $op2.

   Rmpq_div_2exp($rop, $op, $ui);
    $rop = $op / (2 ** $ui).
    
   Rmpq_neg($rop, $op);
    $rop = -$op.

   Rmpq_abs($rop, $op);
    $rop = abs($op).

   Rmpq_inv($rop, $op);
    $rop = 1 / $op.

   ##########################

   APPLYING INTEGER FUNCTIONS
   http://swox.com/gmp/manual/Applying-Integer-Functions.html

   Rmpq_numref($z, $op); # $z is a Math::GMPz object
   Rmpq_denref($z, $op); # $z is a Math::GMPz object
    Set $rop to the numerator and denominator of $op, respectively.
    
   Rmpq_get_num($z, $op); # $z is a Math::GMPz oblect
   Rmpq_get_den($z, $op); # $z is a Math::GMPz oblect
   Rmpq_set_num($rop, $z); # $z is a Math::GMPz oblect
   Rmpq_set_den($rop, $z); # $z is a Math::GMPz oblect
    Get or set the numerator or denominator of a rational
    Direct use of `Rmpq_numref' or `Rmpq_denref' is
    recommended instead of these functions.

   ###################

   COMPARING RATIONALS
   http://swox.com/gmp/manual/Comparing-Rationals.html

   $si = Rmpq_cmp($op1, $op2);
    Compare $op1 and $op2.  Return a positive value if $op1 > $op2,
    zero if $op1 = $op2, and a negative value if $op1 < $op2.
    To determine if two rationals are equal, `Rmpq_equal' is
    faster than `Rmpq_cmp'.

   $si = Rmpq_cmp_ui($op, $ui, $ui);
   $si1 = Rmpq_cmp_si($op, $si2, $ui);
    Compare $op1 and 2nd arg/3rd arg.  Return a positive value if
    $op1 > 2nd arg/3rd arg, zero if $op1 = 2nd arg/3rd arg,
    and a negative value if $op1 < 2nd arg/3rd arg.
    2nd and 3rd args are allowed to have common factors.
    Note that the 3rd (NOT 2nd) arg is unsigned. If you want
    to compare $op with 2/-3, make sure that 2nd arg is
    '-2' and 3rd arg is '3'.

   $si = Rmpq_sgn($op);
    Return +1 if $op>0, 0 if $op=0, and -1 if $op<0.

   $bool = Rmpq_equal($op1, $op2); # faster than Rmpq_cmp()
    Return non-zero if $op1 and $op2 are equal, zero if they
    are non-equal.  Although `Rmpq_cmp' can be used for the
    same purpose, this function is much faster.

   ################

   I/O of RATIONALS
   http://swox.com/gmp/manual/I-O-of-Rationals.html

   The GMP library versions of these functions have
   the capability to read/write directly from/to a 
   file (as well as to stdout). As provided here,
   the functions read/write from/to stdout only.

   $bytes_written = Rmpq_out_str($op, $base);
    Output $op to STDOUT, as a string of digits in base $base.
    The base may vary from 2 to 36. Output is in the form `num/den'
    or if the denominator is 1 then just `num'. Return the number
    of bytes written, or if an error occurred, return 0.

   $bytes_read = Rmpq_inp_str($rop, $base);
    Read a string of digits from STDIN and convert them to a rational
    in $rop.  Any initial white-space characters are read and
    discarded.  Return the number of characters read (including white
    space), or 0 if a rational could not be read.
    The input can be a fraction like `17/63' or just an integer like
    `123'.  Reading stops at the first character not in this form, and
    white space is not permitted within the string.  If the input
    might not be in canonical form, then `mpq_canonicalize' must be
    called. $base can be between 2 and 36, or can be 0 in which case the
    leading characters of the string determine the base, `0x' or `0X'
    for hexadecimal, `0' for octal, or decimal otherwise.  The leading
    characters are examined separately for the numerator and
    denominator of a fraction, so for instance `0x10/11' is 16/11,
    whereas `0x10/0x11' is 16/17. 

   ####################

   OPERATOR OVERLOADING 

   Overloading occurs with numbers, strings and Math::GMPq objects.
   Strings are first converted to Math::GMPq objects, then canonicalized.
   See the Rmpq_set_str documentation (above) in the section "ASSIGNMENT
   FUNCTIONS" regarding permissible string formats.
   The following operators are overloaded:
   
    + - * /
    += -= *= /=
    == != ! not
    < <= > >= <=>
    = "" abs

    Atempting to use the overloaded operators with objects that
    have been blessed into some package other than 'Math::GMPq'
    will not work.

    In those situations where the overload subroutine operates on 2
    perl variables, then obviously one of those perl variables is
    a Math::GMPq object. To determine the value of the other variable
    the subroutine works through the following steps (in order),
    using the first value it finds, or croaking if it gets
    to step 6:

    1. If the variable is an unsigned long then that value is used.
       The variable is considered to be an unsigned long if 
       (perl 5.8) the UOK flag is set or if (perl 5.6) SvIsUV() 
       returns true.

    2. If the variable is a signed long int, then that value is used.
       The variable is considered to be a signed long int if the
       IOK flag is set. (In the case of perls built with
       -Duse64bitint, the variable is treated as a signed long long
       int if the IOK flag is set.)

    3. If the variable is a double, then that value is used. The
       variable is considered to be a double if the NOK flag is set.

    4. If the variable is a string (ie the POK flag is set) then the
       value of that string is used. Octal strings must begin with
       '0', hex strings must begin with either '0x' or '0X' - 
       otherwise the string is assumed to be decimal. If the POK 
       flag is set, but the string is not a valid base 8, 10, or 16
       number, the subroutine croaks with an appropriate error
       message. If the string is of the form 'numerator/denominator',
       then the bases of the numerator and the denominator are 
       assessed individually. ie '0xa123/ff' is not a valid number
       (because 'ff' is not a valid base 10 number). That needs to
       be rewritten as '0xa123/0xff'.

    5. If the variable is a Math::GMPq object then the value of that
       object is used.

    6. If none of the above is true, then the second variable is
       deemed to be of an invalid type. The subroutine croaks with
       an appropriate error message.

   #####

   OTHER

   $GMP_Version = Math::GMPq::gmp_v();
    Returns the version of the GMP library. The function is not
    exported.

   ################

   FORMATTED OUTPUT

   Rmpq_printf($format_string, @variables);

    'Rmpq_printf' accepts format strings similar to the standard C
    'printf' (and hence also perl's printf function). A format
     specification is of the form:

      % [flags] [width] [.[precision]] [type] conv

    GMP adds types 'Z', 'Q' and 'F' for Math::GMPz objects,
    Math::GMPq objects and Math::GMPf objects respectively.
    'Z', and 'Q' behave like integers.  'Q' will print a '/' and a
    denominator, if needed.  'F' behaves like a float.  For example:

     Rmpq_printf ("%s is a Math::GMPz object %Zd\n", "here", $z);
     Rmpq_printf ("a hex rational: %#40Qx\n", $q);
     Rmpq_printf ("fixed point mpf %.5Ff with 5 decimal places\n", $f);

    The flags accepted are as follows:

     0         pad with zeros (rather than spaces)
     #         show the base with '0x', '0X' or '0'
     +         always show a sign
     (space)   show a space or a '-' sign

    The optional width and precision can be given as a number within
    the format string, or as an interpolated perl variable - but note
    that formatting with '*' (for width and precision fields)
    WON'T currently work.ie the following is not currently supported:

     $places = 5;
     Rmpq_printf("mpf %.*Ff\n", $places, $f);

    Instead you would need to rewrite this as:

     $places = 5;
     Rmpq_printf("mpf %.${places}Ff\n", $f);

    The conversions accepted are as follows.  

     a A       hex floats, C99 style
     c         character
     d         decimal integer
     e E       scientific format float
     f         fixed point float
     i         same as d
     g G       fixed or scientific float
     o         octal integer
     s         string
     u         unsigned integer
     x X       hex integer

    'a' and 'A' are always supported for GMP objects but don't work with
    perl's printf function. Always call them prefixed with either 'Z',
    'F' or 'Q' (whichever is appropriate).

    'p' works with the GMP library and with perl (returns the address of
    the variable), but can segfault if it's used in the Rmpq_printf 
    function. For this reason I've excluded it from the list above,
    though you can certainly use it with perl's printf function - even
    if the perl variable is a gmp object.

    'o', 'x' and 'X' are unsigned for the standard C types, but for
    types 'Z', 'Q' and 'N' they are signed.  'u' is not meaningful
    for 'Z', 'Q' and 'N'.

    In the GMP C library, 'n' can be used with any type, even the GMP
    types - but that functionality does not currently extend to Perl's
    GMP objects - so 'n' has been excluded from the above list.

    The precision field has it's usual meaning for integer 'Z' and float
    'F' types, but is currently undefined for 'Q' and should not be used
    with that.

    Conversions of Math::GMPf objects only ever generate as many 
    digits as can be accurately represented by the operand, the same as
    'Rmpf_get_str' does. Zeros will be used if necessary to pad to the 
    requested precision.  This happens even for an 'f' conversion of a 
    Math::GMPf object which is an integer, for instance 2^1024 in a 
    Math::GMPq object of 128 bits precision will only produce about
    40 digits, then pad with zeros to the decimal point.  An empty 
    precision field like '%.Fe' or '%.Ff' can be used to specifically
    request just the significant digits.

    The format string is interpreted as plain ASCII - multibyte
    characters are not recognised.

    Also, in Rmpq_printf, there's no support for POSIX '$' style 
    numbered arguments.

   ################


=cut