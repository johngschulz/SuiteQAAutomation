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

WebUI.navigateToUrl('http://localhost:8080/geoserver/web/')

WebUI.setText(findTestObject('Web/GeoServer/Page_GeoServer Welcome/input_username'), 'admin')

WebUI.setText(findTestObject('Web/GeoServer/Page_GeoServer Welcome/input_password'), 'geoserver')

WebUI.click(findTestObject('Web/GeoServer/Page_GeoServer Welcome/span_Login'))

WebUI.click(findTestObject('Web/GeoServer/Page_GeoServer Welcome/span_Server Status'))

WebUI.click(findTestObject('Web/GeoServer/Page_GeoServer Server Status/span_Contact Information'))

WebUI.click(findTestObject('Web/GeoServer/Page_GeoServer Contact Information/span_About GeoServer'))

WebUI.click(findTestObject('Web/GeoServer/Page_GeoServer About GeoServer/span_Process status'))

WebUI.click(findTestObject('Web/GeoServer/Page_GeoServer Process status/a_GeoServer 2.13.0-BSE-00005'))

WebUI.click(findTestObject('Web/GeoServer/Page_GeoServer Welcome/span_Layer Preview'))

WebUI.click(findTestObject('Web/GeoServer/Page_GeoServer Layer Preview/span_Workspaces'))

WebUI.click(findTestObject('Web/GeoServer/Page_GeoServer Workspaces/span_Stores'))

WebUI.click(findTestObject('Web/GeoServer/Page_GeoServer Stores/span_Layers'))

WebUI.click(findTestObject('Web/GeoServer/Page_GeoServer Layers/span_Layer Groups'))

WebUI.click(findTestObject('Web/GeoServer/Page_GeoServer Layer Groups/span_Styles'))

not_run: WebUI.click(findTestObject('Web/GeoServer/Page_GeoServer Styles/span_Backup  Restore'))

WebUI.click(findTestObject('Web/GeoServer/Page_GeoServer Backup  Restore/a_GeoServer 2.13.0-BSE-00005'))

WebUI.click(findTestObject('Web/GeoServer/Page_GeoServer Welcome/span_WFS'))

WebUI.click(findTestObject('Web/GeoServer/Page_GeoServer Web Feature Service/span_WMS'))

WebUI.click(findTestObject('Web/GeoServer/Page_GeoServer Web Map Service/span_WCS'))

WebUI.click(findTestObject('Web/GeoServer/Page_GeoServer Web Coverage Service/span_WMTS'))

WebUI.click(findTestObject('Web/GeoServer/Page_GeoServer Web Map Tile Service/span_WPS'))

WebUI.click(findTestObject('Web/GeoServer/Page_Geoserver Web Processing Service/a_GeoServer 2.13.0-BSE-00005'))

WebUI.click(findTestObject('Web/GeoServer/Page_GeoServer Welcome/span_Global'))

WebUI.click(findTestObject('Web/GeoServer/Page_GeoServer Global Settings/span_Image Processing'))

WebUI.click(findTestObject('Web/GeoServer/Page_GeoServer Image Processing/span_Raster Access'))

WebUI.click(findTestObject('Web/GeoServer/Page_GeoServer Raster Access/a_GeoServer 2.13.0-BSE-00005'))

WebUI.click(findTestObject('Web/GeoServer/Page_GeoServer Welcome/span_Settings'))

WebUI.closeBrowser()

