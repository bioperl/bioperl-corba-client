# $Id$
#
# BioPerl module for Bio::CorbaClient::PrimarySeq.pm
#
# Cared for by Ewan Birney <birney@ebi.ac.uk>
#
# Copyright Ewan Birney
#
# You may distribute this module under the same terms as perl itself

# POD documentation - main docs before the code

=head1 NAME

Bio::CorbaClient::PrimarySeq.pm - Wrapper to make Biocorba PrimarySeq

=head1 SYNOPSIS

Describe usage here.

=head1 DESCRIPTION

This is a wrapper which maps the Biocorba PrimarySeq to the Bioperl
PrimarySeq. It does not have to do a great deal...

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
the bugs and their resolution.  Bug reports can be submitted via email
or the web:

  bioperl-bugs@bio.perl.org
  http://bio.perl.org/bioperl-bugs/

=head1 AUTHOR - Ewan Birney, Jason Stajich

Email birney@ebi.ac.uk
      jason@chg.mc.duke.edu

Describe contact details here

=head1 APPENDIX

The rest of the documentation details each of the object
methods. Internal methods are usually preceded with a _

=cut

# Let the code begin...

package Bio::CorbaClient::PrimarySeq;
use vars qw(@SEQTYPES @ISA);
use strict;

use Bio::CorbaClient::Base;
use Bio::PrimarySeqI;

@ISA = qw(Bio::CorbaClient::Base Bio::PrimarySeqI);

BEGIN { @SEQTYPES = qw(PROTEIN DNA RNA) }
 
=head2 is_circular

 Title   : is_circular
 Usage   : my $circular = $seq->is_circular
 Function: return whether or not this sequence is circular
 Returns : boolean
 Args    : none

=cut

sub is_circular {
    my ($self) = @_;
    return $self->corbaref->is_circular();
}

=head2 length

 Title   : length
 Usage   : $len = $seq->length
 Function: return sequence length
 Returns : (long) sequence length
 Args    : none

=cut

sub length {
    my ($self ) = @_;
    return $self->corbaref->get_length();
}

=head2 seq

 Title   : seq
 Usage   : $seq = $seq->seq
 Function:
 Example :
 Returns : sequence string for this Sequence
 Args    :

=cut

sub seq {
    my ($self,$val ) = @_;
    if( defined $val ) {
	$self->warn("Attempting to set the value of a primary seq when it is a corba object. You will need to make an in-memory copy");
    }

    return $self->corbaref->seq();
}

=head2 subseq

 Title   : subseq
 Usage   : $seq = $seq->subseq($begin,$end)
 Function:
 Example :
 Returns : sub-sequence string for this Sequence
 Args    : $begin, $end indexes to extract seq

=cut

sub subseq {
    my($self,$start,$end) = @_;
    return $self->corbaref->subseq($start,$end);
}

=head2 display_id

 Title   : display_id
 Usage   : $seq->display_id
 Function:
 Example :
 Returns : display id for the sequence
 Args    : 

=cut

sub display_id {
    my ($self,$val ) = @_;
    if( defined $val ) {
	$self->warn("Attempting to set the value of a primary seq when it is a corba object. You will need to make an in-memory copy");
    }
    return $self->corbaref->get_name();
}

=head2 accession_number

 Title   : accession_number
 Usage   : $seq->accession_number
 Function:
 Example :
 Returns : accession number for the sequence
 Args    : 

=cut

sub accession_number {
    my ($self,$val ) = @_;
    if( defined $val ) {
	$self->warn("Attempting to set the value of a primary seq when it is a corba object. You will need to make an in-memory copy");
    }

    return $self->corbaref->get_id();
}

sub accession {
    my $self = shift;

    return $self->accession_number;
}

sub seq_version {
    my $self = shift;

    return $self->version;
}

sub species {
    my $self = shift;

    $self->warn("biocorba does not support species yet!");

    return undef;
}


=head2 display_id

 Title   : display_id
 Usage   : $seq->display_id
 Function:
 Example :
 Returns : display id for the sequence
 Args    : 

=cut

sub primary_id {
    my ($self,$val ) = @_;
    if( defined $val ) {
	$self->warn("Attempting to set the value of a primary seq when it is a corba object. You will need to make an in-memory copy");
    }

    return $self->corbaref->get_id();
}

sub can_call_new {
    return 0;
}

=head2 moltype

 Title   : moltype
 Usage   : $seq->moltype
 Function:
 Example :
 Returns : type of molecular sequence
 Args    : 

=cut

sub moltype {
    my ($self,$val ) = @_;
    if( defined $val ) {
	$self->warn("Attempting to set the value of a primary seq when it is a corba object. You will need to make an in-memory copy");
    }
    my $t = lc $SEQTYPES[$self->corbaref->type()];
    return $t if( $t eq 'protein' || $t eq 'rna' );   
    return 'dna';
}

=head2 version

 Title   : version
 Usage   : $seq->version
 Function: return (unstable) sequence version
 Returns : (long) version
 Args    : none

=cut

sub version {
    my ($self ) = @_;
    return $self->corbaref->version;
}


=head2 desc

 Title   : desc
 Usage   : $seq->desc
 Function:
 Returns : sequence description
 Args    : 

=cut

sub desc {
    # no support for this in current implementation
    return '';
}


sub alphabet {
  my $self = shift;

  my $type= $self->corbaref->get_type;

  # read the corba IDL spec
  if( $type == 0 ) {
    return 'protein';
  } elsif ( $type == 1 ) {
    return 'dna';
  } else {
    return 'rna';
  }
}


1;
