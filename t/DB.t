## Bioperl Test Harness Script for Modules
##


# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.t'

#-----------------------------------------------------------------------
## perl test harness expects the following output syntax only!
## 1..3
## ok 1  [not ok 1 (if test fails)]
## 2..3
## ok 2  [not ok 2 (if test fails)]
## 3..3
## ok 3  [not ok 3 (if test fails)]
##
## etc. etc. etc. (continue on for each tested function in the .t file)
#-----------------------------------------------------------------------


## We start with some black magic to print on failure.
BEGIN { $| = 1; print "1..3\n"; 
	use vars qw($loaded); }

END {print "not ok 1\n" unless $loaded;}

use CORBA::ORBit idl => [ 'biocorba.idl' ];
use Error;
$ior_file = "seqdbsrv.ior";
$orb = CORBA::ORB_init("orbit-local-orb");

use Bio::DB::Biocorba;

$loaded = 1;
print "ok 1\n";    # 1st test passes.

## End of black magic.
##
## Insert additional test code below but remember to change
## the print "1..x\n" in the BEGIN block to reflect the
## total number of tests that will be run. 


open(F,"$ior_file") || die "Could not open $ior_file";
$ior = <F>;
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
    print "not ok 2\n";
} else {
    print "ok 2\n";
}


