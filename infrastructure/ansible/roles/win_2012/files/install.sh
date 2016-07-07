#!/bin/bash
./jre-8u91-windows-i586.exe /s
sleep 10 # I think tbe above doesn't wait for it to be completed (but it takes <1sec so not sure)

./apache-tomcat-8.0.32.exe /S
sleep 10  # I think tbe above doesn't wait for it to be completed (but it takes <1sec so not sure)

./netCDF4.4.0-NC4-32.exe  /S
sleep 10  # I think tbe above doesn't wait for it to be completed (but it takes <1sec so not sure)

#libjpeg turbo
./libjpeg-turbo-1.4.2-vc.exe /S
sleep 5

#set path for netcdf native lib
"/cygdrive/c/Program Files (x86)/Apache Software Foundation/Tomcat 8.0/bin/Tomcat8.exe" //US//Tomcat8  --Environment="PATH='C:\GDAL;C:\libjpeg-turbo\bin;C:/Program Files (x86)/netCDF 4.4.0/bin'"


#set memory options
#"/cygdrive/c/Program Files (x86)/Apache Software Foundation/Tomcat 8.0/bin/Tomcat8.exe" //US//Tomcat8  --JvmMs=256  --JvmMx=756
"/cygdrive/c/Program Files (x86)/Apache Software Foundation/Tomcat 8.0/bin/Tomcat8.exe" //US//Tomcat8 ++JvmOptions="-XX:+UseConcMarkSweepGC"

#Setup datadir
"/cygdrive/c/Program Files (x86)/Apache Software Foundation/Tomcat 8.0/bin/Tomcat8.exe" //US//Tomcat8  ++JvmOptions="-DGEOSERVER_DATA_DIR=c:\geoserverDataDir"
# "/cygdrive/c/Program Files (x86)/Apache Software Foundation/Tomcat 8.0/bin/Tomcat8.exe" //US//Tomcat8  ++JvmOptions="-DGEOSERVER_DATA_DIR=c:\ProgramData\Boundless\OpenGeo\geoserver\geoserverDataDir"

#setup marlin, put somewhere other than web-inf and update classpath
"/cygdrive/c/Program Files (x86)/Apache Software Foundation/Tomcat 8.0/bin/Tomcat8.exe" //US//Tomcat8  ++JvmOptions="-Xbootclasspath/a:C:\Program Files (x86)\Apache Software Foundation\Tomcat 8.0\webapps\geoserver\WEB-INF\lib\marlin-0.7.3-Unsafe.jar"
"/cygdrive/c/Program Files (x86)/Apache Software Foundation/Tomcat 8.0/bin/Tomcat8.exe" //US//Tomcat8  ++JvmOptions="-Dsun.java2d.renderer=org.marlin.pisces.PiscesRenderingEngine"
"/cygdrive/c/Program Files (x86)/Apache Software Foundation/Tomcat 8.0/bin/Tomcat8.exe" //US//Tomcat8  ++JvmOptions="-Dsun.java2d.renderer.useThreadLocal=false"
"/cygdrive/c/Program Files (x86)/Apache Software Foundation/Tomcat 8.0/bin/Tomcat8.exe" //US//Tomcat8  ++JvmOptions="-Djava.library.path=C:\GDAL';'C:\Program Files (x86)\netCDF 4.4.0\bin';'C:\libjpeg-turbo\bin"
"/cygdrive/c/Program Files (x86)/Apache Software Foundation/Tomcat 8.0/bin/Tomcat8.exe" //US//Tomcat8  ++JvmOptions="-Djna.library.path=C:\Program Files (x86)\netCDF 4.4.0\bin"


#set referencing defaults
"/cygdrive/c/Program Files (x86)/Apache Software Foundation/Tomcat 8.0/bin/Tomcat8.exe" //US//Tomcat8  ++JvmOptions="-Dorg.geotools.referencing.forceXY=true -XX:SoftRefLRUPolicyMSPerMB=36000"



#Enabling spatial reference systems with Imperial units
"/cygdrive/c/Program Files (x86)/Apache Software Foundation/Tomcat 8.0/bin/Tomcat8.exe" //US//Tomcat8  ++JvmOptions="-Dorg.geotoools.render.lite.scale.unitCompensation=true"

#Install Java Cryptography Extension Unlimited Strength Jurisdiction Policy File
unzip -oj jce_policy-8.zip -d "/cygdrive/c/Program Files (x86)/Java/jre1.8.0_91/lib/security"


net start Tomcat8
sc config Tomcat8 start=auto

