#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install;

name 'SPPM-Web';
all_from 'lib/SPPM/Web.pm';

requires 'Catalyst::Runtime' => '5.80015';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Plugin::Cache';
requires 'Catalyst::Plugin::Unicode';
requires 'Catalyst::Action::RenderView';
requires 'parent';
requires 'Config::General'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats

requires 'CatalystX::Declare';
requires 'Calendar::Simple';
requires 'Pod::Xhtml';

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
