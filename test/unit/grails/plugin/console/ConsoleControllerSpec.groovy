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

import grails.converters.JSON
import grails.test.mixin.TestFor
import grails.util.BuildSettingsHolder
import org.apache.commons.io.FileUtils
import spock.lang.Specification

/**
 * @author <a href='mailto:mr.sheehan@gmail.com'>Matt Sheehan</a>
 */
@TestFor(ConsoleController)
class ConsoleControllerSpec extends Specification {

    ConsoleService consoleService = Mock(ConsoleService)
    File tempDir

    void setup() {
        controller.consoleService = consoleService
        tempDir = createTempDir()
        config.grails.plugin.console.fileStore.remote.enabled = true
    }

    void cleanup() {
        FileUtils.deleteDirectory tempDir
    }

    void 'beforeInterceptor - console plugin disabled'() {
        expect:
        controller.beforeInterceptor() == false
        response.status == 404
    }

    void 'beforeInterceptor - console plugin enabled'() {
        given:
        config.grails.plugin.console.enabled = true

        expect:
        controller.beforeInterceptor() != false
        response.status != 404
    }

    void 'index'() {
        when:
        controller.index()

        then:
        model.json.implicitVars.ctx == 'the Spring application context'
        model.json.remoteFileStoreEnabled
    }

    void 'index - baseUrl with no config'() {
        when:
        controller.index()

        then:
        model.json.baseUrl == 'http://localhost:8080/console'
    }

    void 'index - baseUrl with config'() {
        when:
        config.grails.plugin.console.baseUrl = 'http://localhost:5050/x/y/z/console'
        controller.index()

        then:
        model.json.baseUrl == 'http://localhost:5050/x/y/z/console'
    }

    void 'execute'() {
        given:
        String code = '"s"'

        when:
        controller.execute code, false

        then:
        1 * consoleService.eval(code, false, request) >> new Evaluation(
                result: 'test-result',
                output: 'test-output'
        )
        with(response.json) {
            result == "'test-result'"
            output == 'test-output'
            totalTime != null
        }
    }

    void 'execute with exception'() {
        given:
        String code = ''

        when:
        controller.execute code, false

        then:
        1 * consoleService.eval(code, false, request) >> new Evaluation(
                result: 'test-result',
                output: 'test-output',
                exception: new RuntimeException()
        )
        with(response.json) {
            exception.stackTrace.contains 'RuntimeException'
            output == 'test-output'
            totalTime != null
        }
    }

    void 'listFiles'() {
        given:
        File testFile1 = new File(tempDir, 'test1')
        testFile1.createNewFile()
        File testFile2 = new File(tempDir, 'test2')
        testFile2.createNewFile()
        File testDir1 = new File(tempDir, 'dir1')
        testDir1.mkdir()

        String path = tempDir.absolutePath

        when:
        controller.listFiles(path)

        then:
        with(response.json) {
            files.size() == 3
            files[0].id == testDir1.absolutePath
            files[0].name == testDir1.name
            files[0].type == 'dir'
            files[0].lastModified == testDir1.lastModified()
            files[1].id == testFile1.absolutePath
            files[1].name == testFile1.name
            files[1].type == 'file'
            files[1].lastModified == testFile1.lastModified()
            files[2].id == testFile2.absolutePath
            files[2].name == testFile2.name
            files[2].type == 'file'
            files[2].lastModified == testFile2.lastModified()
        }
    }

    void 'listFiles - directory doesnt exist'() {
        given:
        String path = tempDir.absolutePath + 'xx'

        when:
        controller.listFiles(path)

        then:
        response.status == 400
        response.json.error.contains 'Directory not found'
    }

    void 'listFiles - remote file store disabled'() {
        given:
        String path = tempDir.absolutePath
        config.grails.plugin.console.fileStore.remote.enabled = false

        when:
        controller.listFiles(path)

        then:
        response.status == 403
        response.json.error.contains 'Remote file store disabled'
    }

    void 'file get'() {
        given:
        File testFile1 = new File(tempDir, 'test1')
        testFile1.createNewFile()
        request.method = 'GET'

        params.path = testFile1.absolutePath

        when:
        controller.file()

        then:
        response.contentType.contains 'application/json'
        response.status == 200
        response.json.id == testFile1.absolutePath
        response.json.name == testFile1.name
        response.json.type == 'file'
        response.json.lastModified == testFile1.lastModified()
    }

    void 'file get - remote file store disabled'() {
        given:
        File testFile1 = new File(tempDir, 'test1')
        testFile1.createNewFile()
        request.method = 'GET'

        params.path = testFile1.absolutePath
        config.grails.plugin.console.fileStore.remote.enabled = false

        when:
        controller.file()

        then:
        response.status == 403
        response.json.error.contains 'Remote file store disabled'
    }

    void 'file get - no path param'() {
        given:
        request.method = 'GET'

        when:
        controller.file()

        then:
        response.contentType.contains 'application/json'
        response.status == 400
        response.json.error.contains 'param required'
    }

    void 'file get - file doesnt exist'() {
        given:
        File testFile1 = new File(tempDir, 'test1')
        request.method = 'GET'

        params.path = testFile1.absolutePath

        when:
        controller.file()

        then:
        response.contentType.contains 'application/json'
        response.status == 400
        response.json.error.contains 'doesn\'t exist or cannot be read'
    }

    void 'file delete'() {
        given:
        File testFile1 = new File(tempDir, 'test1')
        testFile1.createNewFile()
        request.method = 'DELETE'

        params.path = testFile1.absolutePath

        when:
        controller.file()

        then:
        response.status == 200
        !testFile1.exists()
    }

    void 'file delete - file doesnt exist'() {
        given:
        File testFile1 = new File(tempDir, 'test1')
        request.method = 'DELETE'

        params.path = testFile1.absolutePath

        when:
        controller.file()

        then:
        response.contentType.contains 'application/json'
        response.status == 400
        response.json.error.contains 'doesn\'t exist or cannot be deleted'
    }

    void 'file put'() {
        given:
        File testFile1 = new File(tempDir, 'test1')
        testFile1.createNewFile()
        request.method = 'PUT'

        params.path = testFile1.absolutePath
        request.json = [text: 'testing'] as JSON

        when:
        controller.file()

        then:
        response.status == 200
        testFile1.text == 'testing'
    }

    void 'file put - file doesnt exist'() {
        given:
        File testFile1 = new File(tempDir, 'test1')
        request.method = 'PUT'

        params.path = testFile1.absolutePath
        request.json = [text: 'testing'] as JSON

        when:
        controller.file()

        then:
        response.contentType.contains 'application/json'
        response.status == 400
        response.json.error.contains 'doesn\'t exist or cannot be modified'
    }

    void 'file post'() {
        given:
        request.method = 'POST'

        request.json = [
                path: tempDir.absolutePath,
                name: 'test1',
                text: 'testing'
        ] as JSON

        when:
        controller.file()

        then:
        response.status == 200
        File testFile1 = new File(tempDir, 'test1')
        testFile1.exists()
        testFile1.text == 'testing'
    }

    void 'file post - write failure'() {
        given:
        request.method = 'POST'

        request.json = [
                path: tempDir.absolutePath + /xxx/,
                name: 'test1',
                text: 'testing'
        ] as JSON

        when:
        controller.file()

        then:
        response.status == 500
        response.json.error.contains 'could not be created'
    }

    private File createTempDir() {
        File projectWorkDir = BuildSettingsHolder.settings.projectWorkDir
        File tempDir = new File(projectWorkDir, 'tmp')
        tempDir.mkdir()
        tempDir
    }

}
