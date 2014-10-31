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

import grails.test.mixin.TestFor
import org.springframework.mock.web.MockHttpServletRequest
import spock.lang.Specification

/**
 * @author <a href='mailto:mr.sheehan@gmail.com'>Matt Sheehan</a>
 */
@TestFor(ConsoleService)
class ConsoleServiceSpec extends Specification {

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
