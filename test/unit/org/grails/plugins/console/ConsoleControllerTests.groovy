package org.grails.plugins.console

import grails.test.ControllerUnitTestCase
import grails.util.Metadata

import org.codehaus.groovy.grails.web.servlet.mvc.GrailsHttpSession

class ConsoleControllerTests extends ControllerUnitTestCase {

	private Map sessionData = [:]

	@Override
	protected void setUp() {
		super.setUp()
		String.metaClass.encodeAsHTML = { -> delegate }
		Metadata.current[Metadata.APPLICATION_GRAILS_VERSION] = '3.1.4'
		controller.metaClass.getG = { -> ['cookie', 'createLink', 'resource'].collectEntries { [(it): { Map m -> '' } ]} }
	}

	protected newInstance() {
		GrailsHttpSession.metaClass.getAt = { String key -> sessionData[key] }
		GrailsHttpSession.metaClass.putAt = { String key, val -> sessionData[key] = val }
		super.newInstance()
	}

	void testIndexNoSession() {
		def model = controller.index()
		assertTrue model.code.startsWith('// Groovy Code here')
	}

	void testIndexSession() {
		String code = '1 + 1'
		controller.session[controller.lastCodeKey] = code

		def model = controller.index()
		assertEquals code, model.code
	}

	void testExecute() {
		def mockParams = controller.params

		mockParams.captureStdout = 'on'
		mockParams.code = '1 + 1'
		Map result = [output: 'groovy>\n2', result: '2']
		controller.consoleService = [eval: { String code, boolean captureStdout, req -> result }]

		controller.execute()

		String json = mockResponse.contentAsString
		assertNotNull json
		assertTrue json.contains('output')
		assertTrue json.contains('result')
		assertTrue json.contains('totalTime')
		assertTrue json.contains('groovy><br/>2')
	}

	void testCodeIsRememberedOnLoad() {
		def cookies = [:]
		controller.metaClass.getG = { -> [cookie: { Map m -> cookies[m.name] }] }

		String code = '1 + 1'
		cookies[controller.lastCodeKey] = code.bytes.encodeBase64().toString()

		def model = controller.index()
		assertEquals code, model.code
	}

	void testCodeIsStoredOnExecute() {
		doTestStored true
	}

	void testCodeIsNotStoredOnExecute() {
		doTestStored false
	}

	private void doTestStored(boolean remember) {
		def cookies = [:]
		controller.metaClass.addCookie = { String name, String value -> cookies[name] = value }

		def mockParams = controller.params
		mockParams.captureStdout = 'on'
		mockParams.code = '1 + 1'
		mockParams.remember = remember.toString()

		Map result = [output: 'groovy>\n2', result: '2']
		controller.consoleService = [eval: { String code, boolean captureStdout, req -> result }]

		controller.execute()

		String json = mockResponse.contentAsString
		assertNotNull json
		assertTrue json.contains('groovy><br/>2')

		assertEquals cookies[controller.lastCodeKey], remember ? controller.params.code : ''
	}
}
