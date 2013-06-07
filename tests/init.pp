node default {

   class { 'tomcat7':
      jre => 'openjdk-7',
   }

   tomcat7::webapp { "SimpleServlet":
      path => 'puppet:///modules/tomcat7/tests/SimpleServlet.war'
   }

   # repeat as desired for different servlets ...

}
