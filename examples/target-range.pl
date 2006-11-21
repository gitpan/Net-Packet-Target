#!/usr/bin/perl
use strict;
use warnings;

use Net::Packet::Target;
my $target = Net::Packet::Target->new;
$target->portRange('20-25');
$target->ipRange('127.0.0.1-10');

print $target->cgDumper."\n";
