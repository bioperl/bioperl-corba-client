# $Id$
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

package Bio::CorbaClient::Seq;
use vars qw(@ISA);
use strict;

use Bio::CorbaClient::Base;
use Bio::SeqI;

@ISA = qw(Bio::CorbaClient::PrimarySeq Bio::SeqI);

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
    my $vector = $self->corbaref->all_SeqFeatures(0);
    my $iter = $vector->iterator;
    my @features;
    while( $iter->has_more ) {
	push @features, new Bio::CorbaClient::SeqFeature('-corbaref'=>$iter->next());
    }
    return @features;
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
    my $vector = $self->corbaref->SeqFeatures(1);
    my $iter = $vector->iterator;
    my @features;
    while( $iter->has_more ) {
	push @features, new Bio::CorbaClient::SeqFeature('-corbaref'=>$iter->next());
    }
    return @features;
}

=head2 primary_seq

 Title   : primary_seq
 Usage   : my $pseq = $seq->primary_seq
 Function: returns a PrimarySeq object 
 Returns : Bio::CorbaClient::PrimarySeq object
 Args    : none

=cut

sub primary_seq {
    my ($self) = @_;
    return new Bio::CorbaClient::PrimarySeq('-corbaref' => 
					    $self->corbaref->get_Primary_Seq());
}

=head2 feature_count

 Title   : feature_count
 Usage   : $seq->feature_count()
 Function: Return the number of SeqFeatures attached to a sequence
 Example : 
 Returns : number of SeqFeatures
 Args    : none


=cut

sub feature_count {
    my ($self) = @_;
    my $count = 0;
    my $vector = $self->corbaref->SeqFeatures(1);
    my $iter = $vector->iterator;
    while( $iter->has_more ) {
	$count++;
    }
    return $count;
}

1;
