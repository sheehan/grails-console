/*
 * Copyright 2012 the original author or authors
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

/**
 * @author <a href='mailto:mr.sheehan@gmail.com'>Matt Sheehan</a>
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 * @author <a href='mailto:donbeave@gmail.com'>Alexey Zhokhov</a>
 */
grails.project.class.dir = 'target/classes'
grails.project.test.class.dir = 'target/test-classes'
grails.project.test.reports.dir = 'target/test-reports'
grails.project.docs.output.dir = 'docs/manual' // for gh-pages branch

grails.project.dependency.resolver = 'maven'
grails.project.dependency.resolution = {
    inherits('global') {
    }
    log 'warn'
    repositories {
        grailsPlugins()
        grailsHome()
        mavenLocal()
        grailsCentral()
        mavenCentral()
    }

    dependencies {
        test 'cglib:cglib-nodep:3.1', {
            export = false
        }
    }

    plugins {
        build ':release:3.0.1', ':rest-client-builder:2.0.3', {
            export = false
        }
        compile ':asset-pipeline:1.9.9',
                ':less-asset-pipeline:1.10.0',
                ':coffee-asset-pipeline:1.9.0',
                ':handlebars-asset-pipeline:1.3.0.3',
                ':jquery:1.11.1',
                ':twitter-bootstrap:3.2.0.2',
                ':font-awesome-resources:4.2.0.0', {
            export = false
        }
    }
}
