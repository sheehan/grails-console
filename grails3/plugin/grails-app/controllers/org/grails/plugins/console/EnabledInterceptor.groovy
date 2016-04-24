package org.grails.plugins.console

import grails.util.Environment


class EnabledInterceptor {

    EnabledInterceptor() {
        match(controller: 'console')
    }

    boolean before() {
        def enabled = grailsApplication.config.grails.plugin.console.enabled
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
