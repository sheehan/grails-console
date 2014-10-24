/*
 * Copyright 2014 the original author or authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.grails.plugins.console

import groovy.ui.SystemOutputInterceptor
import org.codehaus.groovy.control.CompilerConfiguration
import org.codehaus.groovy.control.customizers.ImportCustomizer
import org.codehaus.groovy.grails.commons.GrailsApplication

/**
 * @author <a href='mailto:mr.sheehan@gmail.com'>Matt Sheehan</a>
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 */
class ConsoleService {

    static transactional = false

    GrailsApplication grailsApplication

    /**
     * For use by the web-based console. The result is a Map, with output (including stdout if
     * specified under the 'output' key, the execution result under the 'result' key,
     * and any exception under the 'exception' key
     *
     * @param code Groovy code to execute
     * @param autoImportDomains if <code>true</code>, adds imports for each domain class
     * @return the output, result, and exception
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
