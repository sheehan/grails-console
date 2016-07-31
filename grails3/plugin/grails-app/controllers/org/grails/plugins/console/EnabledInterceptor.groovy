package org.grails.plugins.console

import grails.util.Environment


class EnabledInterceptor {

    def consoleConfig

    EnabledInterceptor() {
        match(controller: 'console')
    }

    boolean before() {
        def enabled = consoleConfig.enabled
        if (!(enabled instanceof Boolean)) {
            enabled = Environment.current == Environment.DEVELOPMENT
        }
        enabled
    }

    boolean after() { true }

    void afterView() {
        // no-op
    }
}
