package org.grails.plugins.console

import grails.testing.services.ServiceUnitTest
import org.springframework.mock.web.MockHttpServletRequest
import spock.lang.Specification

class ConsoleServiceSpec extends Specification implements ServiceUnitTest<ConsoleService> {

    def request = new MockHttpServletRequest()

    void 'eval'() {
        given:
        String code = '''
			String s = "abc"
			println s.reverse()
        '''.trim()

        when:
        Evaluation result = service.eval(code, false, request)

        then:
        result.output.trim() == 'cba'
    }

    void 'eval with exception'() {
        given:
        String code = '''
			String s = null
			println s.reverse()
        '''.trim()

        when:
        Evaluation result = service.eval(code, false, request)

        then:
        result.exception.message.contains 'Cannot invoke method reverse() on null object'
    }

    void 'eval with config'() {
        given:
        grailsApplication.config.testing = 'test-val'
        String code = 'println config.testing'

        when:
        Evaluation result = service.eval(code, false, request)

        then:
        result.output.trim() == 'test-val'
    }
}
