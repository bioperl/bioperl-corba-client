# $Id$
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

package Bio::CorbaClient::SeqFeature;
use vars qw(@ISA);
use strict;

use Bio::CorbaClient::Base;
use Bio::SeqFeatureI;
use Bio::Location::Split;
use Bio::Location::Fuzzy;
use Bio::Location::Simple;

@ISA = qw(Bio::CorbaClient::Base Bio::SeqFeatureI);

=head2 sub_SeqFeature

 Title   : sub_SeqFeature
 Usage   : @feats = $feat->sub_SeqFeature();
 Function: Returns an array of sub Sequence Features
 Returns : An array
 Args    : none

=cut

sub sub_SeqFeature {
    my $self = shift;
    my @array;
    my $vector = $self->corbaref->sub_SeqFeatures(1);
    my $iter = $vector->iterator();
    while( $iter->has_more ) {
	push @array, new Bio::CorbaClient::SeqFeature('-corbref' => 
						      $iter->next);
    }
    return @array;
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
           eg, 'exon' 
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
    my $quals = $self->corbaref->qualifiers();    
    return () unless defined $quals;
    my @tags;    
    foreach my $qual ( @$quals ) {
	push @tags, $qual->{name};
    }
    return @tags;
}

=head2 each_tag_value

 Title   : each_tag_value
 Usage   :
 Function:
 Example :
 Returns : 
 Args    :


=cut

sub each_tag_value{
   my ($self,$tag) = @_;

   my $quals = $self->corbaref->qualifiers();    
   return () unless defined $quals;
   
   foreach my $qual ( @$quals ) {
       if( $qual->{name} eq $tag ) {
	   return @{$qual->{values}};
       }
   }
   return ();
}


=head2 location 

 Title   : location
 Usage   : my $loc = $obj->location
 Function: returns the Bio::LocationI object for this object
 Returns : Bio::LocationI
 Args    : none

=cut

sub location {
    my ($self) = @_;
    my $locations = $self->corbaref->locations();
    my $location;
    if( ! defined $locations || @$locations == 0 ) {
	#print STDERR "Empty location! [$locations] yikes!\n";
	$location = new Bio::Location::Simple;
    } elsif( scalar @$locations > 1 ) {
	$location = new Bio::Location::Split();
	foreach my $l ( @$locations ) {
	    $location->add_sub_Location(&_create_location_from_biocorba_loc($l));
	}
    } else {
	$location = &_create_location_from_biocorba_loc($locations->[0]);
    } 
    return $location;
}

=head2 start

 Title   : start
 Usage   : $start = $feat->start
           $feat->start(20)
 Function: Get the start coordinate of the feature
 Returns : integer
 Args    : none


=cut

sub start {
   my ($self) = @_;
   return $self->location->start();
}

=head2 end

 Title   : end
 Usage   : $end = $feat->end
           $feat->end($end)
 Function: Get the end coordinate of the feature
 Returns : integer
 Args    : none


=cut

sub end {
   my ($self) = @_;
   return $self->location->end();
}

=head2 length

 Title   : length
 Usage   : my $len = $self->length()
 Function: returns the length of the feature
 Returns : integer
 Args    : none


=cut

sub length {
   my ($self) = @_;
   return $self->end - $self->start() + 1;
}

=head2 strand

 Title   : strand
 Usage   : $strand = $feat->strand()
           $feat->strand($strand)
 Function: get/set on strand information, being 1,-1 or 0
 Returns : -1,1 or 0
 Args    : none


=cut

sub strand {
   my ($self) = @_;
   return $self->location->strand();
    #print STDERR "Client $location from biocorba... with ",$location->start," ",$location->end,"]\n";
}

sub _create_location_from_biocorba_loc {
    my ($locationhash) = @_;
    my ($startp, $startext, 
	$startfuzzy) = ( $locationhash->{'start'}->{'position'},
			 $locationhash->{'start'}->{'extension'},
			 $locationhash->{'start'}->{'fuzzy'},
			 );
    my ($endp, $endext, 
	$endfuzzy) = ( $locationhash->{'end'}->{'position'},
		       $locationhash->{'end'}->{'extension'},
		       $locationhash->{'end'}->{'fuzzy'},
		       );
    my $type = 'Bio::Location::Simple';
    if( $startfuzzy != 1 || $endfuzzy != 1 ) {
	$type = 'Bio::Location::Fuzzy';
    }
    
    return $type->new('-start' => &_get_point_string($startp,
						     $startext,
						     $startfuzzy),
		      '-end'   =>  &_get_point_string($endp,
							   $endext,
						      $endfuzzy),
		      '-strand' => $locationhash->{'strand'} );
}

sub _get_point_string {
    my ($start,$ext,$fuzzy) = @_;
    
    if( $fuzzy == 2 ) {
	return sprintf("%s.%s", $start, $start+$ext);
    } elsif( $fuzzy == 3 ) {
	return sprintf("%s^%s", $start, $start+$ext);
    } elsif( $fuzzy == 4 ) {
	return sprintf("<%s",$start);
    } elsif( $fuzzy == 5 ) {
	return sprintf("%s>",$start);
    } else { 
	return $start;
    }
}

1;
