package org.grails.plugins.console

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

        ByteArrayOutputStream baos = new ByteArrayOutputStream()
        PrintStream out = new PrintStream(baos)

        PrintStream systemOut = System.out
        System.out = out

        Evaluation evaluation = new Evaluation()

        Console console = new Console()

        long startTime = System.currentTimeMillis()
        try {
            Binding binding = createBinding(request, out, console)
            CompilerConfiguration configuration = createConfiguration(autoImportDomains)

            GroovyShell groovyShell = new GroovyShell(grailsApplication.classLoader, binding, configuration)
            evaluation.result = groovyShell.evaluate code
        } catch (Throwable t) {
            evaluation.exception = t
        }

        evaluation.totalTime = System.currentTimeMillis() - startTime
        System.out = systemOut

        evaluation.console = console
        evaluation.output = baos.toString('UTF8')
        evaluation
    }

    private Binding createBinding(request, PrintStream out, Console console) {
        new Binding([
            session          : request.session,
            request          : request,
            ctx              : grailsApplication.mainContext,
            grailsApplication: grailsApplication,
            config           : grailsApplication.config,
            out              : out,
            console          : console
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
