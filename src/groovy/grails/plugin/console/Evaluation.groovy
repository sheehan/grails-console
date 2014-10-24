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
package grails.plugin.console

import grails.util.GrailsUtil
import org.codehaus.groovy.runtime.InvokerHelper

/**
 * @author <a href='mailto:mr.sheehan@gmail.com'>Matt Sheehan</a>
 */
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
            def m = stackTraceAsString =~ /at Script1.run\(Script1.groovy:(\d+)\)/
            if (m) {
                scriptLine = m[0][1] as Integer
            }
        }
        scriptLine
    }

}

