
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


=head1 DESCRIPTION

This is a wrapper which maps the Biocorba PrimarySeq to the Bioperl
PrimarySeq. It does not have to do a great deal...

=head1 FEEDBACK

=head2 Mailing Lists

User feedback is an integral part of the evolution of this
and other Bioperl modules. Send your comments and suggestions preferably
 to one of the Bioperl mailing lists.
Your participation is much appreciated.

  vsns-bcd-perl@lists.uni-bielefeld.de          - General discussion
  vsns-bcd-perl-guts@lists.uni-bielefeld.de     - Technically-oriented discussion
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


package Bio::CorbaClient::PrimarySeq;
use vars qw($AUTOLOAD @ISA);
use strict;


use Bio::CorbaClient::Base;
use Bio::PrimarySeqI;

@ISA = qw(Bio::CorbaClient::Base Bio::PrimarySeqI);


sub seq {
    my ($self,$val ) = @_;
    if( defined $val ) {
	$self->warn("Attempting to set the value of a primary seq when it is a corba object. You will need to make an in-memory copy");
    }

    return $self->corbaref->get_seq();
}

sub subseq {
    my($self,$start,$end) = @_;

    return $self->corbaref->get_subseq($start,$end);
}

sub display_id {
    my ($self,$val ) = @_;
    if( defined $val ) {
	$self->warn("Attempting to set the value of a primary seq when it is a corba object. You will need to make an in-memory copy");
    }

    return $self->corbaref->display_id();
}


sub accession_number {
    my ($self,$val ) = @_;
    if( defined $val ) {
	$self->warn("Attempting to set the value of a primary seq when it is a corba object. You will need to make an in-memory copy");
    }

    return $self->corbaref->accession_number();
}


sub primary_id {
    my ($self,$val ) = @_;
    if( defined $val ) {
	$self->warn("Attempting to set the value of a primary seq when it is a corba object. You will need to make an in-memory copy");
    }

    return $self->corbaref->primary_id();
}

sub can_call_new {
    return 0;
}

sub moltype {
    my ($self,$val ) = @_;
    if( defined $val ) {
	$self->warn("Attempting to set the value of a primary seq when it is a corba object. You will need to make an in-memory copy");
    }
    my $t = $self->corbaref->type();
    if( $t eq 'PROTEIN' ) {
	return 'protein';
    } 
    if( $t eq 'RNA' ) {
	return 'rna';
    }
    return 'dna';

}


