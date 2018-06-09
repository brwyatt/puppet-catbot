# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include catbot::service
class catbot::service {
  ::systemd::unit_file { 'catbot.service':
    content => epp('catbot/catbot.service.epp'),
  } ~>
  service { 'catbot':
    ensure => running,
  }
}
