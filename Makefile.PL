## --Makefile.PL for Bioperl CORBA module distribution--##
## ----------------------------------------------------##

# make mini test targets for playing around with
# in testing...

#
# Basically this is a standard Makefile with a hash of
# needed packages which are tested at the start
#
# If you want help with this Makefile get in touch with
# the bioperl core by sending a message to bioperl-bugs@bio.perl.org
# for real bugs or bioperl-guts-l@bio.perl.org
# to send a mail to all the bioperl core developpers.
#


%packages = (
	     'CORBA::ORBit' => '0.0/CORBA access/CORBA/Everything',
	     );

sub check_package {
    my ($name,$str) = @_;
    my($ver,$desc,$expl,@modules);

    ($ver,$desc,$expl,$module) = split( /\// , $str);
    if( !eval "require $name") {
	print "External Module $name, $desc,\n is not installed on this computer.\n  The $module in Bioperl needs it for $expl\n\n";
	return 1;
    }

    return 0;
}


require 5.004;
use ExtUtils::MakeMaker;

$do_autoload_finesse = 0;
$NAME     = 'Bio';
$DISTNAME = "bioperl-corba-client";
$VERSION  = '0.1';

$error = 0;
foreach $name ( keys %packages ) {
    if( &check_package($name,$packages{$name}) == 1 ) {
	$error = 1;
    }
}

if( $error == 1 ) {
    print <<QQ_ERROR_QQ;

Warning:

   There are some external packages, listed above, which bioperl-corba-client
   uses. You will have to install these packages before it works.
   Go to http://www.cpan.org/


QQ_ERROR_QQ
}

WriteMakefile(
	      NAME	=> $NAME,
	      DISTNAME    => $DISTNAME,
	      VERSION     => $VERSION,
	      NORECURS    => 0,
	      dist        => {  
		  COMPRESS     => 'gzip -9f',
		  SUFFIX       => '.gz', 
		  DIST_DEFAULT => 'all tardist',
	      },	      
	      realclean   => {  FILES        => join(' ',@BACKUP_FILES) }
	      );


sub cleanup {
    my $sig = @_;
    print "\n** [$0] Caught a SIG$sig -- cleaning up and shutting down.\n";    
    exit(0);
}



