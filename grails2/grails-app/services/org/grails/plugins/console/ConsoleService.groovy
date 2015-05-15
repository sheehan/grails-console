package org.grails.plugins.console

import groovy.ui.SystemOutputInterceptor
import org.codehaus.groovy.control.CompilerConfiguration
import org.codehaus.groovy.control.customizers.ImportCustomizer
import org.codehaus.groovy.grails.commons.GrailsApplication

class ConsoleService {

    static transactional = false

    GrailsApplication grailsApplication

    /**
     * @param code Groovy code to execute
     * @param autoImportDomains if <code>true</code>, adds imports for each domain class
     * @return an Evaluation
     */
    Evaluation eval(String code, boolean autoImportDomains, request) {
        log.trace "eval() code: $code"

        StringBuilder output = new StringBuilder()
        SystemOutputInterceptor systemOutInterceptor = createInterceptor(output)
        systemOutInterceptor.start()

        Evaluation evaluation = new Evaluation()

        long startTime = System.currentTimeMillis()
        try {
            Binding binding = createBinding(request)
            CompilerConfiguration configuration = createConfiguration(autoImportDomains)

            GroovyShell groovyShell = new GroovyShell(grailsApplication.classLoader, binding, configuration)
            evaluation.result = groovyShell.evaluate code
        } catch (Throwable t) {
            evaluation.exception = t
        }

        evaluation.totalTime = System.currentTimeMillis() - startTime
        systemOutInterceptor.stop()

        evaluation.output = output.toString()
        evaluation
    }

    private static SystemOutputInterceptor createInterceptor(StringBuilder output) {
        new SystemOutputInterceptor({ String s ->
            output.append s
            return false
        })
    }

    private Binding createBinding(request) {
        new Binding([
            session          : request.session,
            request          : request,
            ctx              : grailsApplication.mainContext,
            grailsApplication: grailsApplication,
            config           : grailsApplication.config,
            log              : log
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
