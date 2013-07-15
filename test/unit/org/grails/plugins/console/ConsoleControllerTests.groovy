package org.grails.plugins.console

import grails.test.ControllerUnitTestCase
import grails.util.Metadata

import org.codehaus.groovy.grails.web.servlet.mvc.GrailsHttpSession

class ConsoleControllerTests extends ControllerUnitTestCase {

	private Map sessionData = [:]

	@Override
	protected void setUp() {
		super.setUp()
		registerMetaClass String
		Metadata.current['app.grails.version'] = '3.1.4'
		controller.metaClass.getG = { -> [resource: { Map m -> '' },
		                                  createLink: { Map m -> '' },
		                                  cookie: { Map m -> '' }] }
		sessionData.clear()
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
		controller.session['_grails_console_last_code_'] = code
		def model = controller.index()
		assertEquals code, model.code
	}

	void testExecute() {
		String.metaClass.encodeAsHTML = { -> delegate }

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
}
