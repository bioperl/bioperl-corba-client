

use CORBA::ORBit idl => [ 'idl/biocorba.idl' ];
use Bio::CorbaClient::SeqDB;
use Bio::SeqIO;

my $orb = CORBA::ORB_init("orbit-local-orb");


open(F,"seqdb.ior");
$ior = <F>;

chomp $ior;

my $ref = $orb->string_to_object($ior);

print "ref is $ref\n";
my $db =  Bio::CorbaClient::SeqDB->new( '-corbaref' => $ref);


#print "sequence is ",$seq->id,"\n";


open(F,shift) || die "Could not open file!";

while( <F> ) {
    ($acc) = split;
    push(@accs,$acc);
}

$seqio = Bio::SeqIO->new( '-format' => 'fasta', -fh => \*STDOUT);

foreach $acc ( @accs ) {
    my $seq = $db->get_Seq_by_acc($acc);
    #foreach $sf ( $seq->top_SeqFeatures ) {
	#print STDERR "Got $sf with ".$sf->corbaref()."\n";
	#print STDERR "Location ",$sf->corbaref()->location_as_string," vs ",$sf->location->to_FTstring,"\n";
    #}
    $seqio->write_seq($seq);
}


