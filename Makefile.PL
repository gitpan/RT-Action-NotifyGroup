use lib qw(.);
use inc::Module::Install;

$ENV{'WITH_SUBDIRS'} = 'sbin,lib';
RTx                     ('RT-Action-NotifyGroup');
author                  ('Ruslan U. Zakirov <cubic@wildgate.miee.ru>');
license                 ('perl');

requires                ('Getopt::Long');
requires                ('Storable');

my ($lp) = $INC{'RT.pm'} =~ /^(.*)[\\\/]/;
my $lib_path = join( ' ', "$RT::LocalPath/lib", $lp );
print `./configure --with-rt-lib='$lib_path'`;

skip( qr/\.in$/ );

&WriteAll;
