/*
 * Copyright 2012 the original author or authors
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

import grails.converters.JSON
import grails.util.Metadata
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.codehaus.groovy.grails.plugins.GrailsPluginUtils

/**
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 * @author <a href='mailto:mr.sheehan@gmail.com'>Matt Sheehan</a>
 */
class ConsoleTagLib {

    static namespace = 'con'

    Map resourceMap

    GrailsApplication grailsApplication

    def css = { attrs ->
        config.css.each {
            out << "<link rel='stylesheet' media='screen' href='${resource(file: it - 'web-app/', plugin: 'console')}' />\n"
        }
    }

    def js = { attrs ->
        config.js.each {
            out << "<script type='text/javascript' src='${resource(file: it - 'web-app/', plugin: 'console')}' ></script>\n"
        }
    }

    /**
     * Read from console.json.
     * @return [js: [], css: []]
     */
    Map getConfig() {
        if (reload && !Metadata.getCurrent().isWarDeployed()) {
            resourceMap = getConfFromFile()
        } else if (!resourceMap) {
            resourceMap = getConfFromResource()
        }
        debug ? resourceMap.debug : resourceMap.release
    }

    boolean getReload() {
        grailsApplication.config.grails.plugin.console.reload == true
    }

    boolean getDebug() {
        grailsApplication.config.grails.plugin.console.debug == true
    }

    Map getConfFromFile() {
        File consolePluginDir = GrailsPluginUtils.getPluginDirForName('console').file
        String jsonText = new File(consolePluginDir, 'grails-app/conf/console.json').text
        JSON.parse jsonText
    }

    Map getConfFromResource() { // Note: resources aren't reloadable.
        String jsonText = grailsApplication.mainContext.parent.getResource('classpath:console.json').file.text
        JSON.parse jsonText
    }

}
