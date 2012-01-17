<html>

	<head>
	<title>Grails Console</title>
	<link rel="stylesheet" href="${resource(dir: pluginPath11 + 'css', file: 'grails-console.css', plugin: 'console')}" />
	</head>

	<body>

	<div id="header">
		<h1>Grails Debug Console</h1>
	</div>

	<div id="splitterContainer" style="height: 95%">
		<div id='editorContainer'>
			<div id="editor">
				<g:textArea name="code" value="${code}" rows="25" cols="100"/>
				<div class="buttons">
					<div class="buttons">
						<button id="submit" title="(CTRL + F11)">Execute</button>
						<button id="clear" title="(Esc)">Clear Results</button>
						<span id="progress" style="display: none;">
							<img src="${createLinkTo(dir: pluginPath11 + 'images', file: 'spinner.gif', plugin: 'console')}" />
							Executing Script...
						</span>
					</div>
				</div>
			</div>
		</div>
		<div id="result"></div>
	</div>

	<script type="text/javascript" charset="utf-8">
	var pluginContext = "${pluginContext}";
	var executeLink = "${executeLink}";
	</script>

	<g:javascript src='jquery-1.4.4.min.js'          plugin='console'/>
	<g:javascript src='jquery.hotkeys.js'            plugin='console'/>
	<g:javascript src='jquery.scrollTo-min.js'       plugin='console'/>
	<g:javascript src='splitter.js'                  plugin='console'/>
	<g:javascript src='codemirror/js/codemirror.js'  plugin='console'/>
	<g:javascript src='grails-console/console.js'    plugin='console'/>

	</body>
</html>
