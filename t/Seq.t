# -*-Perl-*-
## Bioperl Test Harness Script for Modules
##

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.t'

use Test;
use strict;
BEGIN { plan tests => 3 }

use CORBA::ORBit idl => [ 'biocorba.idl' ];
use Bio::CorbaClient::PrimarySeq;

my $ior_file = "simpleseq.ior";
my $orb = CORBA::ORB_init("orbit-local-orb");

open(F,"$ior_file") || die "Could not open $ior_file";
my $ior = <F>;
chomp $ior;
close(F);

my $ref = $orb->string_to_object($ior);
ok(ref($ref));
my $seq = Bio::CorbaClient::PrimarySeq->new('-corbaref'=> 
					    $ref);

ok($seq);
ok($seq->display_id, 'HSEARLOBE');
ok($seq->length, 321);
