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

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Layers/span_Layers'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Layers/span_ne_10m_admin_0_countries'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Edit Layer/span_Tile Caching'))

WebUI.setText(findTestObject('SuiteQAAutomation/Page_GeoServer Edit Layer/input_tabspaneltileLayerEditor'), 'FOO')

WebUI.selectOptionByValue(findTestObject('SuiteQAAutomation/Page_GeoServer Edit Layer/select_Choose OneList of Strin'), 
    '0', true)

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Edit Layer/img'))

WebUI.setText(findTestObject('SuiteQAAutomation/Page_GeoServer Edit Layer/input_tabspaneltileLayerEditor_1'), 'Test')

WebUI.setText(findTestObject('SuiteQAAutomation/Page_GeoServer Edit Layer/textarea_tabspaneltileLayerEdi'), 'Test')

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Edit Layer/a_Save'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Layers/span_ne_10m_admin_0_countries'))

WebUI.delay(3)

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Edit Layer/span_Tile Caching1'))

WebUI.setText(findTestObject('SuiteQAAutomation/Page_GeoServer Edit Layer/input_tabspaneltileLayerEditor'), 'BAR')

WebUI.selectOptionByValue(findTestObject('SuiteQAAutomation/Page_GeoServer Edit Layer/select_Choose OneList of Strin_1'), 
    '1', true)

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Edit Layer/img'))

WebUI.setText(findTestObject('SuiteQAAutomation/Page_GeoServer Edit Layer/input_tabspaneltileLayerEditor_2'), '123')

WebUI.setText(findTestObject('SuiteQAAutomation/Page_GeoServer Edit Layer/textarea_tabspaneltileLayerEdi_1'), '123')

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Edit Layer/a_Save'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Layers/span_ne_10m_admin_0_countries'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Edit Layer/span_Tile Caching2'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Edit Layer/img_1'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Edit Layer/a_Save'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Layers/span_ne_10m_admin_0_countries'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Edit Layer/span_Tile Caching3'))

WebUI.verifyTextPresent('Test', true)

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Edit Layer/a_Save'))

WebUI.closeBrowser()

