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
  String $nick = 'CatBot',
  String $username = 'CatBot',
  Optional[String] $realname = undef,
  Enum['true', 'false'] $ssl = 'false', # lint:ignore:quoted_booleans
  Enum['CERT_NONE', 'CERT_REQUIRED', 'CERT_OPTIONAL']
    $ssl_verify = 'CERT_REQUIRED',
  Array[String] $plugins = [],
  Array[String] $autojoins = [],
  String $nickserv_mask = 'NickServ!NickServ@services.*',
  Array[String] $permissions = ['* = view'],
  Array[String] $admin_prefs_defaults = [],
  Array[String] $user_prefs_defaults = [],
  Boolean $debug = false,
  Boolean $verbose = false,
  Optional[String] $aws_access_key_id = undef,
  Optional[String] $aws_secret_access_key = undef,
  String $aws_region = 'us-west-2',
  String $dynamo_table_prefix = 'CatBot_',
  String $config_file = "${catbot::install::home}/catbot.ini",
){
  file { 'Catbot config':
    ensure  => file,
    path    => $config_file,
    owner   => 'catbot',
    mode    => '0770',
    content => epp('catbot/config.ini'),
  }
}
