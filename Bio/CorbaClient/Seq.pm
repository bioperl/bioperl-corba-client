
#
# BioPerl module for Bio::CorbaClient::Seq.pm
#
# Cared for by Ewan Birney <birney@ebi.ac.uk>, 
#              Jason Stajich <jason@chg.mc.duke.edu>
#
# Copyright Ewan Birney, Jason Stajich
#
# You may distribute this module under the same terms as perl itself

# POD documentation - main docs before the code

=head1 NAME

Bio::CorbaClient::Seq.pm - Wrapper to make Biocorba Seq

=head1 SYNOPSIS

=head1 DESCRIPTION

This is a wrapper which maps the Biocorba Seq to the Bioperl
Seq. It does not have to do a great deal...

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

=head1 AUTHOR - Ewan Birney, Jason Stajich

Email birney@ebi.ac.uk, jason@chg.mc.duke.edu

Describe contact details here

=head1 APPENDIX

The rest of the documentation details each of the object methods. Internal methods are usually preceded with a _

=cut

package Bio::CorbaClient::Seq;
use vars qw($AUTOLOAD @ISA);
use strict;


use Bio::CorbaClient::Base;
use Bio::SeqI;

@ISA = qw(Bio::CorbaClient::Base Bio::SeqI);


=head1 SeqI Functions not provided by the IDL

=head2 top_SeqFeatures

 Title   : top_SeqFeatures
 Usage   : @features = $seq->top_SeqFeatures
 Function:
 Example :
 Returns : array of top level features
 Args    :

=cut

sub top_SeqFeatures {
    my ($self ) = @_;    
    return $self->corbaref->SeqFeatureList();
}

=head2 all_SeqFeatures

 Title   : all_SeqFeatures
 Usage   : $seq->all_SeqFeatures
 Function:
 Example :
 Returns : array of all features (descending into each sub feature)
 Args    : 

=cut

sub all_SeqFeatures {
    my ($self) = @_;
    return $self->top_SeqFeatures();
}

=head1 PrimarySeqI Functions not provided by the IDL

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
    return $self->corbaref->get_seq();
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
    return $self->corbaref->get_subseq($start,$end);
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
    my $t = lc $self->corbaref->type();
    
    return $t if( $t eq 'protein' ||  $t eq 'rna' );
    return 'dna';
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

    return $self->corbaref->display_id();
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

    return $self->corbaref->accession_number();
}

=head2 primary_id

 Title   : primary_id
 Usage   : $seq->primary_id
 Function:
 Example :
 Returns : primary_id for the sequence
 Args    : 

=cut

sub primary_id {
    my ($self,$val ) = @_;
    if( defined $val ) {
	$self->warn("Attempting to set the value of a primary seq when it is a corba object. You will need to make an in-memory copy");
    }

    return $self->corbaref->primary_id;
}

=head2 can_call_new

 Title   : can_call_new
 Usage   : $seq->can_call_new
 Function:
 Example :
 Returns : boolean 
 Args    : 

=cut

sub can_call_new {
    return 0;
}
1;
