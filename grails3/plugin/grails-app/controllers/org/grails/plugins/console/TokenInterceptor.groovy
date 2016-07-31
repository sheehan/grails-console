package org.grails.plugins.console

class TokenInterceptor {

    def consoleConfig

    TokenInterceptor() {
        match(controller: 'console').excludes(action: 'index')
    }

    boolean before() {
        if (actionName
            && consoleConfig.csrfProtectionEnabled
            && request.getHeader('X-CSRFToken') != session['CONSOLE_CSRF_TOKEN']) {
            response.status = 403
            response.writer.println "CSRF token doesn't match. Please refresh the page."
            return false
        }
        true
    }

    boolean after() { true }

    void afterView() {}
}
