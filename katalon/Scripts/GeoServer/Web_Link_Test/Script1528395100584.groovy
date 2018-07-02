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
import org.openqa.selenium.Keys as Keys

WebUI.openBrowser('')

WebUI.navigateToUrl('http://af501c704591111e8b8f7065700e1327-1853243844.us-west-2.elb.amazonaws.com/geoserver/web/')

WebUI.setText(findTestObject('SuiteQAAutomation/Page_GeoServer Welcome/input_username'), 'admin')

WebUI.setText(findTestObject('SuiteQAAutomation/Page_GeoServer Welcome/input_password'), 'geoserver')

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Welcome/span_Login'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Welcome/span_Server Status'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Server Status/span_Contact Information'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Contact Information/span_About GeoServer'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer About GeoServer/span_Process status'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Process status/a_GeoServer 2.13.0-BSE-00005'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Welcome/span_Layer Preview'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Layer Preview/span_Workspaces'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Workspaces/span_Stores'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Stores/span_Layers'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Layers/span_Layer Groups'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Layer Groups/span_Styles'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Styles/span_Backup  Restore'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Backup  Restore/a_GeoServer 2.13.0-BSE-00005'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Welcome/span_WFS'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Web Feature Service/span_WMS'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Web Map Service/span_WCS'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Web Coverage Service/span_WMTS'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Web Map Tile Service/span_WPS'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Web Processing Servi/a_GeoServer 2.13.0-BSE-00005'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Welcome/span_Global'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Global Settings/span_Image Processing'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Image Processing/span_Raster Access'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Raster Access/a_GeoServer 2.13.0-BSE-00005'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Welcome/span_Settings'))

WebUI.closeBrowser()

