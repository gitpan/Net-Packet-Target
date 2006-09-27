use ExtUtils::MakeMaker;

WriteMakefile(
   NAME          => 'Net::Packet::Target',
   VERSION_FROM  => 'lib/Net/Packet/Target.pm',
   PREREQ_PM     => {
      Class::Gomor  => '1.00',
      Net::Packet   => '3.00',
   },
   #ABSTRACT_FROM => 'lib/Net/Packet/Target.pm',
   AUTHOR        => 'GomoR <perl@gomor.org>',
);
