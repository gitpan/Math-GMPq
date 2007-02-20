use ExtUtils::MakeMaker;
use Config;

$| = 1;

print "Checking for a C compiler ....";

if(!have_compiler()) {
  die "

******************************************
Could not find your $Config{cc} compiler.
If you know this is not an issue then feel
free to modify the Makefile.PL to exclude
this test, and then re-run the Makefile.PL.

If the author has made a mistake in the
construction of this test, please let him
know:
sisyphus at cpan dot org
******************************************
";
  }

else {print ".. found\n"}

print "Looking for GMP library ...";

if(!have_libraries()) {
  die "

******************************************
Couldn't find libgmp which is required for
Math::GMPq.

To obtain GMP go to:
http://swox.com/gmp/

If you have this library installed, then
apparently it was not found. Check the 
README for instructions. If the instructions
are incorrect, please notify the author:
sisyphus at cpan dot org

You can, of course, modify Makefile.PL so 
that this test is not conducted - then
re-run it.
******************************************
";
}

else {print "... GMP library found\n"}

print "Checking that your GMP library is up to date ...";

$v_ok = get_version();

if($v_ok == 2) {print ".. ok - up to date\n"}

if($v_ok == 1) {
  die "

In attempting to determine your GMP version, the
executable did not compile. This would indicate that
you don't have a sufficiently recent version of MPFR. 
You need GMP version 4.2 or higher. Get it from:

http://swox.com/gmp/

Alternatively, if you think there's an error in 
this check procedure, then edit the Makefile.PL
to exclude this check, re-run it, and please 
inform the author:
sisyphus at cpan dot org
";
}

if($v_ok == 0) {
  die "

You need GMP version 4.2 or higher. Get it from:

http://swox.com/gmp/

Alternatively, if you think there's an error in 
this check procedure, then edit the Makefile.PL
to exclude this check, re-run it, and please 
inform the author:
sisyphus at cpan dot org
";
}

my $defines = $] < 5.008 ? "-DOLDPERL" : "-DNEWPERL";
if($Config::Config{use64bitint} eq 'define' || 
   $Config::Config{use64bitall} eq 'define' ||
   $Config::Config{usemorebits} eq 'define') {$defines .= " -DUSE_64_BIT_INT"}

if($Config::Config{uselongdouble} eq 'define' ||
   $Config::Config{usemorebits} eq 'define') {$defines .= " -DUSE_LONG_DOUBLE"}

my %options = %{       
{
  'NAME' => 'Math::GMPq',
  DEFINE   => $defines,
  'LIBS' => [
    '-lgmp'
  ],
  VERSION_FROM => 'GMPq.pm',
  clean   => { FILES => 'comp.exe check.exe version.exe' },
}
};
WriteMakefile(%options);

# Remove the Makefile dependency. Causes problems on a few systems.
sub MY::makefile { '' }

sub have_compiler {
    if($^O =~ /mswin32/i) {
      if(system("$Config{cc} -o comp.exe comp.c >NUL 2>&1") == 0) {return 1}
      else {return 0}
      }

    else {
      if(system("$Config{cc} -o comp.exe comp.c 2>/dev/null") == 0) {return 1}
      else {return 0}
      }
}

sub have_libraries {
    my $CC = $Config{cc};
    my %args = map{split /\s*=\s*/} @ARGV;
    my $LIBS = $args{LIBS} || $libs;
    my $INC = $args{INC};

    if($^O =~ /mswin32/i) {
      if($CC eq 'cl') {
        $INC =~ s/-I/\/I/g;
        if($LIBS eq '-lgmp') {$LIBS = 'libgmp.lib'}
        else {
          $LIBS =~ s/-L//g;
          $LIBS =~ s/ -lgmp/\/libgmp.lib/;
          }

        if(system("$CC -o check.exe check.c $INC $LIBS >NUL 2>&1") == 0) {return 1}
        else {return 0}
        }
      if(system("$CC -o check.exe check.c $INC $LIBS >NUL 2>&1") == 0) {return 1}
      else {return 0}
      }

    else {
      if(system("$CC -o check.exe check.c $INC $LIBS 2>/dev/null") == 0) {return 1}
      else {return 0}
      }
}

sub get_version {
    my $CC = $Config{cc};
    my %args = map{split /\s*=\s*/} @ARGV;
    my $LIBS = $args{LIBS} || '-lgmp';
    my $INC = $args{INC};

    if($^O =~ /mswin32/i) {
      if($CC eq 'cl') {
        $INC =~ s/-I/\/I/g;
        if($LIBS eq '-lgmp') {$LIBS = 'libgmp.lib'}
        else {
          $LIBS =~ s/-L//g;
          $LIBS =~ s/ -lgmp/\/libgmp.lib/;
          }
        unless(system("$CC -o version.exe version.c $INC $LIBS >NUL 2>&1") == 0) {return 1}
        my $v = `version.exe`;
        my @v = split /\./, $v;
        if($v[0] > 4 || ($v[0] == 4 && $v[1] >= 2 && $v[2] >= 0)) {return 2}
        print "\nYou have GMP version $v\n";
        return 0;
        }
      unless(system("$CC -o version.exe version.c $INC $LIBS >NUL 2>&1") == 0) {return 1}
      my $v = `version.exe`;
      my @v = split /\./, $v;
      if($v[0] > 4 || ($v[0] == 4 && $v[1] >= 2 && $v[2] >= 0)) {return 2}
      print "\nYou have GMP version $v\n";
      return 0;
      }

    else {
      unless(system("$CC -o version.exe version.c $INC $LIBS 2>/dev/null") == 0) {return 1}
      my $v = `./version.exe`;
      my @v = split /\./, $v;
      if($v[0] > 4 || ($v[0] == 4 && $v[1] >= 2 && $v[2] >= 0)) {return 2}
      print "\nYou have GMP version $v\n";
      return 0;
      }
}


