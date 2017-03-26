package org.grails.plugins.console

class ConsoleUrlMappings {

    static mappings = {
        "/console/$action?"(controller: 'console')
    }
}
