import json
import sys
import datetime
from pprint import pprint

#usage: python update

if (len(sys.argv) != 5):
	raise Exception("usage: %s <filename.json> <hostconfig> <browsername> <success,fail,inprogress,0=success,1-255=fail>" % sys.argv[0])

hostconfig = sys.argv[2]
browsername = sys.argv[3]
runresult = sys.argv[4]

if (runresult == "0") :
	runresult = "success" 
elif (runresult == "success") :
	runresult = "success" 
elif (runresult == "fail") :
	runresult = "fail"
elif (runresult == "inprogress") :
	runresult = "inprogress"
else:
	runresult = "fail" 


#load in data
try:
	with open(sys.argv[1],"r") as json_file:
		currentResults = json.load(json_file)
except:
	currentResults = json.loads("[]") # empty list if the file is missing/error

newresults = []
#find the old result
# if there, remove it
for testresult in currentResults:
	if not( (testresult["hostconfig"] == hostconfig) and (testresult["browsername"] == browsername) ):
		newresults.append(testresult)
		

#add in current result
newresults.append(  {'hostconfig':hostconfig, 'browsername':browsername, 'runresult':runresult,'whenUTC':datetime.datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%S')} )


date_handler = lambda obj: (
    obj.isoformat()
    if isinstance(obj, datetime.datetime)
    else None
)

with open(sys.argv[1],"w+") as json_file:
		json.dump(newresults,json_file)

 

