# -*-Perl-*-
## Bioperl Test Harness Script for Modules
##


# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.t'

use Test;
use strict;
BEGIN { plan tests => 2 }

use CORBA::ORBit idl => [ 'biocorba.idl' ];
use Bio::DB::Biocorba;

use Error;

my $ior_file = "seqdbsrv.ior";
my $orb = CORBA::ORB_init("orbit-local-orb");

open(F,"$ior_file") || die "Could not open $ior_file";
my $ior = <F>;
chomp $ior;
close(F); 
print STDERR "Got file $ior_file\n";

my $db = new Bio::DB::Biocorba($orb->string_to_object($ior));
my @ids = $db->get_all_primary_ids();
print "ids are ", join("\n", @ids), "\n";

my $iter = $db->get_PrimarySeq_stream;
my $seq;
while( defined($seq = $iter->next_primary_seq()) ) {
    print "display id is ", $seq->display_id, " seq is ", $seq->seq, "\n";
}

if ($@) {
    print STDERR "test Failed: Make sure a the file $ior_file exists and was created by a running SeqDB server\n";
    print "not ok 2\n";
} else {
    print "ok 2\n";
}


