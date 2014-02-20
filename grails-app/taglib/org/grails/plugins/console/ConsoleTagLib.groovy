package org.grails.plugins.console

import grails.converters.JSON
import grails.util.Metadata
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.codehaus.groovy.grails.plugins.GrailsPluginUtils

/**
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
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
