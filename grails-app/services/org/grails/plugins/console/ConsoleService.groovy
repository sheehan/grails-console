package org.grails.plugins.console

import groovy.ui.SystemOutputInterceptor
import org.codehaus.groovy.control.CompilerConfiguration
import org.codehaus.groovy.control.customizers.ImportCustomizer
import org.codehaus.groovy.grails.commons.GrailsApplication

class ConsoleService {

	static transactional = false

	GrailsApplication grailsApplication

	/**
	 * For use by the web-based console. The result is a Map, with output (including stdout if
	 * specified under the 'output' key, the execution result under the 'result' key,
	 * and any exception under the 'exception' key
	 *
	 * @param code  Groovy code to execute
	 * @param autoImportDomains  if <code>true</code>, adds imports for each domain class
	 * @return the output, result, and exception
	 */
	Map eval(String code, boolean autoImportDomains, request) {
		log.trace "eval() code: $code"

		Map map = [:]

        StringBuilder output = new StringBuilder()
        SystemOutputInterceptor systemOutInterceptor = createInterceptor(output)
        systemOutInterceptor.start()

		try {
            Binding binding = createBinding(request)
            CompilerConfiguration configuration = createConfiguration(autoImportDomains)
            GroovyShell groovyShell = new GroovyShell(grailsApplication.classLoader, binding, configuration)
			map.result = groovyShell.evaluate code
		} catch (Throwable t) {
			map.exception = t
		}

        systemOutInterceptor.stop()

		map.output = output.toString()
		map
	}

    private static SystemOutputInterceptor createInterceptor(StringBuilder output) {
        new SystemOutputInterceptor({ String s ->
            output.append s
            return false
        })
    }

    private Binding createBinding(request) {
        new Binding([
            session: request.session,
            request: request,
            ctx: grailsApplication.mainContext,
            grailsApplication: grailsApplication,
            config: grailsApplication.config,
            log: log
        ])
    }

    private CompilerConfiguration createConfiguration(boolean autoImportDomains) {
        CompilerConfiguration configuration = new CompilerConfiguration()
        if (autoImportDomains) {
            ImportCustomizer importCustomizer = new ImportCustomizer()
            importCustomizer.addImports(*grailsApplication.domainClasses*.fullName)
            configuration.addCompilationCustomizers importCustomizer
        }
        configuration
    }
}
