

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

User feedback is an integral part of the evolution of this
and other Bioperl modules. Send your comments and suggestions preferably
 to one of the Bioperl mailing lists.
Your participation is much appreciated.

  vsns-bcd-perl@lists.uni-bielefeld.de          - General discussion
  vsns-bcd-perl-guts@lists.uni-bielefeld.de     - Technically-oriented discussion
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
