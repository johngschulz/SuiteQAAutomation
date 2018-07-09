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
import com.kms.katalon.core.testobject.RestRequestObjectBuilder

'Basic sanity tests of OGC capability docs'
def requestBuilder = new RestRequestObjectBuilder()
requestBuilder.withRestRequestMethod("GET")

'Test WMS 1.1.1'
def wmsResponse = WS.sendRequest(
	requestBuilder.withRestUrl(
		"http://localhost:8080/geoserver/ows?service=wms&version=1.1.1&request=GetCapabilities").build())
assert wmsResponse.getStatusCode() == 200
WS.containsString(wmsResponse, "WMT_MS_Capabilities", false)

'Test WMS 1.3'
wmsResponse = WS.sendRequest(
	requestBuilder.withRestUrl(
		"http://localhost:8080/geoserver/ows?service=wms&version=1.3.0&request=GetCapabilities").build())
assert wmsResponse.getStatusCode() == 200
WS.containsString(wmsResponse, "<Service>", false)

'Test WFS 1.0'
wmsResponse = WS.sendRequest(
	requestBuilder.withRestUrl(
		"http://localhost:8080/geoserver/ows?service=wfs&version=1.0.0&request=GetCapabilities").build())
assert wmsResponse.getStatusCode() == 200
WS.containsString(wmsResponse, "WFS_Capabilities", false)

'Test WFS 1.1'
wmsResponse = WS.sendRequest(
	requestBuilder.withRestUrl(
		"http://localhost:8080/geoserver/ows?service=wfs&version=1.1.0&request=GetCapabilities").build())
assert wmsResponse.getStatusCode() == 200
WS.containsString(wmsResponse, "WFS_Capabilities", false)

'Test WFS 1.3'
wmsResponse = WS.sendRequest(
	requestBuilder.withRestUrl(
		"http://localhost:8080/geoserver/ows?service=wfs&version=2.0.0&request=GetCapabilities").build())
assert wmsResponse.getStatusCode() == 200
WS.containsString(wmsResponse, "WFS_Capabilities", false)

'Test WCS 2.0.1'
wmsResponse = WS.sendRequest(
	requestBuilder.withRestUrl(
		"http://localhost:8080/geoserver/ows?service=WCS&version=2.0.1&request=GetCapabilities").build())
assert wmsResponse.getStatusCode() == 200
WS.containsString(wmsResponse, "wcs:Capabilities", false)

'Test WCS 1.1.1'
wmsResponse = WS.sendRequest(
	requestBuilder.withRestUrl(
		"http://localhost:8080/geoserver/ows?service=wcs&version=1.1.1&request=GetCapabilities").build())
assert wmsResponse.getStatusCode() == 200
WS.containsString(wmsResponse, "wcs:Capabilities", false)


