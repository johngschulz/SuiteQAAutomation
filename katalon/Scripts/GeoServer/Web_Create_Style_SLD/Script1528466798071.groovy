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

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Welcome/span_Styles'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer Styles/a_Add a new style'))

WebUI.setText(findTestObject('SuiteQAAutomation/Page_GeoServer New style/input_contextpanelname'), 'QASLD')

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer New style/span_select2-selection__arrow'))

WebUI.setText(findTestObject('SuiteQAAutomation/Page_GeoServer New style/input_select2-search__field'), 'osm')

WebUI.sendKeys(findTestObject('SuiteQAAutomation/Page_GeoServer New style/input_select2-search__field'), Keys.chord(Keys.ENTER))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer New style/span_select2-selection__arrow_1'))

WebUI.setText(findTestObject('SuiteQAAutomation/Page_GeoServer New style/input_select2-search__field'), 'Point')

WebUI.sendKeys(findTestObject('SuiteQAAutomation/Page_GeoServer New style/input_select2-search__field'), Keys.chord(Keys.ENTER))

WebUI.delay(5)

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer New style/a_Generate ...'))

WebUI.click(findTestObject('SuiteQAAutomation/Page_GeoServer New style/a_Submit'))

WebUI.closeBrowser()

