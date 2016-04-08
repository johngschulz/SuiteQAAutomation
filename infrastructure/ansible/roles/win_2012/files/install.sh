#!/bin/bash
./jre-8u73-windows-x64.exe /s
sleep 10 # I think tbe above doesn't wait for it to be completed (but it takes <1sec so not sure)
./apache-tomcat-8.0.32.exe /S
sleep 10  # I think tbe above doesn't wait for it to be completed (but it takes <1sec so not sure)

#set memory options
"/cygdrive/c/Program Files/Apache Software Foundation/Tomcat 8.0/bin/Tomcat8.exe" //US//Tomcat8  --JvmMs=256  --JvmMx=756

#Setup datadir
unzip -o /cygdrive/c/geoserverDataDir.zip -d /cygdrive/c/
"/cygdrive/c/Program Files/Apache Software Foundation/Tomcat 8.0/bin/Tomcat8.exe" //US//Tomcat8  ++JvmOptions="-DGEOSERVER_DATA_DIR=c:\geoserverDataDir"

#setup marlin, put somewhere other than web-inf and update classpath
"/cygdrive/c/Program Files/Apache Software Foundation/Tomcat 8.0/bin/Tomcat8.exe" //US//Tomcat8  ++JvmOptions="-Xbootclasspath/a:C:\Program Files\Apache Software Foundation\Tomcat 8.0\webapps\geoserver\WEB-INF\lib\marlin-0.7.3-Unsafe.jar"
"/cygdrive/c/Program Files/Apache Software Foundation/Tomcat 8.0/bin/Tomcat8.exe" //US//Tomcat8  ++JvmOptions="-Dsun.java2d.renderer=org.marlin.pisces.PiscesRenderingEngine"
"/cygdrive/c/Program Files/Apache Software Foundation/Tomcat 8.0/bin/Tomcat8.exe" //US//Tomcat8  ++JvmOptions="-Dsun.java2d.renderer.useThreadLocal=false"


#set referencing defaults
"/cygdrive/c/Program Files/Apache Software Foundation/Tomcat 8.0/bin/Tomcat8.exe" //US//Tomcat8  ++JvmOptions="-Dorg.geotools.referencing.forceXY=true"

#libjpeg turbo
./libjpeg-turbo-1.4.2-vc64.exe /S
setx /M PATH "/$PATH;C:\libjpeg-turbo64/"

#Enabling spatial reference systems with Imperial units
"/cygdrive/c/Program Files/Apache Software Foundation/Tomcat 8.0/bin/Tomcat8.exe" //US//Tomcat8  ++JvmOptions="-Dorg.geotoools.render.lite.scale.unitCompensation=true"

#Install Java Cryptography Extension Unlimited Strength Jurisdiction Policy File
unzip -oj jce_policy-8.zip -d "/cygdrive/c/Program Files/Java/jre1.8.0_73/lib/security"


net start Tomcat8
sc config Tomcat8 start=auto
