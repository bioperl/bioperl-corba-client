# $Id$
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

Bio::SeqIO::biocorba - biocorba seqio bridge

=head1 SYNOPSIS

# run a biocorba server somewhere, writing its IOR to a file:

   $seqio = Bio::SeqIO->new( '-format' => 'biocorba' , 
			     -file => 'biocorba_server.ior' ) ;
   $seqout = Bio::SeqIO->new ('format' => 'fasta',
			      -fh => \* STDOUT);

   while( $seq = $seqio->next_seq ) {
        $seqout->write_seq($seq);
   }

=head1 DESCRIPTION

This makes a biocorba PrimarySeqIterator object "look like" a SeqIO
input. It starts by using a file with the ior of the CORBA object in
it.

=head1 FEEDBACK

=head2 Mailing Lists

User feedback is an integral part of the evolution of this and other
Bioperl modules. Send your comments and suggestions preferably to one
of the Bioperl mailing lists.  Your participation is much appreciated.

  bioperl-l@bioperl.org                  - General Bioperl discussion
  biocorba-l@biocorba.org                - General Biocorba discussion
  http://www.bioperl.org/MailList.html   - About the bioperl mailing list
  http://www.biocorba.org/MailList.shtml - About the biocorba mailing list

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

@ISA = qw(Bio::SeqIO);

# we have to chain back to the new in SeqIO and then do our 
# own messing around to check that the file is ok.

sub _initialize {
    my ($self,@args) = @_;

    $self->SUPER::_initialize(@args);
    
    # check that we can actually bind to the CORBA object now
    my $orb = Bio::CorbaClient::ORB->get_orb();
    my ($iterator) = $self->_rearrange([qw(ITERATOR)],@args);
    
    if( ! defined $iterator ) {
	my $ior = $self->_readline;
	chomp $ior;	
	my $corbaref = $orb->string_to_object($ior);
	if( $corbaref->isa('org::biocorba::PrimarySeqIterator') ) {
	    $iterator = $corbaref;
	} elsif( $corbaref->isa('org::biocorba::PrimarySeqDB') ) {
	    $iterator = $corbaref->get_PrimarySeqVector->iterator();
	} else {
	    $self->throw("Unable to bind to (supposed) ior in biocorba file");
	}
    }
    $self->iterator($iterator);
    # ready to rock and roll!
    return 1;
}

sub next_seq {
    my ($self) = @_;
    my $pseq = $self->iterator->next();
    if( ! defined $pseq ) {
	return undef;
    }

    my $seq = Bio::Seq->new();
    $seq->primary_seq($pseq);

    return $seq;
}

sub next_primary_seq {
    my $self;
    return $self->iterator->next();
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


