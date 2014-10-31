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
import org.apache.commons.io.FilenameUtils

/**
 * @author <a href='mailto:mr.sheehan@gmail.com'>Matt Sheehan</a>
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 */
class ConsoleController {

    def consoleService

    def beforeInterceptor = {
        if (!ConsoleUtils.pluginEnabled) {
            response.sendError 404
            return false
        }
    }

    def index() {
        Map model = [
                json: [
                        implicitVars          : [
                                ctx              : 'the Spring application context',
                                grailsApplication: 'the Grails application',
                                config           : 'the Grails configuration',
                                request          : 'the HTTP request',
                                session          : 'the HTTP session',
                        ],
                        baseUrl               : getBaseUrl(),
                        remoteFileStoreEnabled: ConsoleUtils.remoteFileStoreEnabled
                ]
        ]
        render view: 'index', model: model
    }

    def execute(String code, boolean autoImportDomains) {
        Evaluation eval = consoleService.eval(code, autoImportDomains, request)

        Map result = [
                totalTime: eval.totalTime,
                output   : eval.output
        ]
        if (eval.exception) {
            result.exception = [
                    stackTrace: eval.stackTraceAsString,
                    lineNumber: eval.exceptionLineNumber
            ]
        } else {
            result.result = eval.resultAsString
        }

        render result as JSON
    }

    def listFiles(String path) {
        if (!ConsoleUtils.remoteFileStoreEnabled) {
            return renderError("Remote file store disabled", 403)
        }

        File baseDir = new File(path)

        if (!baseDir.exists() || !baseDir.canRead()) {
            return renderError("Directory not found or cannot be read: $path", 400)
        }
        Map result = [
                path : FilenameUtils.normalize(baseDir.absolutePath, true),
                files: baseDir.listFiles().sort { it.name }.collect { fileToJson it, false }
        ]
        render result as JSON
    }

    def file() {
        if (!ConsoleUtils.remoteFileStoreEnabled) {
            return renderError("Remote file store disabled", 403)
        }
        switch (request.method) {
            case 'GET':
                doFileGet()
                break
            case 'DELETE':
                doFileDelete()
                break
            case 'PUT':
                doFilePut()
                break
            case 'POST':
                doFilePost()
                break
        }
    }

    private doFileGet() {
        String filename = params.path

        if (!filename) {
            return renderError('param required: path', 400)
        }

        File file = new File(filename)

        if (!file.exists() || !file.canRead()) {
            return renderError("File $filename doesn't exist or cannot be read", 400)
        }

        render(fileToJson(file) as JSON)
    }

    private doFileDelete() {
        String filename = params.path

        if (!filename) {
            return renderError('param required: path', 400)
        }

        File file = new File(filename)

        if (!file.exists() || !file.canWrite()) {
            return renderError("File $filename doesn't exist or cannot be deleted", 400)
        }

        if (!file.delete()) {
            return renderError("File $filename could not be deleted", 400)
        }

        render([:] as JSON)
    }

    private doFilePut() {
        String filename = params.path

        if (!filename) {
            return renderError('param required: path', 400)
        }

        File file = new File(filename)

        if (!file.exists() || !file.canWrite()) {
            return renderError("File $filename doesn't exist or cannot be modified", 400)
        }

        def json = request.JSON
        try {
            file.write json.text
        } catch (e) {
            return renderError("File $filename could not be modified", 400)
        }

        render(fileToJson(file) as JSON)
    }

    private doFilePost() {
        def json = request.JSON

        File file = new File(json.path.toString(), json.name.toString())
        try {
            file.write json.text
        } catch (e) {
            return renderError("File $json.name could not be created", 500)
        }

        render(fileToJson(file) as JSON)
    }

    private def renderError(String error, int status) {
        response.status = status
        render([error: error] as JSON)
    }

    private String getBaseUrl() {
        def baseUrl = grailsApplication.config.grails.plugin.console.baseUrl
        if (!(baseUrl instanceof String)) {
            baseUrl = createLink(action: 'index', absolute: true) - '/index'
        }
        baseUrl
    }

    private static Map fileToJson(File file, boolean includeText = true) {
        Map json = [
                id          : FilenameUtils.normalize(file.absolutePath, true),
                name        : file.name,
                type        : file.isDirectory() ? 'dir' : 'file',
                lastModified: file.lastModified()
        ]
        if (includeText && file.isFile()) {
            json.text = file.text
        }
        json
    }

}
