# -*-Perl-*-
## Bioperl Test Harness Script for Modules
##


# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.t'

use Test;
use strict;
use Bio::CorbaClient::Client;
my $ior_file = 'seqdbsrv.ior';

#eval {
    my $client = new Bio::CorbaClient::Client( -idl => 'biocorba.idl',
					       -ior => $ior_file,
					       -orbname => 'orbit-local-orb');
    
    my $db = $client->new_object('Bio::DB::Biocorba');
				 
    my @ids = $db->get_all_primary_ids();
    print STDERR "ids are ", join("\n", @ids), "\n";

    my $iter = $db->get_PrimarySeq_stream;
    while( defined(my $seq = $iter->next_primary_seq()) ) {
	print "display id is ", $seq->display_id, " seq is ", $seq->seq, "\n";
    }	
#};

if ($@) {
    print STDERR "test Failed: Make sure a the file $ior_file exists and was created by a running SeqDB server\n";
    print "not ok 2\n";
} else {
    print "ok 2\n";
}


