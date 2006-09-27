#
# $Id: Target.pm,v 1.1 2006/09/27 15:39:19 gomor Exp $
#
package Net::Packet::Target;
use strict;
use warnings;

our $VERSION = '1.00';

require Class::Gomor::Array;
our @ISA = qw(Class::Gomor::Array);

our @AS = qw(
   mac
   port
   protocol
   hostname
);
our @AA = qw(
   ipList
   ip6List
   portList
);
our @AO = qw(
   ip
   ip6
   ipRange
   ip6Range
   portRange
);
__PACKAGE__->cgBuildIndices;
__PACKAGE__->cgBuildAccessorsScalar(\@AS);
__PACKAGE__->cgBuildAccessorsArray (\@AA);

no strict 'vars';

sub ip {
   my $self = shift;
   @_ ? do { $self->[$__ip] = getHostIpv4Addr(shift) }
      : $self->[$__ip];
}

sub ip6 {
   my $self = shift;
   my $ip6 = shift;
   $ip6 ? do { $self->[$__ip6] = getHostIpv6Addr($ip6) }
        : $self->[$__ip6];
}

use Net::Packet::Utils qw(explodePorts getHostIpv4Addr getHostIpv6Addr);

sub new {
   my $self = shift->SUPER::new(
      ipList    => [],
      ip6List   => [],
      portList  => [],
      @_,
   );

   if ($self->ip) {
      #$self->hostname($self->ip);
      $self->ip(getHostIpv4Addr($self->ip));
   }
   if ($self->ip6) {
      #$self->hostname($self->ip6);
      $self->ip6(getHostIpv6Addr($self->ip6));
   }

   $self;
}

sub ipRange {
   my $self = shift;
   if (@_) {
      $self->[$__ipRange] = shift;
      $self->ipList([ explodeIps($self->[$__ipRange]) ]);
   }
   $self->[$__ipRange];
}

sub portRange {
   my $self = shift;
   if (@_) {
      $self->[$__portRange] = shift;
      $self->portList([ explodePorts($self->[$__portRange]) ]);
   }
   $self->[$__portRange];
}

sub isMultiple {
   my $self = shift;
   if ($self->ipRange || $self->portRange) {
      return 1;
   }
   return undef;
}

1;

=head1 NAME

Net::Packet::Target - Target object for all Net::Packet related stuff

=head1 DESCRIPTION

XXX: to write.

=cut

=head1 AUTHOR

Patrice E<lt>GomoRE<gt> Auffret

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2006, Patrice E<lt>GomoRE<gt> Auffret

You may distribute this module under the terms of the Artistic license.
See LICENSE.Artistic file in the source distribution archive.

=cut
