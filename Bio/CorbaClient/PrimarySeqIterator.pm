
#
# BioPerl module for Bio::CorbaClient::PrimarySeqIterator
#
# Cared for by Ewan Birney <birney@ebi.ac.uk>
#
# Copyright Ewan Birney
#
# You may distribute this module under the same terms as perl itself

# POD documentation - main docs before the code

=head1 NAME

Bio::CorbaClient::PrimarySeqIterator - wrapper over Bio::CorbaServer::PrimarySeqIterator

=head1 SYNOPSIS

Give standard usage here

=head1 DESCRIPTION

Describe the object here

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


package Bio::CorbaClient::PrimarySeqIterator;
use vars qw($AUTOLOAD @ISA);
use strict;

# Object preamble - inherits from Bio::Root::Object

use Bio::CorbaClient::Base;
use Bio::CorbaClient::PrimarySeq;

@ISA = qw(Bio::CorbaClient::Base);

sub next_primary_seq {
    my $self = shift;

    if( $self->corbaref->has_more == 0 ) {
	return undef;
    }

    my $corbaref = $self->corbaref->next();
    my $seq = Bio::CorbaClient::PrimarySeq->new($corbaref);
    return $seq;
}

