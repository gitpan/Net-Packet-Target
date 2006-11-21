#!/usr/bin/perl
use strict;
use warnings;

use Net::Packet::Target;

my $t2 = Net::Packet::Target->new; 
$t2->ipRange('127.0.0.1-10');
$t2->port(22);
$t2->protocol('tcp');

print $t2->isMultiple."\n";

for my $ip ($t2->ipList) {
   print $t2->port.'/'.$t2->protocol.' do stuff for IPv4 '.$ip."\n";
}
