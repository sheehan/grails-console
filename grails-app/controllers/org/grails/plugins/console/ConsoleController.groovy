package org.grails.plugins.console

import grails.converters.JSON
import grails.util.GrailsUtil

import org.codehaus.groovy.runtime.InvokerHelper

import javax.servlet.http.Cookie

class ConsoleController {

	def consoleService
	def pluginManager

	private static final String lastCodeKey = '_grails_console_last_code_'
	private static final String rememberCodeKey = '_grails_console_remember_code'

	def index = {
		String code = session[lastCodeKey] \
						?: g.cookie( name:lastCodeKey )?.replaceAll('~~~','\n') \
						?: '''\
// Groovy Code here

// Implicit variables include:
//     ctx: the Spring application context
//     grailsApplication: the Grails application
//     config: the Grails configuration
//     request: the HTTP request
//     session: the HTTP session

// Shortcuts:
//     Execute: Ctrl-Enter
//     Clear: Esc
'''

		[code: code, remember:g.cookie( name:rememberCodeKey )?.toBoolean()]
	}

	def execute = {
		long startTime = System.currentTimeMillis()
		boolean captureStdout = params.captureStdout != null

		String error
		String code
		String filename = params.filename
		if (filename) {
			log.info "Opening File $filename"
			def file = new File(filename)
			if (file.exists() && file.canRead()) {
				code = file.text
			}
			else {
				error = "File $filename doesn't exist or cannot be read"
				code = error
			}
		}
		else {
			code = params.code
		}

		session[lastCodeKey] = code

		def remember = params.boolean('remember')
		def codeStore = remember ? code?.replaceAll('\n','~~~') : ''
		addCookie( lastCodeKey, codeStore )
		addCookie( rememberCodeKey, remember?.toString() )

		Map results
		if (error) {
			results = [exception: encode(error), result: '']
		}
		else {
			results = consoleService.eval(code, captureStdout, request)
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
		}

		results.totalTime = System.currentTimeMillis() - startTime

		render results as JSON
	}

	private String encode(String s) {
		s.encodeAsHTML().replaceAll(/[\n\r]/, '<br/>').replaceAll('\t', '&nbsp;&nbsp;&nbsp;&nbsp;')
	}

	private void addCookie( String name, String value ) {
		Cookie cookie = new Cookie( name, value )
		cookie.maxAge = 500000
		response.addCookie( cookie )
	}
}
