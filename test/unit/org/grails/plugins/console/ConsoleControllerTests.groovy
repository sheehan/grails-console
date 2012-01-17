package org.grails.plugins.console

import grails.test.ControllerUnitTestCase
import grails.util.Metadata

class ConsoleControllerTests extends ControllerUnitTestCase {

	@Override
	protected void setUp() {
		super.setUp()
		registerMetaClass String
		Metadata.current['app.grails.version'] = '3.1.4'
		controller.metaClass.getG = { -> [resource: { Map m -> '' },
		                                  createLink: { Map m -> '' }] }
	}

	void testIndexNoSession() {
		def model = controller.index()
		assertTrue model.code.startsWith('// Groovy Code here')
	}

	void testIndexSession() {
		String code = '1 + 1'
		mockSession.'_grails_console_last_code_' = code
		def model = controller.index()
		assertEquals code, model.code
	}

	void testExecute() {
		String.metaClass.encodeAsHTML = { -> delegate }

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
