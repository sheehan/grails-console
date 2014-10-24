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
package grails.plugin.console

/**
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 * @author <a href='mailto:mr.sheehan@gmail.com'>Matt Sheehan</a>
 */
class ConsoleTagLib {

    static namespace = 'con'

    def pluginManager

    def icon = { attrs ->
        String path = pluginManager.hasGrailsPlugin('asset-pipeline') ? assetPath(src: 'console/grails.logo.png') :
                resource(dir: 'images/console', file: 'grails.logo.png', plugin: 'console')
        out << "<link rel='icon' type='image/png' href='${path}' />\n"
    }
    def css = { attrs ->
        if (pluginManager.hasGrailsPlugin('asset-pipeline')) {
            out << asset.stylesheet(src: pluginManager.hasGrailsPlugin('twitter-bootstrap') ? 'bootstrap' : 'console/bootstrap.min.css')
            out << asset.stylesheet(src: pluginManager.hasGrailsPlugin('font-awesome-resources') ? 'font-awesome' : 'console/font-awesome.min.css')
            out << asset.stylesheet(src: 'console/console.min.css')
        } else {
            out << "<link rel='stylesheet' media='screen' href='${resource(dir: 'css/console', file: 'bootstrap.min.css', plugin: 'console')}' />\n"
            out << "<link rel='stylesheet' media='screen' href='${resource(dir: 'css/console', file: 'font-awesome.min.css', plugin: 'console')}' />\n"
            out << "<link rel='stylesheet' media='screen' href='${resource(dir: 'css/console', file: 'console.min.css', plugin: 'console')}' />\n"
        }
    }

    def js = { attrs ->
        if (pluginManager.hasGrailsPlugin('asset-pipeline')) {
            out << asset.javascript(src: pluginManager.hasGrailsPlugin('jquery') ? 'jquery' : 'console/jquery.min.js')
            out << asset.javascript(src: pluginManager.hasGrailsPlugin('twitter-bootstrap') ? 'bootstrap' : 'console/bootstrap.min.js')
            out << asset.javascript(src: 'console/console.min.js')
        } else {
            out << "<script type='text/javascript' src='${resource(dir: 'js/console', file: 'jquery.min.js', plugin: 'console')}'></script>\n"
            out << "<script type='text/javascript' src='${resource(dir: 'js/console', file: 'bootstrap.min.js', plugin: 'console')}'></script>\n"
            out << "<script type='text/javascript' src='${resource(dir: 'js/console', file: 'console.min.js', plugin: 'console')}'></script>\n"
        }
    }

}
