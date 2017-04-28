package org.grails.plugins.console

import grails.converters.JSON

class ConsoleUtil {

    static void initJsonConfig() {
        JSON.createNamedConfig('console') {
            it.registerObjectMarshaller(ClassWrapper) { ClassWrapper wrapper ->
                Class clazz = wrapper.clazz

                [
                    name: clazz.name,
                    methods: clazz.metaClass.methods
                        .findAll { it.declaringClass.name != 'java.lang.Object' && it.public && it.name ==~ /[a-zA-Z]+.*/}
                        .sort { it.name }
                        .collect { method ->
                        String signature = method.parameterTypes.collect { getSimpleClassName it.theClass }.join(', ')

                        "$method.name($signature): ${getSimpleClassName method.returnType}"
                    }.unique()
                ]
            }
            it.registerObjectMarshaller(Throwable) { Throwable throwable ->
                [
                    message: throwable.toString(),
                    stackTrace: throwable.stackTrace*.toString()
                ]
            }
            it.registerObjectMarshaller(Evaluation) { Evaluation eval ->
                eval.console.output.each { entry ->
                    entry.args = entry.args.collect {
                        it instanceof Class<?> ? new ClassWrapper(it) : it
                    }
                }

                List consoleJsons = eval.console.output.collect {
                    String json = null
                    try {
                        json = (it as JSON).toString()
                    } catch (e) {}
                    json
                }

                Map result = [
                    totalTime: eval.totalTime,
                    output: eval.output,
                    console: consoleJsons
                ]
                if (eval.exception) {
                    result.exception = eval.exception
                } else {
                    result.result = eval.resultAsString
                }
                result
            }
        }
    }

    static private String getSimpleClassName(Class clazz) {
        String name = clazz.isArray() ? "${clazz.componentType.name}[]" : clazz.name
        List prefixes = [
            'java.lang.',
            'java.util.',
            'groovy.lang.',
        ]
        for (String prefix in prefixes) {
            if (name.startsWith(prefix)) {
                name = name[prefix.length()..-1]
                break
            }
        }
        name
    }
}
