package org.grails.plugins.console

import grails.util.GrailsUtil
import org.codehaus.groovy.runtime.InvokerHelper

class Evaluation {

    Object result
    Throwable exception
    Long totalTime
    String output

    void setException(Throwable exception) {
        this.exception = GrailsUtil.deepSanitize(exception)
    }

    String getResultAsString() {
        InvokerHelper.inspect result
    }

    String getStackTraceAsString() {
        StringWriter sw = new StringWriter()
        new PrintWriter(sw).withWriter { exception.printStackTrace it }
        sw.toString()
    }

    Integer getExceptionLineNumber() {
        Integer scriptLine = null
        if (exception) {
            def m = stackTraceAsString =~ /at Script\d+\.run\(Script\d+\.groovy:(\d+)\)/
            if (m) {
                scriptLine = m[0][1] as Integer
            }
        }
        scriptLine
    }

}

