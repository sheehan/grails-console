$(document).ready(function () {

	({
		initialize: function () {

			this.settings = {
				orientation: $.Storage.get('console.orientation') || 'vertical',
				eastSize: $.Storage.get('console.eastSize') || '50%',
				southSize: $.Storage.get('console.southSize') || '50%',
				wrap: $.Storage.get('console.wrap') !== 'false'
			};

			this.initLayout();
			this.initEditor();
			this.initWrap();

			$('#editor button.submit').click($.proxy(this.executeCode, this));
			$('#editor button.fromFile').click($.proxy(this.executeFromFile, this));
			$('.results button.clear').click($.proxy(this.clearResults, this));

			$('button.vertical').click($.proxy(function (event) { this.showOrientation('vertical'); }, this));
			$('button.horizontal').click($.proxy(function (event) { this.showOrientation('horizontal'); }, this));

			$(document).bind('keydown', 'Ctrl+return', $.proxy(this.executeCode, this));
			$(document).bind('keydown', 'esc', $.proxy(this.clearResults, this));

			this.showOrientation(this.settings.orientation);
		},

		initLayout: function () {
			this.layout = $('body').layout({
				north__paneSelector: '#header',
				north__spacing_open: 0,
				center__paneSelector: '#editor',
				center__contentSelector: '#code-wrapper',
				center__onresize: $.proxy(function () { this.editor.refresh(); }, this),
				east__paneSelector: '.east',
				east__contentSelector: '#result',
				east__initHidden: this.settings.orientation !== 'vertical',
				east__size: this.settings.eastSize,
				east__onresize_end: $.proxy(function (name, $el, state, opts) {
					this.settings.eastSize = state.size;
					this.storeSettings();
				}, this),
				south__paneSelector: '.south',
				south__contentSelector: '#result',
				south__initHidden: this.settings.orientation !== 'horizontal',
				south__size: this.settings.southSize,
				south__onresize_end: $.proxy(function (name, $el, state, opts) {
					this.settings.southSize = state.size;
					this.storeSettings();
				}, this),
				resizable: true,
				fxName: ''
			});
		},

		initEditor: function () {
			this.editor = CodeMirror.fromTextArea($('#code')[0], {
				matchBrackets: true,
				mode: 'groovy',
				lineNumbers: true,
				extraKeys: {
					'Ctrl-Enter': $.proxy(this.executeCode, this),
					'Esc': $.proxy(this.clearResults, this)
				}
			});
			this.editor.focus();
		},

		initWrap: function () {
			var $input = $('label.wrap input');
			if (this.settings.wrap) {
				$input.prop('checked', 'checked');
			} else {
				$input.removeProp('checked');
			}
			$('#result').toggleClass('wrap', this.settings.wrap);

			$input.click($.proxy(function (event) {
				this.settings.wrap = event.currentTarget.checked;
				$('#result').toggleClass('wrap', this.settings.wrap);
				this.storeSettings();
			}, this));
		},

		executeCode: function () {
			this.doExecute({
				code: this.editor.getValue(),
				remember: $('label.remember input').is(':checked'),
				captureStdout: 'true'
			});
		},

		executeFromFile: function () {
			this.doExecute({
				filename: $('#filename').val(),
				captureStdout: 'true'
			});
		},

		doExecute: function (postParams) {
			var $result = $('<div class="script-result loading">Executing Script...</div>');
			$('#result .inner').append($result);

			this.scrollToResult($result);
			$.post(gconsole.executeLink, postParams)
			.done($.proxy(function (response) {
				$result.removeClass('loading');
				var timeSpan = '<span class="result_time">' + response.totalTime + ' ms</span>';
				if (response.exception) {
					$result.html(timeSpan + response.exception + response.result).addClass('stacktrace');
				} else {
					$result.html(timeSpan + response.output + response.result);
				}
				this.scrollToResult($result);
			}, this)).fail($.proxy(function () {
				$result.removeClass('loading').addClass('stacktrace');
				$result.html('An error occurred.');
				this.scrollToResult($result);
			}, this));
		},

		clearResults: function () { $('#result .inner').html(''); },

		scrollToResult: function ($result) {
			var scroll = $result.position().top + $('#result').scrollTop();
			$('#result').animate({scrollTop: scroll});
		},

		showOrientation: function (orientation) {
			if (orientation === 'vertical') {
				$('button.vertical').addClass('selected');
				$('button.horizontal').removeClass('selected');
				$('.east').append($('.south').children());
				this.layout.hide('south');
				this.layout.show('east');
				this.layout.initContent('east');
			} else {
				$('button.vertical').removeClass('selected');
				$('button.horizontal').addClass('selected');
				$('.south').append($('.east').children());
				this.layout.hide('east');
				this.layout.show('south');
				this.layout.initContent('south');
			}
			this.editor.refresh();
			this.settings.orientation = orientation;
			this.storeSettings();
		},

		storeSettings: function () {
			$.Storage.set({
				'console.orientation': this.settings.orientation,
				'console.eastSize': '' + this.settings.eastSize,
				'console.southSize': '' + this.settings.southSize,
				'console.wrap': '' + this.settings.wrap
			});
		}

	}.initialize());

});
