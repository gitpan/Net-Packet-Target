#!/usr/bin/perl
use strict;
use warnings;

use Net::Packet::Target;

my $t3 = Net::Packet::Target->new;
$t3->ip('127.0.0.1');
$t3->port(22);
$t3->protocol('tcp');

print $t3->isMultiple."\n";

print $t3->port.':'.$t3->protocol.' do stuff for IPv4 '.$t3->ip."\n";
