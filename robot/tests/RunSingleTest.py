import sys
import commands

if (len(sys.argv) != 4):
        raise Exception("usage: %s <os name> <testdir> <browser>" % sys.argv[0])

OSName = sys.argv[1]
TestDir = sys.argv[2]
browsername = sys.argv[3]

def GetIP(tag) :
     lines = [line.rstrip('\n') for line in open('/etc/qa_hosts') if line.startswith(tag) ]
     return lines[0].split(':')[1]

TestSystemIP = GetIP(OSName)
NginxIP = GetIP("nginx")

print "NGINX IP: "+NginxIP+"<br>"
print "TEST SUITE SYSTEM IP: "+TestSystemIP+"<br>"
print "<br>"

cmd = "./RunSingleTest  %s %s  %s %s %s" % (OSName, TestSystemIP, TestDir, browsername, NginxIP)
print cmd
print "<br>"
print "<br>"

output = commands.getoutput(cmd)
print output
