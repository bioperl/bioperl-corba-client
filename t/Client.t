# -*-Perl-*-
## Bioperl Test Harness Script for Modules
##


# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.t'

use Test;
use strict;
BEGIN { plan tests => 5 }
use Bio::CorbaClient::Client;
use Bio::SeqIO;
my $ior_file = 'seqdbsrv.ior';
my $client = new Bio::CorbaClient::Client( -idl => 'biocorba.idl',
					   -ior => $ior_file,
					   -orbname => 'orbit-local-orb');

ok($client);
my $db = $client->new_object('Bio::DB::Biocorba');
ok($db);				 
my @ids = $db->get_all_primary_ids();
print STDERR "ids are ", join("\n", @ids), "\n";

my $iter = $db->get_PrimarySeq_stream;
my $seq = $iter->next_primary_seq();
ok($seq);
ok($seq->display_id, '');
ok($seq->seq, '');
