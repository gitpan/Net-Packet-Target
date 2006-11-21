#
# $Id: Target.pm,v 1.6 2006/11/21 20:13:39 gomor Exp $
#
package Net::Packet::Target;
use strict;
use warnings;

our $VERSION = '1.01';

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
   portList
);
our @AO = qw(
   ip
   ip6
   ipRange
   portRange
);
__PACKAGE__->cgBuildIndices;
__PACKAGE__->cgBuildAccessorsScalar(\@AS);
__PACKAGE__->cgBuildAccessorsArray (\@AA);

no strict 'vars';

use Net::Packet::Utils qw(explodeIps explodePorts getHostIpv4Addr
   getHostIpv6Addr);

sub ip {
   my $self = shift;
   @_ ? do { $self->[$__ip] = getHostIpv4Addr(shift()) }
      : $self->[$__ip];
}

sub ip6 {
   my $self = shift;
   @_ ? do { $self->[$__ip6] = getHostIpv6Addr(shift()) }
      : $self->[$__ip6];
}

sub new {
   my $self = shift->SUPER::new(
      ipList    => [],
      portList  => [],
      @_,
   );

   if ($self->ip) {
      $self->ip(getHostIpv4Addr($self->ip));
   }
   if ($self->ip6) {
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
   ($self->ipRange || $self->portRange) ? 1 : 0;
}

1;

=head1 NAME

Net::Packet::Target - an object for all network related stuff

=head1 SYNOPSIS

   use Net::Packet::Target;

   # Create multiple targets, with multiple port
   my $t1 = Net::Packet::Target->new;
   $t1->ip('www.google.com');
   $t1->portRange('21,22,25,70-90');
   $t1->protocol('tcp');

   print $t1->isMultiple."\n";

   for my $port ($t1->portList) {
      print $t1->ip.' do stuff for port '.$port."\n";
   }

   # Create multiple targets, with only one port
   my $t2 = Net::Packet::Target->new;
   $t2->ipRange('127.0.0.1-10');
   $t2->port(22);
   $t2->protocol('tcp');

   print $t2->isMultiple."\n";

   for my $ip ($t2->ipList) {
      print $t2->port.'/'.$t2->protocol.' do stuff for IPv4 '.$ip."\n";
   }

   # Create a single target
   my $t3 = Net::Packet::Target->new;
   $t3->ip('127.0.0.1');
   $t3->port(22);
   $t3->protocol('tcp');

   print $t3->isMultiple."\n";

   print $t3->port.':'.$t3->protocol.' do stuff for IPv4 '.$t3->ip."\n";

=head1 DESCRIPTION

A B<Net::Packet::Target> object can be used to describe one target, or multiple targets. They are mainly used when you use some automated tasks you which to use on a range of IPs/ports.

To describe multiple targets, you simply enter an IP range, or a port range, or the two. To describe a single target, you enter one IP address, and one port. You can also avoid totally ports, or avoid totally IPs, you do what you want.

It also handles IP name resolution for IPv4 and IPv6, if available.

=head1 ATTRIBUTES

=over 4

=item B<mac> [ (scalar) ]

=item B<port> [ (scalar) ]

=item B<protocol> [ (scalar) ]

=item B<hostname> [ (scalar) ]

These 4 attributes store respectively the target mac address, port, protocol to use for port, and the hostname.

=item B<ipList> [ (arrayref) ]

=item B<portList> [ (arrayref) ]

These 3 attributes store respectively an IPv4 address list, an IPv6 address list, and a port list. All this as array references. When called without parameter, they return an array.

=back

=head1 METHODS

=over 4

=item B<new>

Object constructor. There are no default values, due to the nature of this object.

=item B<isMultiple>

Because a B<Net::Packet::Target> object can be used to describe one target, or multiple ones, we must have a way to know that. This method is used to answer the question. Returns 1 if the object is composed of either multiple IPs, or multiple ports, 0 otherwise.

=item B<ip> [ (scalar) ]

Will take as a parameter an IPv4 address, or a hostname. Without argument, returns the stored value.

=item B<ip6> [ (scalar) ]

Same as previous, for IPv6.

=item B<ipRange> [ (scalar) ]

Will take as a parameter an IPv4 address range. The format is for example: 127.0.0.1-254, or 127.0-10.1.50-70. It will store the result in B<ipList> attribute, to be easily used in a B<for> loop.

=item B<portRange> [ (scalar) ]

Same as previous, but for port ranges. The format is for example: 1-1024, 500-600,100-110. It will store the result in B<portList> attribute, to be easily used ina B<for> loop.

=back

=head1 SEE ALSO

L<Net::Packet>

=head1 AUTHOR

Patrice E<lt>GomoRE<gt> Auffret

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2006, Patrice E<lt>GomoRE<gt> Auffret

You may distribute this module under the terms of the Artistic license.
See LICENSE.Artistic file in the source distribution archive.

=cut
