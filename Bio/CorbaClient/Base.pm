
#
# BioPerl module for Bio::CorbaClient::Base
#
# Cared for by Ewan Birney <birney@ebi.ac.uk>
#
# Copyright Ewan Birney
#
# You may distribute this module under the same terms as perl itself

# POD documentation - main docs before the code

=head1 NAME

Bio::CorbaClient::Base - Base class for all Corba Client wrappers

=head1 SYNOPSIS


=head1 DESCRIPTION

This is the base class for all Biocorba client wrappers. This class 
provides the simple memory management model which is crucial to make
sure we don't leave objects forever on the server side. The memory
management happens via ref/unref calls - generally we will never touch
ref as (from our perspective) we only ever get on object. unref is 
important (duh!).

Base also provides a standard new object and inheriets from Bio::Root::RootI
so we can throw nicely.

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


#' Let the code begin...


package Bio::CorbaClient::Base;
use vars qw(@ISA);
use strict;

use Bio::Root::RootI;

@ISA = qw(Bio::Root::RootI);

sub new {
    my ($class,$corbaref) = @_;

    my $self = {};
    bless $self,$class;
    if( defined $corbaref ) {
	$self->corbaref($corbaref);
    }
    return $self;
}

=head2 corbaref

 Title   : corbaref
 Usage   : $obj->corbaref($newval)
 Function: 
 Example : 
 Returns : value of corbaref
 Args    : newvalue (optional)


=cut

sub corbaref{
   my ($obj,$value) = @_;
   if( defined $value) {
      $obj->{'corbaref'} = $value;
    }
    return $obj->{'corbaref'};

}


sub DESTROY {
    my $self= shift;
    my $corbaref = $self->corbaref;
    if( !defined $corbaref ) {
	$self->warn("No corbareference in corbaclient wrapping. Could be leaking memory server-side!");
	return;
    }

    $self->corbaref->unref();
}


