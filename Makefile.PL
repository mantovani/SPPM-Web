#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install;
use Module::Install::Catalyst; # Complain loudly if you don't have
                               # Catalyst::Devel installed or haven't said
                               # 'make dist' to create a standalone tarball.

name 'SPPM-Web';
all_from 'lib/SPPM/Web.pm';

requires 'Catalyst::Runtime' => '5.80029';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Plugin::Cache';

requires 'Catalyst::Action::RenderView';
requires 'Moose';
requires 'namespace::autoclean';
requires 'Catalyst::View::TT';
requires 'HTML::FormHandler::Model::DBIC';
requires 'parent';
requires 'Config::General'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats
test_requires 'Test::More' => '0.88';
requires 'CatalystX::Declare';
requires 'Calendar::Simple';
requires 'Pod::Xhtml';
requires 'Date::Calc';
requires 'Class::CSV';
requires 'Cache::FileCache';
requires 'DateTime';
requires 'B::Hooks::OP::Check';
requires 'DBIx::Class::ForceUTF8';
requires 'HTML::FormHandler::Moose';
requires 'DateTime::Format::MySQL';
requires 'Catalyst::Controller::reCAPTCHA';
requires 'Catalyst::Plugin::Unicode::Encoding';

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
