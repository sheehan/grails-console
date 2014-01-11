package org.grails.plugins.console

import org.codehaus.groovy.grails.plugins.GrailsPluginManager

/**
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 */
class ConsoleTagLib {

	static namespace = 'con'

	GrailsPluginManager pluginManager

	def resources = { attrs ->
		boolean hasResourcesPlugin = pluginManager.hasGrailsPlugin('resources')

		if (hasResourcesPlugin) {
			r.require(module: 'console')
			out << r.layoutResources()
		}
		else {
			out << """<link rel='stylesheet' media="screen" href='${resource(dir: 'js/CodeMirror-2.23/lib', file: 'codemirror.css', plugin: 'console')}' />"""
			out << """<link rel='stylesheet' media="screen" href='${resource(dir: 'css', file: 'jquery.layout.css', plugin: 'console')}' />"""
			out << """<link rel='stylesheet' media="screen" href='${resource(dir: 'css', file: 'grails-console.css', plugin: 'console')}' />"""
		}
	}

	def layoutResources = { attrs ->
		boolean hasResourcesPlugin = pluginManager.hasGrailsPlugin('resources')

		if (hasResourcesPlugin) {
			out << r.layoutResources()
		}
		else {
			for (name in ['jquery-1.7.1.min', 'jquery-ui-1.8.17.custom.min',
			              'jquery.layout', 'jquery.Storage', 'jquery.hotkeys',
			              'CodeMirror-2.23/lib/codemirror', 'CodeMirror-2.23/mode/groovy/groovy',
			              'grails-console/console']) {
				out << g.javascript(src: name + '.js', plugin: 'console')
			}
		}
	}
}
