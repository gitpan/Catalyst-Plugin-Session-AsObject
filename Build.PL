use strict;
use warnings;

use Module::Build;

my $builder = Module::Build->new
    ( module_name        => 'Catalyst::Plugin::Session::AsObject',
      license            => 'perl',
      requires           => { 'Catalyst::Plugin::Session' => '0.20' },
      build_requires     => { 'Test::More' => '0',
                            },
      create_readme      => 1,
      sign               => 1,
      create_makefile_pl => 'traditional',
    );

$builder->create_build_script();
