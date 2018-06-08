# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include catbot::config
class catbot::config (
  String $irc_host,
  Variant[String, Integer] $irc_port,
  String $nickserv_password,
  String $username = 'CatBot',
  String $nick = 'CatBot',
  Enum['true', 'false'] $ssl = 'false', # lint:ignore:quoted_booleans
  Enum['CERT_NONE', 'CERT_REQUIRED', 'CERT_OPTIONAL'] $ssl_verify = 'CERT_REQUIRED',
  Array[String] $plugins = [],
  Array[String] $autojoins = [],
  String $nickserv_mask = 'NickServ!NickServ@services.*',
  String $config_file = "${catbot::install::home}/catbot.ini",
){
  file { $config_file:
    ensure => file,
    owner  => 'catbot',
    mode   => '0770',
  }

  # bot section
  ini_setting { 'bot - nick':
    ensure  => present,
    section => 'bot',
    setting => 'nick',
    value   => $nick,
    path    => $config_file,
  }
  ini_setting { 'bot - username':
    ensure  => present,
    section => 'bot',
    setting => 'username',
    value   => $username,
    path    => $config_file,
  }
  ini_setting { 'bot - host':
    ensure  => present,
    section => 'bot',
    setting => 'host',
    value   => $irc_host,
    path    => $config_file,
  }
  ini_setting { 'bot - port':
    ensure  => present,
    section => 'bot',
    setting => 'port',
    value   => $irc_port,
    path    => $config_file,
  }
  ini_setting { 'bot - ssl':
    ensure  => present,
    section => 'bot',
    setting => 'ssl',
    value   => $ssl,
    path    => $config_file,
  }
  ini_setting { 'bot - ssl_verify':
    ensure  => present,
    section => 'bot',
    setting => 'ssl_verify',
    value   => $ssl_verify,
    path    => $config_file,
  }
  ini_setting { 'bot - includes':
    ensure  => present,
    section => 'bot',
    setting => 'includes',
    value   => join($plugins, "\n    "),
    path    => $config_file,
  }
  ini_setting { 'bot - autojoins':
    ensure  => present,
    section => 'bot',
    setting => 'autojoins',
    # lint:ignore:single_quote_string_with_variables
    value   => join(prefix($autojoins, '${#}'), "\n    "),
    # lint:endignore
    path    => $config_file,
  }

  File[$config_file] -> Ini_setting <| path == $config_file |>
}
