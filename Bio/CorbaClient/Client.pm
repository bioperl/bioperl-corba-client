# $Id$
#
# BioPerl module for Bio::CorbaClient::Client
#
# Jason Stajich <jason@chg.mc.due.edu>
#
# Copyright Jason Stajich
#
# You may distribute this module under the same terms as perl itself

# POD documentation - main docs before the code

=head1 NAME

Bio::CorbaClient::Client - BioCorba basic server object used for allocating other BioCorba objects 

=head1 SYNOPSIS

    use Bio::CorbaClient::Client;
    # in this example we build a SeqDB
    # have a SeqDB object already called $seqdbref
    my $server = new Bio::CorbaClient::Client( -idl => 'biocorba.idl',
					       -ior => 'obj.ior',
					       -orbname=> 'orbit-local-orb');
    my $seqdb = $server->new_object( -object=> 'Bio::DB::Biocorba',
				     -args => [ 'dbname-here', $seqdbref ] );

    $server->start();

=head1 DESCRIPTION

This object provides BioCorba object creation support.

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
 the bugs and their resolution.
 Bug reports can be submitted via email or the web:

  bioperl-bugs@bio.perl.org
  http://bio.perl.org/bioperl-bugs/

=head1 AUTHOR - Jason Stajich

Email jason@chg.mc.duke.edu    

=head1 APPENDIX

The rest of the documentation details each of the object
methods. Internal methods are usually preceded with a _

=cut

# object code begins
    
package Bio::CorbaClient::Client;

use vars qw(@ISA);
use strict;

use CORBA::ORBit idl => [ '../../idl/biocorba.idl' ];

use Bio::Root::Root;

@ISA = qw ( Bio::Root::Root);

sub new { 
    my ( $class, @args ) = @_;
    my $self = $class->SUPER::new(@args);

    my ( $idl, $ior, $orbname ) = $self->_rearrange( [ qw(IDL IOR ORBNAME)], 
						     @args);

    $self->{'_ior'} = $ior || $self->throw("must provide an ior file to open");
    $self->{'_idl'} = $idl || '../../idl/biocorba.idl';
    $self->{'_orbname'} = $orbname || 'orbit-local-orb';
    
    my $orb = CORBA::ORB_init($orbname);
    open( IOR, $self->{'_ior'}) || $self->throw("cannot open ior file " .
						$self->{'_ior'});    
    
    my $iorfile = <IOR>;
    chomp($iorfile);
    $self->{'_orb'} = $orb;
    $self->{'_iorfile'} = $iorfile;
    return $self;
}

sub new_object {
    my ($self, @args) = @_;

    my ( $objectname, $args) = $self->_rearrange( [qw(OBJECT ARGS)], 
						  @args);
    
    $self->throw("must have an object name before server can allocate a new object\n")
	if( !defined $objectname );
    
    my $obj;
    if ( &_load_module($objectname) == 0 ) { # normalize capitalization
	return undef;
    }       
    $args = [ () ] if( !defined $args );
    my $ior = $self->{'_iorfile'};
    $obj = $objectname->new( '-corbaref' => 
			     $self->{'_orb'}->string_to_object($ior), 
			     @$args );    
    if( @$ || !defined $obj ) { 
	$self->throw("Cannot instantiate object of type $objectname");
    }
    push @{$self->{'_clientobjs'}}, $obj;
    return $obj;
}

=head2 _load_module

 Title   : _load_module
 Usage   : *INTERNAL BioCorba Server stuff*
 Function: Loads up (like use) a module at run time on demand
 Example :
 Returns :
 Args    :

=cut

sub _load_module {
  my ($format) = @_;
  my ($module, $load, $m);
  $format =~ s/::/\//g;
  $load = "$format.pm";
  $module = "_<$format.pm";
  
  return 1 if $main::{$module};
  eval {
    require $load;
  };
  if ( $@ ) {
    print STDERR <<END;
$load: $format cannot be found
Exception $@
For more information about the Bio::CorbaClient::Client system 
please see the Bio::CorbaClient::Client docs.
This includes ways of checking for formats at compile time, not run time
END
  ;
    return;
  }
  return 1;
}
