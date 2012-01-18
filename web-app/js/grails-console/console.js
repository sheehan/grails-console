$(document).ready(function () {

    var KEY_F11 = 122;
    var KEY_ESC = 27;


    ({
        initialize: function () {

            this.orientation = $.Storage.get('console.orientation') || 'vertical';
            this.eastSize = $.Storage.get('console.eastSize') || '50%';
            this.southSize = $.Storage.get('console.southSize') || '50%';

            console.log(this.orientation);

            this.initLayout();
            this.initEditor();

            $('#editor button.submit').click($.proxy(this.executeCode, this));
            $('#editor button.clear').click($.proxy(function () { this.editor.setCode(''); }, this));
            $('.results button.clear').click(function () { $('#result').html(''); });

            $('button.vertical').click($.proxy(function (event) { this.showOrientation('vertical'); }, this));
            $('button.horizontal').click($.proxy(function (event) { this.showOrientation('horizontal'); }, this));

            this.showOrientation(this.orientation);
        },

        initLayout: function () {
            this.layout = $('body').layout({
                north__paneSelector: '#header',
                north__spacing_open: 0,
                center__paneSelector: '#editor',
                center__contentSelector: '#code-wrapper',
                east__paneSelector: '.east',
                east__contentSelector: '#result',
                east__initHidden: this.orientation !== 'vertical',
                east__size: this.eastSize,
                east__onresize_end: $.proxy(function (name, $el, state, opts) {
                    this.eastSize = state.size;
                    this.storeSettings();
                }, this),
                south__paneSelector: '.south',
                south__contentSelector: '#result',
                south__initHidden: this.orientation !== 'horizontal',
                south__size: this.southSize,
                south__onresize_end: $.proxy(function (name, $el, state, opts) {
                    this.southSize = state.size;
                    this.storeSettings();
                }, this),
                resizable: true,
                fxName: ''
            });
        },

        initEditor: function () {
            this.editor = new CodeMirror(CodeMirror.replace('code'), {
                height: '100%',
                content: $('#code').val(),
                parserfile: ['../contrib/groovy/parsegroovy.js', '../contrib/groovy/tokenizegroovy.js'],
                stylesheet: gconsole.pluginContext + '/js/codemirror/contrib/groovy/groovycolors.css',
                path: gconsole.pluginContext + '/js/codemirror/js/',
                autoMatchParens: true,
                tabMode: 'shift',
                textWrapping: false,
                indentUnit: 3
            });
        },

        executeCode: function () {
            var params = {
                code: this.editor.getCode(),
                captureStdout: 'on'
            };
            var $result = $('<div class="script-result"><img src="' + gconsole.pluginContext + '/images/spinner.gif"> Executing Script...</div>');
            $('#result').append($result);

            var scroll = $result.position().top + $('#result').scrollTop();
            $('#result').animate({scrollTop: scroll});

            $.post(gconsole.executeLink, params, function (response) {
                var timeSpan = '<span class="result_time">' + response.totalTime + ' ms</span>'
                if (response.exception) {
                    $result.html(timeSpan + response.exception + response.result).addClass('stacktrace').removeClass('script-result');
                } else {
                    $result.html(timeSpan + response.output + response.result);
                }
            });
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
            this.orientation = orientation;
            this.storeSettings();
        },

        storeSettings: function () {
            $.Storage.set({
                'console.orientation': this.orientation,
                'console.eastSize': this.eastSize,
                'console.southSize': this.southSize
            });
        }

    }.initialize());

    // event handlers outside of the editor
    //  $(document).bind('keydown', 'Ctrl+f11', executeCode);
    //  $(document).bind('keydown', 'esc', clearResults);

    //  setTimeout(function () {
    //
    //    // need a little AOP here since if we bind a function key it disables one of the
    //    // letters (e.g. F11 disables z). can't bind CTRL+Enter since that's used by
    //    // the editor to reformat code
    //
    //    var realEditorKeyDown = editor.editor['keyDown'];
    //    editor.editor['keyDown'] = function () {
    //      var event = arguments[0];
    //      if (event.keyCode == KEY_F11 && (event.ctrlKey || event.metaKey)) {
    //        executeCode();
    //      }
    //      return realEditorKeyDown.apply(this, arguments);
    //    };
    //
    //    // now bind just ESC the regular way
    //    editor.grabKeys(function (event) {
    //              clearResults();
    //            }, function (c) { return c == KEY_ESC; }
    //    );
    //
    //  }, 1000);
});
