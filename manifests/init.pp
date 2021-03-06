# = Class: tomcat7
# 
# This class installs/configures/manages the Tomcat v7 Java application server.
# Only supported on Debian-derived OSes.
# 
# == Parameters: 
#
# $enable::     Whether to start the Tomcat service on boot. Defaults to
#               true. Valid values: true and false. 
# $ensure::     Whether to run the Tomcat service. Defaults to running.
#               Valid values: running and stopped. 
# $http_port::  Port to configure the HTTP connector with. Defaults to 8080.
# $https_port:: Port to configure the HTTPS connector with. Defaults to 8443.
# $jre::        JRE package to depend on. Defaults to 'default'. Suggested
#               values: 'openjdk-6', 'openjdk-7', 'sun-java6', 'oracle-java7'
# $install_admin:: Whether to install the tomcat7-admin package. Defaults to
#                  true. Valid values: true and false.
# 
# == Requires: 
# 
# Nothing.
# 
# == Sample Usage:
#
#   class {'tomcat7':
#     http_port => 80,
#     jre => 'openjdk-7',
#   }
#   class {'tomcat7':
#     enable => false,
#     ensure => stopped,
#   }
#

class tomcat7 (
    $enable           = true,
    $ensure           = running,
    $http_port        = 8080,
    $https_port       = 8443,
    $install_admin    = true,
    $xmx              = '1G',
    $xms              = '256M',
    $tomcatUsername  = 'tomcat',
    $tomcatPassword  = 'tomcat',
    $jenkinsUsername = 'jenkins',
    $jenkinsPassword = 'jenkins'
) {

  package { 'tomcat7':
    ensure  => installed,
    require => [
      File['/etc/default/tomcat7'],
      Package['authbind'],
      Package['libtcnative'],
    ],
  }

  if ($install_admin) {
    package { 'tomcat7-admin':
      ensure  => installed,
      require => Package['tomcat7'],
    }
  }

  package { 'libtcnative':
    name => 'libtcnative-1',
  }

  package { 'authbind':
  }

  file { '/etc/tomcat7/server.xml':
     owner   => 'root',
     require => Package['tomcat7'],
     notify  => Service['tomcat7'],
     content => template('tomcat7/server.xml.erb'),
  }

  file { '/etc/default/tomcat7':
    owner   => 'root',
    notify  => Service['tomcat7'],
    content => template('tomcat7/default.erb'),
  }

  service { 'tomcat7':
    ensure  => $ensure,
    enable  => $enable,
    require => Package['tomcat7'],
  }

  file { '/var/lib/tomcat7/conf/tomcat-users.xml':
    require => Package['tomcat7'],
    content => template('tomcat7/tomcat-users.xml.erb'),
    ensure  => present,
  }

}
