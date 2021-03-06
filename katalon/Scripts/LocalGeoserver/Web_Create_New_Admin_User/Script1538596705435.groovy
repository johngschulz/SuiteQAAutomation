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

WebUI.click(findTestObject('Web/GeoServer/Page_GeoServer Welcome/span_Users Groups Roles'))

WebUI.click(findTestObject('Web/GeoServer/Page_GeoServer Users Groups and Rol/span_UsersGroups'))

WebUI.click(findTestObject('Web/GeoServer/Page_GeoServer Users Groups and Rol/a_Add new user'))

WebUI.setText(findTestObject('Web/GeoServer/Page_GeoServer Add a new user/input_username'), 'QAAdmin')

WebUI.setText(findTestObject('Web/GeoServer/Page_GeoServer Add a new user/input_password'), 'QA')

WebUI.setText(findTestObject('Web/GeoServer/Page_GeoServer Add a new user/input_confirmPassword'), 'QA')

WebUI.click(findTestObject('Web/GeoServer/Page_GeoServer Add a new user/a_Save'))

WebUI.closeBrowser()
