#!/usr/local/bin/perl -w
use strict;
use vars qw($DEBUG);

use CORBA::ORBit idl => [ 'biocorba.idl' ];
use Bio::CorbaClient::Seq;
use HTTP::Request;
use LWP::UserAgent;
use Bio::SeqIO;

my $EMBLNAME = 'EMBL';
my $IORURL   = 'http://corba.ebi.ac.uk/IOR/EmblBiocorba_v0_2.IOR'; 

my @accessions = @ARGV;

if( ! @accessions ) {
    die("usage: get_seq_from_EMBL ACCESSION1 ACCESSION2 ...\n");
}

my $orb = CORBA::ORB_init("orbit-local-orb");
my $response = undef;
eval { 
    my $request  = new HTTP::Request(GET => $IORURL);
    my $agent    = new LWP::UserAgent;
    $response = $agent->request($request);
};
if( $@ || ! ref $response || 
    ! $response->is_success ) {
    die($@);
}

my $ior    = $response->content();
chomp($ior);
my $bioenv = $orb->string_to_object($ior);

my $dblist = $bioenv->get_SeqDB_names();
foreach my $dbname ( @$dblist ) {
    print "dbname is $dbname\n" if( $DEBUG );
}
# only one db and one db version right now
my $database = $bioenv->get_SeqDB_by_name($EMBLNAME,0);

my $seqio = new Bio::SeqIO(-format => 'embl',
			   -fh => \*STDOUT);
foreach my $accession ( @accessions ) {
    my $corbaseq = $database->get_Seq($accession,0);
    my $seq = new Bio::CorbaClient::Seq('-corbaref' => $corbaseq );
    # This is a Bio::SeqI object so you can treat it like a bioperl object
    $seqio->write_seq($seq);    
}
