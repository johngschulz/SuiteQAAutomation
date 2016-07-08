#!/usr/bin/env python
# -*- coding: UTF-8 -*-

# enable debugging
import cgitb
cgitb.enable()

from cgi import escape
import urlparse
import sys, os
import re
import commands

def letters(input):
    return re.sub(r"[^A-Za-z_]+", '', input)

ok_server = ['centos','win2012','ubuntu']
ok_browser = ['OTHER','IE','Edge','Chrome','FireFox']

print "Content-Type: text/html\n"

query = urlparse.parse_qs(os.environ.get("QUERY_STRING") )

if not('server' in query):
    print "no server in query_string";
    exit()

if not('testdir' in query):
    print "no testdir in query_string";
    exit()

if not('browser' in query):
    print "no browser in query_string";
    exit()

server = query['server'][0]
testdir = letters(query['testdir'][0])
browser = query['browser'][0]

if not (server in ok_server) :
       print "server is not in the list of ok servers:"+(','.join(ok_server));
       exit()

if not (browser in ['OTHER','IE','Edge','Chrome','FireFox']) :
       print "browser is not in the list of ok browsers: "+(','.join(ok_browser));
       exit()

print "server: " + server + "<br>"
print "testdir: " + testdir + "<br>"
print "browser: "+ browser + "<br>"

print "<br><br>"

cmd =  "ssh ec2-user@10.0.16.75 'run_testdir %s %s %s'" % (server,testdir, browser)

print "user:"+ commands.getoutput("whoami")+"<br>"

print "executing: "+cmd
output = commands.getoutput(cmd)

print "<br><br>"
print output