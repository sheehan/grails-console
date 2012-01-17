package org.grails.plugins.console

import grails.test.GrailsUnitTestCase

import org.codehaus.groovy.grails.commons.DefaultGrailsApplication

import org.springframework.context.support.GenericApplicationContext
import org.springframework.mock.web.MockHttpServletRequest
import org.springframework.web.context.request.ServletRequestAttributes

class ConsoleServiceTests extends GrailsUnitTestCase {

	private _service
	private _ctx
	private _config
	private _app

	protected void setUp() {
		super.setUp()
		registerMetaClass ConsoleService
		_service = new ConsoleService()
		_ctx = new GenericApplicationContext()
		_config = new ConfigObject()
		_app = new DefaultGrailsApplication(mainContext: _ctx)
		_service.grailsApplication = _app
	}

	void testTransactional() {
		assertFalse ConsoleService.transactional
	}

	void testCreateShell() {

		GroovyShell shell = _service.createShell(foo: 'bar')

		assertSame _app.classLoader, shell.classLoader.parent
		assertEquals 'bar', shell.context.getVariable('foo')
		assertSame _ctx, shell.context.getVariable('ctx')
		assertSame _app, shell.context.getVariable('grailsApplication')
	}

	void testEvalWithBindingMap() {
		assertEquals 2, _service.eval("1 + ONE", [ONE: 1])
	}

	void testEval() {
		_service.metaClass.getLog = { -> [trace: { String msg -> }] }

		def request = new MockHttpServletRequest()

		String code = '''
			String s = "abc"
			println s.reverse()
'''.trim()

		Map result = _service.eval(code, true, request)
		assertTrue result.output.contains('cba')
	}

	void testEvalException() {
		_service.metaClass.getLog = { -> [trace: { String msg -> }] }

		def request = new MockHttpServletRequest()

		String code = '''
			String s = null
			println s.reverse()
'''.trim()

		Map result = _service.eval(code, true, request)
		assertNotNull result.exception
		assertTrue result.exception.message.contains('Cannot invoke method reverse() on null object')
	}
}
