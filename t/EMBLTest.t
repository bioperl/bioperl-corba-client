# -*-Perl-*-

use strict;
use vars qw($NUMTESTS $DEBUG $EMBLNAME $IORURL $error);

BEGIN { 
    # to handle systems with no installed Test module
    # we include the t dir (where a copy of Test.pm is located)
    # as a fallback
    eval { require Test; };
    $error = 0;
    $DEBUG = 0;
    $EMBLNAME ='EMBL';
    $IORURL   ='http://corba.ebi.ac.uk/IOR/EmblBiocorba_v0_2.IOR';

    if( $@ ) {
	use lib 't';
    }
    use Test;

    $NUMTESTS = 5;
    plan tests => $NUMTESTS;
    eval { require 'HTTP/Request.pm';
	   require 'LWP/UserAgent.pm';	   
       };
    if( $@ ) {
	print STDERR "LWP or HTTP::Request is not properly installed.  Skipping test...\n";
	for( 1..$NUMTESTS ) {
	    skip(1,1);
	}
	$error = 1; 
    }
}
if( $error == 1 ){
    exit(0);
}
use CORBA::ORBit idl => [ 'biocorba.idl' ];
use Bio::CorbaClient::Seq;
use HTTP::Request;
use LWP::UserAgent;

# init
my $orb = CORBA::ORB_init("orbit-local-orb");
my $response = undef;
eval { 
    my $request  = new HTTP::Request(GET => $IORURL);
    my $agent    = new LWP::UserAgent;
    $response = $agent->request($request);
};
if( $@ || ! ref $response || 
    ! $response->is_success ) {
    print STDERR "$@" if ( $DEBUG );
    for( $Test::ntest..$NUMTESTS ) { skip(1,1) }
    exit(0);
}

my $ior=$response->content();
chomp($ior);
my $bioenv = $orb->string_to_object($ior);
ok($bioenv);

my %params = ( 'accessnumber' => 'AC003953');
#######################################################################
# I had to comment the line below to avoid the exception.
my $dblist = $bioenv->get_SeqDB_names();
#######################################################################
foreach my $dbname ( @$dblist ) {
    print "dbname is $dbname\n" if( $DEBUG );
}

my $database = $bioenv->get_SeqDB_by_name($EMBLNAME,0);
ok($database);

# should porbably catch exceptions

my $corbaseq = $database->get_Seq($params{'accessnumber'},0);
ok($corbaseq);

my $bioseq = new Bio::CorbaClient::Seq('-corbaref' => $corbaseq );
ok($bioseq);

my @features = $bioseq->all_SeqFeatures();
ok(@features, 53);

if( $DEBUG ) {
    foreach my $feature ( @features ) {    
	print $feature->primary_tag , ' ', $feature->start, "..", $feature->end, "\n";
    }
}
