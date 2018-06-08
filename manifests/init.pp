# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include catbot
class catbot {
  class { 'catbot::install': }
  class { 'catbot::config': }
  class { 'catbot::service': }

  Class['catbot::install'] -> Class['catbot::config']
  Class['catbot::install'] ~> Class['catbot::service']
  Class['catbot::config'] ~> Class['catbot::service']
}
