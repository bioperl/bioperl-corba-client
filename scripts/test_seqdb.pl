

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

my $seq = $db->get_Seq_by_id('HUMBDNF');

#print "sequence is ",$seq->id,"\n";

print "sequence is ",$seq->seq,"\n";


$seqio = Bio::SeqIO->new( '-format' => 'embl', -fh => \*STDOUT);

$seqio->write_seq($seq);
