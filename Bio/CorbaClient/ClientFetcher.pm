# $Id$
#
# BioPerl module for Bio::CorbaClient::ClientFetcher
#
# Elia Stupka <elia@fugu-sg.org
#
# Copyright Elia Stupka
#
# You may distribute this module under the same terms as perl itself

# POD documentation - main docs before the code

=head1 NAME

Bio::CorbaClient::ClientFetcher - Registry fetcher for BioCorba Client complying with the new->(%config) interface...

=head1 SYNOPSIS

    use Bio::CorbaClient::ClientFetcher;
    # in this example we build a SeqDB
    # have a SeqDB object already called $seqdbref
    my $client = new Bio::CorbaClient::ClientFetcher(%config);

=head1 DESCRIPTION

This object gets a BioCorba Client objects based on a Registry hash

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

=head1 AUTHOR - Elia Stupka

Email elia@fugu-sg.org    

=head1 APPENDIX

The rest of the documentation details each of the object
methods. Internal methods are usually preceded with a _

=cut

# object code begins
    
package Bio::CorbaClient::ClientFetcher;

use vars qw(@ISA);
use strict;
use Bio::CorbaClient::Client;
use Bio::Root::Root;

@ISA = qw ( Bio::Root::Root);

sub new { 
    my ( $class, %config ) = @_;
    my $self = $class->SUPER::new(%config);
    
    my $client = new Bio::CorbaClient::Client( -ior => $config{'location'});
    return $client;
}
    
    
