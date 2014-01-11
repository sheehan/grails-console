package org.grails.plugins.console

import grails.converters.JSON
import grails.util.GrailsUtil

import org.codehaus.groovy.runtime.InvokerHelper

import javax.servlet.http.Cookie

class ConsoleController {

	protected static final String lastCodeKey = '_grails_console_last_code_'
	protected static final String rememberCodeKey = '_grails_console_remember_code'

	def consoleService

	def index() {
		String code = session[lastCodeKey] ?: readCookie(lastCodeKey) ?: '''\
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

		[code: code, remember: readCookie(rememberCodeKey)?.toBoolean()]
	}

	def execute(Boolean captureStdout, String filename, String code, Boolean remember) {
		long startTime = System.currentTimeMillis()
		String error

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

		session[lastCodeKey] = code

		def codeToStore = remember ? code : ''
		addCookie(lastCodeKey, codeToStore)
		addCookie(rememberCodeKey, remember.toString())

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

	protected String encode(String s) {
		s.encodeAsHTML().replaceAll(/[\n\r]/, '<br/>').replaceAll('\t', '&nbsp;&nbsp;&nbsp;&nbsp;')
	}

	// store cookies in base64 encoding (primarily for semicolons in the code - those screw up cookies)
	protected void addCookie(String name, String value) {
		String encodedValue = value?.bytes?.encodeBase64()
		Cookie cookie = new Cookie(name, encodedValue)
		cookie.maxAge = 5000000
		response.addCookie cookie
	}

	protected String readCookie(String name) {
		new String(g.cookie(name: name)?.decodeBase64() ?: '')
	}
}
