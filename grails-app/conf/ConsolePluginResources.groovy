modules = {

	console {

		resource url: [dir: 'js/CodeMirror-2.23/lib', file: 'codemirror.css', plugin: 'console']
		resource url: [dir: 'css', file: 'jquery.layout.css', plugin: 'console']
		resource url: [dir: 'css', file: 'grails-console.css', plugin: 'console']

		for (name in ['jquery-1.7.1.min', 'jquery-ui-1.8.17.custom.min',
		              'jquery.layout', 'jquery.Storage', 'jquery.hotkeys',
		              'CodeMirror-2.23/lib/codemirror', 'CodeMirror-2.23/mode/groovy/groovy',
		              'grails-console/console']) {
			resource url: [dir: 'js', file: name + '.js', plugin: 'console']
		}
	}
}
