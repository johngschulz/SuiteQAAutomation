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

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Layer Preview/span_Layers'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Layer Preview/a_Add a new layer'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Layer Preview/span_select2-selection__arrow'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Layer Preview/li_osmosm'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Layer Preview/a_Create new feature type...'))

WebUI.setText(findTestObject('SuiteQAAutomation/Page_GeoServer Layer Preview/input_pname'), 'QAPublic_layer')

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Layer Preview/a_Add new attribute'))

WebUI.setText(findTestObject('SuiteQAAutomation/Page_GeoServer Layer Preview/input_pname'), 'QA')

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Layer Preview/a_Save'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Layer Preview/a_Save'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Layer Preview/a_Compute from data'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Layer Preview/a_Compute from native bounds'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Layer Preview/a_Save'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Layer Preview/a_Add a new layer'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Layer Preview/span_select2-selection__arrow_1'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Layer Preview/li_osmosm_1'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Layer Preview/a_Create new feature type..._1'))

WebUI.setText(findTestObject('SuiteQAAutomation/Page_GeoServer Layer Preview/input_pname'), 'QAPriv_layer')

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Layer Preview/a_Add new attribute_1'))

WebUI.setText(findTestObject('SuiteQAAutomation/Page_GeoServer Layer Preview/input_pname'), 'QA')

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Layer Preview/a_Save_1'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Layer Preview/a_Save_1'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Layer Preview/a_Compute from data_1'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Layer Preview/a_Compute from native bounds_1'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Layer Preview/a_Save'))

WebUI.closeBrowser()

