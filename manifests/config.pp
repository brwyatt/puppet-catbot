# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include catbot::config
class catbot::config (
  Optional[String] $aws_access_key_id = undef,
  Optional[String] $aws_secret_access_key = undef,
  String $aws_region = 'us-west-2',
  String $dynamo_table = 'CatBot',
  String $config_file = "${catbot::install::home}/boto.json",
){
  file { 'Catbot config':
    ensure  => file,
    path    => $config_file,
    owner   => 'catbot',
    mode    => '0770',
    content => epp('catbot/boto.json'),
  }
}
