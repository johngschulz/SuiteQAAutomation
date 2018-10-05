import static com.kms.katalon.core.checkpoint.CheckpointFactory.findCheckpoint
import static com.kms.katalon.core.testcase.TestCaseFactory.findTestCase
import static com.kms.katalon.core.testdata.TestDataFactory.findTestData
import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.checkpoint.Checkpoint as Checkpoint
import com.kms.katalon.core.checkpoint.CheckpointFactory as CheckpointFactory
import com.kms.katalon.core.mobile.keyword.MobileBuiltInKeywords as MobileBuiltInKeywords
import com.kms.katalon.core.mobile.keyword.MobileBuiltInKeywords as Mobile
import com.kms.katalon.core.model.FailureHandling as FailureHandling
import com.kms.katalon.core.testcase.TestCase as TestCase
import com.kms.katalon.core.testcase.TestCaseFactory as TestCaseFactory
import com.kms.katalon.core.testdata.TestData as TestData
import com.kms.katalon.core.testdata.TestDataFactory as TestDataFactory
import com.kms.katalon.core.testobject.ObjectRepository as ObjectRepository
import com.kms.katalon.core.testobject.TestObject as TestObject
import com.kms.katalon.core.webservice.keyword.WSBuiltInKeywords as WSBuiltInKeywords
import com.kms.katalon.core.webservice.keyword.WSBuiltInKeywords as WS
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUiBuiltInKeywords
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import internal.GlobalVariable as GlobalVariable
import groovy.json.JsonSlurper
import com.kms.katalon.core.logging.KeywordLogger

/*Check the module status endpoint for the expected modules. List of modules is fixed for now,
 * drawn from a current BSE installation.
 */
KeywordLogger log = new KeywordLogger()

def expectedModules = ['GeoServer Web Coverage Service 2.0', 'GeoServer Main', 'Rendering Engine', 'system-properties', 'system-environment'
    , 'GeoServer Web Map Service', 'GeoServer Web Coverage Service 1.1', 'Backup Rstore Extensions', 'GeoServer Web UI Web Processing Service'
    , 'GeoServer Security LDAP', 'GeoServer Web Demos', 'GeoServer Web UI Web Feature Service', 'GeoServer Web UI Security LDAP'
    , 'GeoServer Web UI Web Coverage Service', 'GeoServer Web Processing Service Core', 'Backup/Restore Web', 'GeoWeb Cache'
    , 'ImageI/O-Ext GDAL Coverage Extension', 'GeoServer Web UI GeoWebCache', 'GeoServer KML', 'GeoServer Security JDBC'
    , 'GeoServer Web UI Security Core', 'GeoServer Web Feature Service', 'GeoServer Web UI Web Map Service', 'GeoServer Web UI Core'
    , 'GeoServer Web Coverage Service 1.0', 'GeoServer Web REST', 'GeoServer Web UI Security JDBC', 'GeoServer Web Coverage Service']

def about = WS.sendRequest(findTestObject('Api/GeoServer/rest-about_GET_json'))
assert about.getStatusCode() == 200

def parser = new JsonSlurper()
def aboutObj = parser.parseText(about.getResponseText())

for (module in expectedModules) {
	def found = false
	for (responseModule in aboutObj.statuss.status) {
		found = responseModule.name == module
		if (found) {
			log.logInfo("Found module: " + module)
			break
		}
	}
	
	if (!found) {
		log.logError("The following expected module was not found: " + module)
	}
	assert found
}
