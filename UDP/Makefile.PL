require 5.001;		# demand tag support in Exporter.pm
use ExtUtils::MakeMaker qw(:DEFAULT %att);
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'Net::UDP',
    'VERSION'	=> '0.51-alpha',
    'LIBS'	=> [''],   # e.g., '-lm' 
    'DEFINE'	=> '',     # e.g., '-DHAVE_SOMETHING' 
    'INC'	=> '',     # e.g., '-I/usr/include/other' 
    'SKIP'	=> [qw(dynamic dynamic_bs dynamic_lib dlsyms perldepend
		       makeaperl static static_lib)],
);

sub MY::linkext {
    "
linkext static dynamic ::
";
}
