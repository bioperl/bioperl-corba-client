# $Id$
#
# BioPerl module for Bio::CorbaClient::ORB
#
# Cared for by Ewan Birney <birney@ebi.ac.uk>
#
# Copyright Ewan Birney
#
# You may distribute this module under the same terms as perl itself

# POD documentation - main docs before the code

=head1 NAME

Bio::CorbaClient::ORB - Singleton class to wrap orb intialisation

=head1 SYNOPSIS

  $orb = Bio::CorbaClient::ORB->get_orb;

=head1 DESCRIPTION

This class wraps the ability to get the Orb for all CORBA clients.

It is also likely to where any magic about getting the biocorba.idl
happens.

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

The rest of the documentation details each of the object methods. Internal methods are usually preceded with a _

=cut

# Let the code begin...

package Bio::CorbaClient::ORB;
use CORBA::ORBit idl => [ 'biocorba.idl' ];

my $orb;

sub get_orb {
    if( !defined $orb ) {
	$orb = CORBA::ORB_init("orbit-local-orb");
    }
    return $orb;
}

1;
