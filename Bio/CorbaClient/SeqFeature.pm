
#
# BioPerl module for Bio::CorbaClient::SeqFeature.pm
#
# Cared for by Ewan Birney <birney@ebi.ac.uk>, 
#              Jason Stajich <jason@chg.mc.duke.edu>
#
# Copyright Ewan Birney, Jason Stajich
#
# You may distribute this module under the same terms as perl itself

# POD documentation - main docs before the code

=head1 NAME

Bio::CorbaClient::SeqFeature.pm - Wrapper to make Biocorba SeqFeature

=head1 SYNOPSIS

=head1 DESCRIPTION

This is a wrapper which maps the Biocorba SeqFeature to the Bioperl
SeqFeature. It does not have to do a great deal...

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

package Bio::CorbaClient::SeqFeature;
use vars qw($AUTOLOAD @ISA);
use strict;


use Bio::CorbaClient::Base;
use Bio::SeqFeatureI;

@ISA = qw(Bio::CorbaClient::Base Bio::SeqFeatureI);


=head1 SeqFeatureI Functions not provided by the IDL

=head2 sub_SeqFeature

 Title   : sub_SeqFeature
 Usage   : @feats = $feat->sub_SeqFeature();
 Function: Returns an array of sub Sequence Features
 Returns : An array
 Args    : none


=cut

sub sub_SeqFeature {
    my $self = shift;
    return $self->corbaref->qualifiers();
}

=head2 primary_tag

 Title   : primary_tag
 Usage   : $tag = $feat->primary_tag()
 Function: Returns the primary tag for a feature,
           eg 'exon'
 Returns : a string 
 Args    : none


=cut

sub primary_tag{
    my $self = shift;
    return $self->corbaref->type;
}

=head2 source_tag

 Title   : source_tag
 Usage   : $tag = $feat->source_tag()
 Function: Returns the source tag for a feature,
           eg, 'genscan' 
 Returns : a string 
 Args    : none


=cut

sub source_tag{
    my $self = shift;
    return $self->corbaref->source;
}

=head2 has_tag

 Title   : has_tag
 Usage   : $value = $self->has_tag('some_tag')
 Function: Returns the value of the tag (undef if 
           none)
 Returns : 
 Args    :


=cut

sub has_tag{
    my ($self,$tag) = @_;
    my @quals = $self->corbaref->qualifiers();
    $tag = uc $tag;
    foreach my $qual (@quals ) {
	if( uc($qual) eq $tag ) {
	    return $qual->{values};
	} 
    }
    return undef;
}

=head2 all_tags

 Title   : all_tags
 Usage   : @tags = $feat->all_tags()
 Function: gives all tags for this feature
 Returns : an array of strings
 Args    : none

=cut

sub all_tags{
    my $self = shift;
    my @quals = $self->corbaref->qualifiers();
    my @tags;
    foreach my $qual ( @quals ) {
	push @tags, $qual->{name};
    }
    return @tags;
}
1;
