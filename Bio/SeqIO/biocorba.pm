
#
# BioPerl module for Bio::SeqIO::biocorba
#
# Cared for by Ewan Birney <birney@ebi.ac.uk>
#
# Copyright Ewan Birney
#
# You may distribute this module under the same terms as perl itself

# POD documentation - main docs before the code

=head1 NAME

Bio::SeqIO::biocorba - biocorba seqio

=head1 SYNOPSIS

# run a biocorba server somewhere, writing its IOR to a file:

   $seqio = Bio::SeqIO->new( '-format' => 'biocorba' , -file => 'biocorba_server.ior' ) ;
   $seqout = Bio::SeqIO->new ('format' => 'fasta',-fh => \* STDOUT);

   while( $seq = $seqio->next_seq ) {
        $seqout->write_seq($seq);
   }


=head1 DESCRIPTION

This makes a biocorba PrimarySeqIterator object "look like" a SeqIO 
input. It starts by using a file with the ior of the CORBA object in
it. 

=head1 FEEDBACK

=head2 Mailing Lists

User feedback is an integral part of the evolution of this
and other Bioperl modules. Send your comments and suggestions preferably
 to one of the Bioperl mailing lists.
Your participation is much appreciated.

  bioperl-l@bio.perl.org          - General discussion
  bioperl-guts-l@bio.perl.org     - Technically-oriented discussion
  http://bio.perl.org/MailList.html             - About the mailing lists

=head2 Reporting Bugs

Report bugs to the Bioperl bug tracking system to help us keep track
 the bugs and their resolution.
 Bug reports can be submitted via email or the web:

  bioperl-bugs@bio.perl.org
  http://bio.perl.org/bioperl-bugs/

=head1 AUTHOR - Ewan Birney

Email birney@ebi.ac.uk

Describe contact details here

=head1 APPENDIX

The rest of the documentation details each of the object methods. Internal methods are usually preceded with a _

=cut


# Let the code begin...


package Bio::SeqIO::biocorba;
use vars qw($AUTOLOAD @ISA);
use strict;

# Object preamble - inherits from Bio::Root::Object

use Bio::SeqIO;
use Bio::CorbaClient::ORB;
use Bio::CorbaClient::PrimarySeqIterator;

@ISA = qw(Bio::SeqIO);

# we have to chain back to the new in SeqIO and then do our 
# own messing around to check that the file is ok.

use Bio::CorbaClient::ORB;

sub _new {
    my ($class,@args) = @_;

    my $self = Bio::SeqIO->new(@args);

    # rebless into us

    bless $self,$class;

    # check that we can actually bind to the CORBA object now

    my $orb = Bio::CorbaClient::ORB->get_orb();

    my $ior = $self->_readline;
    chomp $ior;

    my $corbaref = $orb->string_to_object($ior);

    if( ! ref $corbaref || ! $corbaref->isa('org::biocorba::PrimarySeqIterator') ) {
	$self->throw("Unable to bind to (supposed) ior in biocorba file");
    }

    my $iterator = Bio::CorbaClient::PrimarySeqIterator->new($corbaref);
 
    $self->iterator($iterator);

    # ready to rock and roll!
}

sub next_seq {
    my $self;
    my $pseq = $self->iterator->next_primary_seq();
    if( ! defined $pseq ) {
	return undef;
    }

    my $seq = Bio::Seq->new();
    $seq->primary_seq($pseq);

    return $seq;
}

sub next_primary_seq {
    my $self;

    return $self->iterator->next_primary_seq();
}


=head2 iterator

 Title   : iterator
 Usage   : $obj->iterator($newval)
 Function: 
 Example : 
 Returns : value of iterator
 Args    : newvalue (optional)


=cut

sub iterator{
   my ($obj,$value) = @_;
   if( defined $value) {
      $obj->{'iterator'} = $value;
    }
    return $obj->{'iterator'};

}

1;


