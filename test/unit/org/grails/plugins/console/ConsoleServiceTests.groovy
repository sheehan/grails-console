package org.grails.plugins.console

import grails.test.GrailsUnitTestCase

import org.codehaus.groovy.grails.commons.DefaultGrailsApplication

import org.springframework.context.support.GenericApplicationContext
import org.springframework.mock.web.MockHttpServletRequest
import org.springframework.web.context.request.ServletRequestAttributes

class ConsoleServiceTests extends GrailsUnitTestCase {

	private service = new ConsoleService()
	private ctx = new GenericApplicationContext()
	private app

	protected void setUp() {
		super.setUp()
		app = new DefaultGrailsApplication(mainContext: ctx)
		service.grailsApplication = app
	}

	void testTransactional() {
		assertFalse ConsoleService.transactional
	}

	void testCreateShell() {

		GroovyShell shell = service.createShell(foo: 'bar')

		assertSame app.classLoader, shell.classLoader.parent
		assertEquals 'bar', shell.context.getVariable('foo')
		assertSame ctx, shell.context.getVariable('ctx')
		assertSame app, shell.context.getVariable('grailsApplication')
	}

	void testEvalWithBindingMap() {
		assertEquals 2, service.eval("1 + ONE", [ONE: 1])
	}

	void testEval() {
		service.metaClass.getLog = { -> [trace: { String msg -> }] }

		def request = new MockHttpServletRequest()

		String code = '''
			String s = "abc"
			println s.reverse()
'''.trim()

		Map result = service.eval(code, true, request)
		assertTrue result.output.contains('cba')
	}

	void testEvalException() {
		service.metaClass.getLog = { -> [trace: { String msg -> }] }

		def request = new MockHttpServletRequest()

		String code = '''
			String s = null
			println s.reverse()
'''.trim()

		Map result = service.eval(code, true, request)
		assertNotNull result.exception
		assertTrue result.exception.message.contains('Cannot invoke method reverse() on null object')
	}
}
