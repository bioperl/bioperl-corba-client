# $Id$
#
# BioPerl module for Bio::CorbaClient::SeqDB
#
# Cared for by Ewan Birney <birney@ebi.ac.uk>
#
# Copyright Ewan Birney
#
# You may distribute this module under the same terms as perl itself

# POD documentation - main docs before the code

=head1 NAME

Bio::CorbaClient::SeqDB - Bioperl Sequence Database wrapper around BioCORBA object.

=head1 SYNOPSIS

Give standard usage here

=head1 DESCRIPTION

  Client bindings to make BioCorba SeqDB look like Bioperl SeqDB

=head1 FEEDBACK

=head2 Mailing Lists

User feedback is an integral part of the evolution of this
and other Bioperl modules. Send your comments and suggestions preferably
 to one of the Bioperl mailing lists.
Your participation is much appreciated.

  bioperl-l@bio.perl.org

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


package Bio::CorbaClient::SeqDB;
use vars qw(@ISA);
use strict;
use Bio::CorbaClient::Seq;
use Bio::DB::SeqI;
use Bio::CorbaClient::Base;
use CORBA::ORBit idl => [ 'idl/biocorba.idl' ];

# implements the Bio::DB::SeqI interface

@ISA = qw(Bio::CorbaClient::Base Bio::DB::SeqI);


# new() inherited from Bio::CorbaClient::Base

sub new_from_registry {
    my ($class,%config) = @_;
    
    my $orb = CORBA::ORB_init("orbit-local-orb");
    open(F,$config{'location'});
    my $ior = <F>;
    chomp $ior;
    my $ref = $orb->string_to_object($ior);
    my $self = $class->SUPER::new('corbaref' => $ref);
    return $self;
}

=head2 get_Seq_by_id

 Title   : get_Seq_by_id
 Usage   : $seq = $db->get_Seq_by_id('ROA1_HUMAN')
 Function: Gets a Bio::Seq object by its name
 Returns : a Bio::Seq object
 Args    : the id (as a string) of a sequence
 Throws  : "id does not exist" exception


=cut

sub get_Seq_by_id {
    my $self = shift;
    my $acc  = shift;
    
    my $seq;
    eval {
      $seq = Bio::CorbaClient::Seq->new(-corbaref => $self->corbaref->resolve($acc));
    };

    if( $@ ) {
      $self->warn("Sequence $acc was not returned from the CORBA server. The original CORBA exception was:\n $@");
      return undef;
    }

    return $seq;
}


=head2 get_Seq_by_acc

 Title   : get_Seq_by_acc
 Usage   : $seq = $db->get_Seq_by_acc('X77802');
 Function: Gets a Bio::Seq object by accession number
 Returns : A Bio::Seq object
 Args    : accession number (as a string)
 Throws  : "acc does not exist" exception


=cut

sub get_Seq_by_acc {
    my $self = shift;
    my $acc  = shift;

    my $seq;
    eval {
      $seq = Bio::CorbaClient::Seq->new(-corbaref => $self->corbaref->resolve($acc,0));
    };

    if( $@ ) {
      $self->warn("Sequence $acc was not returned from the CORBA server. The original CORBA exception was $@");
      return undef;
    }

    
    return $seq;
}


=head1 Methods [that were] specific for Bio::DB::SeqI

=head2 get_PrimarySeq_stream

 Title   : get_PrimarySeq_stream
 Usage   : $stream = get_PrimarySeq_stream
 Function: Makes a Bio::DB::SeqStreamI compliant object
           which provides a single method, next_primary_seq
 Returns : Bio::DB::SeqStreamI
 Args    : none


=cut

sub get_PrimarySeq_stream{
   my ($self,@args) = @_;

   $self->throw("Have not implemented PrimarySeq streams in Corba binding layer. Should be easy");
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

   my @a = @{$self->corbaref->accession_numbers};

   return @a;
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
 Returns : A Bio::Seq object
 Args    : accession number (as a string)
 Throws  : "acc does not exist" exception


=cut

sub get_Seq_by_primary_id {
   my ($self,$id) = @_;

   return $self->get_Seq_by_acc($id);
}

1;
