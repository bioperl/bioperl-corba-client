
#
# BioPerl module for Bio::DB::Biocorba
#
# Cared for by Ewan Birney <birney@ebi.ac.uk>, 
#              Jason Stajich <jason@chg.mc.duke.edu>
#
# Copyright Ewan Birney, Jason Stajich
#
# You may distribute this module under the same terms as perl itself

# POD documentation - main docs before the code

=head1 NAME

Bio::DB::Biocorba.pm - Wrapper to make Biocorba DB interface

=head1 SYNOPSIS

=head1 DESCRIPTION

This is a wrapper which maps the Biocorba DB to a Bioperl DB module making it 
available within the Bioperl framework.  It does not have to do a great deal...

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

package Bio::DB::Biocorba;
use vars qw($AUTOLOAD @ISA);
use strict;


use Bio::CorbaClient::Base;
use Bio::CorbaClient::Seq;
use Bio::CorbaClient::PrimarySeq;
use Bio::CorbaClient::PrimarySeqIterator;
use Bio::DB::SeqI;

@ISA = qw(Bio::CorbaClient::Base Bio::DB::SeqI);

=head1 Bio::DB::RandomAccessI Functions not provided by the IDL

=head2 get_Seq_by_id

 Title   : get_Seq_by_id
 Usage   : $seq = $db->get_Seq_by_id('ROA1_HUMAN')
 Function: Gets a Bio::Seq object by its name
 Returns : a Bio::Seq object
 Args    : the id (as a string) of a sequence
 Throws  : "id does not exist" exception

=cut

sub get_Seq_by_id {
    my ($self,$id) = shift;    
    my $corbaref = $self->corbaref->get_Seq($id);
    return Bio::CorbaClient::Seq->new($corbaref) if( defined $corbaref );
    throw org::biocorba::seqcore::UnableToProcess(reason=>"DB::Biocorba could not find a seq for id=$id\n"); 
    return undef;
}

=head2 get_Seq_by_acc

 Title   : get_Seq_by_acc
 Usage   : $seq = $db->get_Seq_by_acc('X77802');
 Function: Gets a Bio::CorbaClient::Seq object by accession number
 Returns : A Bio::CorbaClient::Seq object
 Args    : accession number (as a string)
 Throws  : "acc does not exist" exception

=cut

sub get_Seq_by_acc {
    my ($self,$id) = @_;
    # can you really get this by acc ?
    my $corbaref = $self->corbaref->get_Seq($id);
    return Bio::CorbaClient::Seq->new($corbaref) if( defined $corbaref );
    throw org::biocorba::seqcore::UnableToProcess(reason=>"DB::Biocorba could not find a seq for acc=$id\n"); 
    return undef;
}

=head1 Bio::DB::SeqI methods not provided by biocorba.idl

=head2 get_PrimarySeq_stream

 Title   : get_PrimarySeq_stream
 Usage   : $stream = get_PrimarySeq_stream
 Function: Makes a Bio::SeqIO compliant object
           which provides a single method, next_primary_seq
 Returns : Bio::SeqIO
 Args    : none


=cut

sub get_PrimarySeq_stream{
   my ($self,@args) = @_;   
# I'm not sure this will work?  
   return Bio::CorbaClient::PrimarySeqIterator->new
       ($self->corbaref->make_PrimarySeqIterator);
}

=head2 get_all_primary_ids

 Title   : get_all_ids
 Usage   : @ids = $seqdb->get_all_primary_ids()
 Function: gives an array of all the primary_ids of the 
           sequence objects in the database. These
           maybe ids (display style) or accession numbers
           or something else completely different - they
           *are not* meaningful outside of this database
           implementation.
 Example :
 Returns : an array of strings
 Args    : none

=cut

sub get_all_primary_ids{
    my ($self,@args) = @_;   
   if( ! $self->corbaref->isa('org::biocorba::seqcore::SeqDB')) {
       $self->throw("This is not a org::biocorba::seqcore::SeqDB so get_all_primary_ids is not supported\n");
       return ();
   } 
    my $ids = $self->corbaref->get_primaryidList();
    return @$ids;
}


=head2 get_Seq_by_primary_id

 Title   : get_Seq_by_primary_id
 Usage   : $seq = $db->get_Seq_by_primary_id($primary_id_string);
 Function: Gets a Bio::Seq object by the primary id. The primary
           id in these cases has to come from $db->get_all_primary_ids.
           There is no other way to get (or guess) the primary_ids
           in a database.

           The other possibility is to get Bio::PrimarySeqI objects
           via the get_PrimarySeq_stream and the primary_id field
           on these objects are specified as the ids to use here.
 Returns : A Bio::CorbaClient::Seq object
 Args    : accession number (as a string)
 Throws  : "acc does not exist" exception


=cut

sub get_Seq_by_primary_id {
   my ($self,@args) = @_;
   return Bio::CorbaClient::Seq->new($self->corbaref->get_Seq(shift @args));
}

1;
