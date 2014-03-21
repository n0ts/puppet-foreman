# Public: Install foreman
class foreman(
  $ensure = 'present',
  $root   = $foreman::params::root,
  $user   = $foreman::params::user
) inherits foreman::params {

  validate_re($ensure, '^(present|absent)$')

  if $ensure == 'present' {
    file {
      $root:
        ensure => directory,
        owner  => $user;
    }

    $curl = 'curl -s http://assets.foreman.io/foreman/foreman.tgz'
    $tar  = 'tar zxv - --strip-components 1'

    exec { 'install foreman standalone':
      command => "${curl} | ${tar}",
      cwd     => $root,
      creates => "${root}/bin/foreman",
      user    => $user
    }
  } else {
    exec { 'uninstall foreman standalone':
      command => "rm -rf ${root}",
      unless  => "test -d ${root}",
      user    => $user
    }
  }

  case $::osfamily {
    Darwin: {
      include boxen::config

      file { "${boxen::config::envdir}/foreman.sh":
        ensure => absent,
      }

      boxen::env_script { 'foreman':
        ensure   => $ensure,
        priority => 'lower',
        source   => 'puppet:///modules/foreman/foreman.sh',
      }

    }

    default: {
      # nothing
    }
  }

}
