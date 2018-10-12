class foreman::config::puma(
  Stdlib::Absolutepath $app_root = $::foreman::app_root,
  Optional[String] $listen_on_interface = $::foreman::passenger_interface,
  Optional[String] $ruby = $::foreman::passenger_ruby,
  String $priority = $::foreman::vhost_priority,
  Stdlib::Fqdn $servername = $::foreman::servername,
  Array[Stdlib::Fqdn] $serveraliases = $::foreman::serveraliases,
  Stdlib::Port $server_port = $::foreman::server_port,
  Stdlib::Port $server_ssl_port = $::foreman::server_ssl_port,
  Boolean $ssl = $::foreman::ssl,
  Stdlib::Absolutepath $ssl_ca = $::foreman::server_ssl_ca,
  Stdlib::Absolutepath $ssl_chain = $::foreman::server_ssl_chain,
  Stdlib::Absolutepath $ssl_cert = $::foreman::server_ssl_cert,
  Variant[Enum[''], Stdlib::Absolutepath] $ssl_certs_dir = $::foreman::server_ssl_certs_dir,
  Stdlib::Absolutepath $ssl_key = $::foreman::server_ssl_key,
  Variant[Enum[''], Stdlib::Absolutepath] $ssl_crl = $::foreman::server_ssl_crl,
  Optional[String] $ssl_protocol = $::foreman::server_ssl_protocol,
  Boolean $use_vhost = $::foreman::use_vhost,
  String $user = $::foreman::user,
  Boolean $prestart = $::foreman::passenger_prestart,
  Integer[0] $min_instances = $::foreman::passenger_min_instances,
  Integer[0] $start_timeout = $::foreman::passenger_start_timeout,
  Stdlib::HTTPUrl $foreman_url = $::foreman::foreman_url,
  Boolean $keepalive = $::foreman::keepalive,
  Integer[0] $max_keepalive_requests = $::foreman::max_keepalive_requests,
  Integer[0] $keepalive_timeout = $::foreman::keepalive_timeout,
  Optional[String] $access_log_format = undef,
  Boolean $ipa_authentication = $::foreman::ipa_authentication,
) {
  $docroot = "${app_root}/public"

  include ::apache

  $proxy_pass_https = [
    {
      'no_proxy_uris' => ['/pulp', '/streamer', '/pub'],
      'path'          => '/',
      'url'           => "http://localhost:3000/",
      'params'        => {'retry' => '0'},
    }
  ]

  apache::vhost { 'foreman-ssl':
    add_default_charset     => 'UTF-8',
    docroot                 => $docroot,
    manage_docroot          => false,
    ip                      => $listen_interface,
    options                 => ['SymLinksIfOwnerMatch'],
    port                    => $server_ssl_port,
    priority                => $priority,
    ssl                     => true,
    ssl_cert                => $ssl_cert,
    ssl_certs_dir           => $ssl_certs_dir,
    ssl_key                 => $ssl_key,
    ssl_chain               => $ssl_chain,
    ssl_ca                  => $ssl_ca,
    ssl_crl                 => $ssl_crl_real,
    ssl_crl_check           => $ssl_crl_check,
    ssl_protocol            => $ssl_protocol,
    ssl_verify_client   => 'optional',
    ssl_options             => '+StdEnvVars +ExportCertData',
    ssl_verify_depth    => '3',
    keepalive               => $keepalive_onoff,
    max_keepalive_requests  => $max_keepalive_requests,
    keepalive_timeout       => $keepalive_timeout,
    access_log_format       => $access_log_format,
    additional_includes     => ["${::apache::confd_dir}/${priority}-foreman-ssl.d/*.conf"],
    use_optional_includes   => true,
    ssl_proxyengine     => true,
    proxy_pass          => $proxy_pass_https,
    proxy_preserve_host => true,
    request_headers     => ["set X_FORWARDED_PROTO 'https'"],
  }

}
