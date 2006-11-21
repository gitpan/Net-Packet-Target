#!/usr/bin/perl
use strict;
use warnings;

use Net::Packet::Target;

my $t1 = Net::Packet::Target->new;
$t1->ip('www.google.com');
$t1->portRange('21,22,25,70-90');
$t1->protocol('tcp');

print $t1->isMultiple."\n";

for my $port ($t1->portList) {
   print $t1->ip.' do stuff for port '.$port."\n";
}
