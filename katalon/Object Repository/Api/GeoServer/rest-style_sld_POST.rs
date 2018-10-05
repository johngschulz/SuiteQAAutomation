<?xml version="1.0" encoding="UTF-8"?>
<WebServiceRequestEntity>
   <description></description>
   <name>rest-style_sld_POST</name>
   <tag></tag>
   <elementGuidId>475e2384-3d5d-4898-99cf-24ad6f409bf3</elementGuidId>
   <selectorMethod>BASIC</selectorMethod>
   <useRalativeImagePath>false</useRalativeImagePath>
   <httpBody>&lt;?xml version=&quot;1.0&quot; encoding=&quot;ISO-8859-1&quot;?>
&lt;StyledLayerDescriptor version=&quot;1.0.0&quot; 
    xsi:schemaLocation=&quot;http://www.opengis.net/sld StyledLayerDescriptor.xsd&quot; 
    xmlns=&quot;http://www.opengis.net/sld&quot; 
    xmlns:ogc=&quot;http://www.opengis.net/ogc&quot; 
    xmlns:xlink=&quot;http://www.w3.org/1999/xlink&quot; 
    xmlns:xsi=&quot;http://www.w3.org/2001/XMLSchema-instance&quot;>
  &lt;NamedLayer>
    &lt;UserStyle>
      &lt;Name>red_polygon&lt;/Name>
      &lt;Title>A red polygon style&lt;/Title>
      &lt;FeatureTypeStyle>
        &lt;Rule>
          &lt;Name>Rule 1&lt;/Name>
          &lt;Title>Red Fill&lt;/Title>
          &lt;PolygonSymbolizer>
            &lt;Fill>
              &lt;CssParameter name=&quot;fill&quot;>#FF0000&lt;/CssParameter>
            &lt;/Fill>
            &lt;Stroke>
              &lt;CssParameter name=&quot;stroke&quot;>#000000&lt;/CssParameter>
              &lt;CssParameter name=&quot;stroke-width&quot;>1&lt;/CssParameter>
            &lt;/Stroke>
          &lt;/PolygonSymbolizer>
        &lt;/Rule>
        &lt;/FeatureTypeStyle>
    &lt;/UserStyle>
  &lt;/NamedLayer>
&lt;/StyledLayerDescriptor></httpBody>
   <httpBodyContent>{
  &quot;text&quot;: &quot;\u003c?xml version\u003d\&quot;1.0\&quot; encoding\u003d\&quot;ISO-8859-1\&quot;?\u003e\n\u003cStyledLayerDescriptor version\u003d\&quot;1.0.0\&quot; \n    xsi:schemaLocation\u003d\&quot;http://www.opengis.net/sld StyledLayerDescriptor.xsd\&quot; \n    xmlns\u003d\&quot;http://www.opengis.net/sld\&quot; \n    xmlns:ogc\u003d\&quot;http://www.opengis.net/ogc\&quot; \n    xmlns:xlink\u003d\&quot;http://www.w3.org/1999/xlink\&quot; \n    xmlns:xsi\u003d\&quot;http://www.w3.org/2001/XMLSchema-instance\&quot;\u003e\n  \u003cNamedLayer\u003e\n    \u003cUserStyle\u003e\n      \u003cName\u003ered_polygon\u003c/Name\u003e\n      \u003cTitle\u003eA red polygon style\u003c/Title\u003e\n      \u003cFeatureTypeStyle\u003e\n        \u003cRule\u003e\n          \u003cName\u003eRule 1\u003c/Name\u003e\n          \u003cTitle\u003eRed Fill\u003c/Title\u003e\n          \u003cPolygonSymbolizer\u003e\n            \u003cFill\u003e\n              \u003cCssParameter name\u003d\&quot;fill\&quot;\u003e#FF0000\u003c/CssParameter\u003e\n            \u003c/Fill\u003e\n            \u003cStroke\u003e\n              \u003cCssParameter name\u003d\&quot;stroke\&quot;\u003e#000000\u003c/CssParameter\u003e\n              \u003cCssParameter name\u003d\&quot;stroke-width\&quot;\u003e1\u003c/CssParameter\u003e\n            \u003c/Stroke\u003e\n          \u003c/PolygonSymbolizer\u003e\n        \u003c/Rule\u003e\n        \u003c/FeatureTypeStyle\u003e\n    \u003c/UserStyle\u003e\n  \u003c/NamedLayer\u003e\n\u003c/StyledLayerDescriptor\u003e&quot;,
  &quot;contentType&quot;: &quot;text/plain&quot;,
  &quot;charset&quot;: &quot;UTF-8&quot;
}</httpBodyContent>
   <httpBodyType>text</httpBodyType>
   <httpHeaderProperties>
      <isSelected>true</isSelected>
      <matchCondition>equals</matchCondition>
      <name>Content-Type</name>
      <type>Main</type>
      <value>application/vnd.ogc.sld+xml </value>
   </httpHeaderProperties>
   <httpHeaderProperties>
      <isSelected>true</isSelected>
      <matchCondition>equals</matchCondition>
      <name>Authorization</name>
      <type>Main</type>
      <value>Basic YWRtaW46Z2Vvc2VydmVy</value>
   </httpHeaderProperties>
   <migratedVersion>5.4.1</migratedVersion>
   <restRequestMethod>POST</restRequestMethod>
   <restUrl>http://localhost:8080/geoserver/rest/styles</restUrl>
   <serviceType>RESTful</serviceType>
   <soapBody></soapBody>
   <soapHeader></soapHeader>
   <soapRequestMethod></soapRequestMethod>
   <soapServiceFunction></soapServiceFunction>
   <wsdlAddress></wsdlAddress>
</WebServiceRequestEntity>
