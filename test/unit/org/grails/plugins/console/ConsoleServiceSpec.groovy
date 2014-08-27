package org.grails.plugins.console

import grails.test.mixin.TestFor
import org.springframework.mock.web.MockHttpServletRequest
import spock.lang.Specification

@TestFor(ConsoleService)
class ConsoleServiceSpec extends Specification{


    def request = new MockHttpServletRequest()

    void 'service is not transactional'() {
        expect:
        !ConsoleService.transactional
    }

    void 'eval'() {
        given:
        String code = '''
			String s = "abc"
			println s.reverse()
        '''.trim()

        when:
        Map result = service.eval(code, false, request)

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
        Map result = service.eval(code, false, request)

        then:
        result.exception.message.contains 'Cannot invoke method reverse() on null object'
    }

    void 'eval with config'() {
        given:
        grailsApplication.config.testing = 'test-val'
        String code = 'println config.testing'

        when:
        Map result = service.eval(code, false, request)

        then:
        result.output.trim() == 'test-val'
    }
}
