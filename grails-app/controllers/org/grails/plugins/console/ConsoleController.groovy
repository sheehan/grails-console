package org.grails.plugins.console

import grails.converters.JSON
import grails.util.GrailsUtil
import grails.util.Metadata

import org.codehaus.groovy.runtime.InvokerHelper

class ConsoleController {

	def consoleService
	def pluginManager

	def index = {
		String code = session['_grails_console_last_code_'] ?: '''\
// Groovy Code here

// Implicit variables include:
//     ctx: the Spring application context
//     grailsApplication: the Grails application
//     config: the Grails configuration
//     request: the HTTP request
//     session: the HTTP session

// Shortcuts:
//     Ctrl-Enter: Execute code
//     Shift-Esc: Clear editor
//     Esc: Clear results
'''

		boolean is11 = Metadata.current.getGrailsVersion().startsWith('1.1')
		String pluginPath11 = is11 ? pluginManager.getGrailsPlugin('console').pluginPath + '/' : ''
		String pluginContext = is11 ?
				request.contextPath + pluginManager.getGrailsPlugin('console').pluginPath :
				g.resource(plugin: 'console')
		String executeLink = g.createLink(action: 'execute')

		[code: code, pluginContext: pluginContext, pluginPath11: pluginPath11, executeLink: executeLink]
	}

	def execute = {
		long startTime = System.currentTimeMillis()
		boolean captureStdout = params.captureStdout != null
		String code = params.code
		session['_grails_console_last_code_'] = code

		Map results = consoleService.eval(code, captureStdout, request)

		if (results.exception) {
			def sw = new StringWriter()
			new PrintWriter(sw).withWriter { GrailsUtil.deepSanitize(results.exception).printStackTrace(it) }
			results.exception = encode(sw.toString())
		}
		else {
			def buffer = new StringBuilder()
			for (line in code.tokenize('\n')) {
				buffer.append('groovy> ').append(line).append('\n')
			}
			buffer.append('\n').append results.output
			results.output = encode(buffer.toString())
			results.result = encode(InvokerHelper.inspect(results.result))
		}

		results.totalTime = System.currentTimeMillis() - startTime

		render results as JSON
	}

	private String encode(String s) {
		s.encodeAsHTML().replaceAll(/[\n\r]/, '<br/>').replaceAll('\t', '&nbsp;&nbsp;&nbsp;&nbsp;')
	}
}
