define tomcat7::webapp($name, $path) {

  file { "/var/lib/tomcat7/webapps/${name}.war":
    owner => 'tomcat7',
    source => $path,
    notify => Service["tomcat7"]
  }

}
