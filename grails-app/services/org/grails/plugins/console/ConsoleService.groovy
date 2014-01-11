package org.grails.plugins.console

import groovy.ui.SystemOutputInterceptor

class ConsoleService {

	static transactional = false

	def grailsApplication

	/**
	 * For use by the web-based console. The result is a Map, with output (including stdout if
	 * specified under the 'output' key, the execution result under the 'result' key,
	 * and any exception under the 'exception' key
	 *
	 * @param code  Groovy code to execute
	 * @param captureStdout  if <code>true</code>, redirects stdout during execution
	 * @return the output, result, and exception
	 */
	Map eval(String code, boolean captureStdout, request) {
		log.trace "eval() code: $code"

		def map = [:]
		def output = new StringBuilder()

		def systemOutInterceptor
		if (captureStdout) {
			systemOutInterceptor = new SystemOutputInterceptor({ String s ->
				output.append s
				return false
			})
			systemOutInterceptor.start()
		}

		try {
			def bindingValues = [session: request.session, request: request]
			map.result = eval(code, bindingValues)
		}
		catch (Throwable t) {
			map.exception = t
		}
		finally {
			systemOutInterceptor?.stop()
		}

		map.output = output.toString()
		map
	}

	/**
	 * Generic code execution.
	 * @param code  Groovy code to execute
	 * @param bindingValues  name/value pairs of variables used in the script
	 * @return  the evaluation result
	 */
	Object eval(String code, Map bindingValues) {
		createShell(bindingValues).evaluate code
	}

	protected GroovyShell createShell(Map bindingValues) {
		bindingValues.ctx = grailsApplication.mainContext
		bindingValues.grailsApplication = grailsApplication
		bindingValues.config = grailsApplication.config
		bindingValues.log = log
		new GroovyShell(grailsApplication.classLoader, new Binding(bindingValues))
	}
}
