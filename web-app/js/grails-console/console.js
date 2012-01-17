$(document).ready(function() {

	var KEY_F11 = 122;
	var KEY_ESC = 27;

	var editor = new CodeMirror(CodeMirror.replace('code'), {
		height: '250px', // 100% for splitter
		content: $('#code').val(),
		parserfile: ['../contrib/groovy/parsegroovy.js', '../contrib/groovy/tokenizegroovy.js'],
		stylesheet: pluginContext + '/js/codemirror/contrib/groovy/groovycolors.css',
		path: pluginContext + '/js/codemirror/js/',
		autoMatchParens: true,
		tabMode: 'shift',
		textWrapping: false,
		indentUnit: 3
	});

//	$('#splitterContainer').splitter({
//		splitHorizontal: true,
//		A: $('#editorContainer'),
//		B: $('#result'),
//		closeableto: 100,
//		animSpeed: 0
//	});

	var executeCode = function() {
		$('#progress').show();

		var params = {
			code: editor.getCode(),
			captureStdout: 'on'
		}

		$.post(executeLink, params, function(response) {
			$('#progress').hide();

			var timeSpan = '<span class="result_time">' + response.totalTime + ' ms</span>'
			if (response.exception) {
				$('#result').append('<div class="stacktrace">' + timeSpan +
						'Exception: ' + response.exception + '</div>');
			}
			else {
				$('#result').append('<div class="script-result">' + timeSpan +
						response.output + response.result + '</div>');
			}

			$('#result').scrollTo('max');
		});
	};

	var clearResults = function() {
		$('#result').html('');
	};

	$('#submit').click(executeCode);
	$('#clear').click(clearResults);

	// event handlers outside of the editor
	$(document).bind('keydown', 'Ctrl+f11', executeCode);
	$(document).bind('keydown', 'esc', clearResults);

	setTimeout(function() {

		// need a little AOP here since if we bind a function key it disables one of the
		// letters (e.g. F11 disables z). can't bind CTRL+Enter since that's used by
		// the editor to reformat code

		var realEditorKeyDown = editor.editor['keyDown'];
		editor.editor['keyDown'] = function() {
			var event = arguments[0];
			if (event.keyCode == KEY_F11 && (event.ctrlKey || event.metaKey)) {
				executeCode();
			}
			return realEditorKeyDown.apply(this, arguments);
		};

		// now bind just ESC the regular way
		editor.grabKeys(function(event) {
			clearResults();
		}, function(c) { return c == KEY_ESC; }
		);

	}, 1000);
});
