# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include catbot::install
class catbot::install (
  String $home = '/opt/catbot',
  String $git_deploy_key,
  String $git_repo = 'git@github.com:brwyatt/catbot.git',
){
  include ::git
  include ::python

  Exec {
    path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  }

  user { 'catbot':
    ensure         => 'present',
    home           => $home,
    managehome     => true,
    password       => '!',
    purge_ssh_keys => true,
    system         => true,
    shell          => '/bin/false',
  }

  file { "${home}/.ssh":
    ensure => directory,
    owner  => 'catbot',
    mode   => '0775',
  }

  file { "${home}/.ssh/id_rsa":
    ensure  => file,
    owner   => 'catbot',
    mode    => '0400',
    content => $git_deploy_key,
  }

  exec { 'Clone catbot repo':
    command => "git clone '${git_repo}' catbot",
    unless  => '[ -d catbot/.git ]',
    cwd     => $home,
    user    => 'catbot',
    require => [Class['git'], File["${home}/.ssh/id_rsa"]],
  }
}
