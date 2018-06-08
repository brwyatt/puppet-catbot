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
  String $git_branch = 'master',
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

  $ssh_dir = "${home}/.ssh"
  $ssh_key = "${ssh_dir}/id_rsa"
  $ssh_known_hosts = "${ssh_dir}/known_hosts"

  file { $ssh_dir:
    ensure => directory,
    owner  => 'catbot',
    mode   => '0775',
  }

  file { $ssh_key:
    ensure  => file,
    owner   => 'catbot',
    mode    => '0600',
    content => $git_deploy_key,
  }

  file { $ssh_known_hosts:
    ensure => file,
    owner  => 'catbot',
    mode   => '0600',
  }

  file_line { 'github_host_key':
    path => $ssh_known_hosts,
    line => 'github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==',
  }

  exec { 'Clone catbot repo':
    command => "git clone '${git_repo}' catbot",
    unless  => '[ -d catbot/.git ]',
    cwd     => $home,
    user    => 'catbot',
    require => [Class['git'], File[$ssh_key], File[$ssh_known_hosts]],
  }

  exec { 'Update catbot repo':
    command => "bash -c 'git clean -dfx && git checkout \"${git_branch}\" && git reset --hard \"origin/${git_branch}\" && git clean -dfx'",
    unless  => "bash -c 'git fetch && git status | grep \"On branch ${git_branch}\" && git status | grep \"Your branch is up-to-date with \"'",
    cwd     => "${home}/catbot",
    user    => 'catbot',
    require => Exec['Clone catbot repo'],
  }
}
