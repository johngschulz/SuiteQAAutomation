#!/bin/bash
unzip '/cygdrive/c/Program Files (x86)/Apache Software Foundation/Tomcat 8.0/webapps/geoserver.war' -d '/cygdrive/c/Program Files (x86)/Apache Software Foundation/Tomcat 8.0/webapps/geoserver'

for f in ~/BoundlessSuite-latest-ext/*;
  do
    [ -d $f ] && cp "$f"/* '/cygdrive/c/Program Files (x86)/Apache Software Foundation/Tomcat 8.0/webapps/geoserver/WEB-INF/lib/'
  done;
  
cp -f -r '/cygdrive/c/Program Files (x86)/Boundless/suite/geoserver/gdal/gdal-1.11.2.jar' '/cygdrive/c/Program Files (x86)/Apache Software Foundation/Tomcat 8.0/webapps/geoserver/WEB-INF/lib/'