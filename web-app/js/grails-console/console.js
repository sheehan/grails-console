$(document).ready(function () {

    var KEY_F11 = 122;
    var KEY_ESC = 27;


    ({
        initialize: function () {

            this.orientation = $.Storage.get('console.orientation') || 'vertical';
            this.eastSize = $.Storage.get('console.eastSize') || '50%';
            this.southSize = $.Storage.get('console.southSize') || '50%';

            this.initLayout();
            this.initEditor();

            $('#editor button.submit').click($.proxy(this.executeCode, this));
            $('#editor button.clear').click($.proxy(this.clearEditor, this));
            $('.results button.clear').click($.proxy(this.clearResults, this));

            $('button.vertical').click($.proxy(function (event) { this.showOrientation('vertical'); }, this));
            $('button.horizontal').click($.proxy(function (event) { this.showOrientation('horizontal'); }, this));

            $(document).bind('keydown', 'Ctrl+return', $.proxy(this.executeCode, this));
            $(document).bind('keydown', 'esc', $.proxy(this.clearResults, this));
            $(document).bind('keydown', 'Ctrl+esc', $.proxy(this.clearEditor, this));

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
            this.editor = CodeMirror.fromTextArea($('#code')[0], {
                matchBrackets: true,
                mode: 'groovy',
                autoMatchParens: true,
//                indentUnit: 3,
                lineNumbers: true,
                extraKeys: {
                    'Ctrl-Enter': $.proxy(this.executeCode, this),
                    'Esc': $.proxy(this.clearResults, this),
                    'Ctrl-Esc': $.proxy(this.clearEditor, this)
                }
            });
            window.e = this.editor;
        },

        executeCode: function () {
            var $result = $('<div class="script-result loading">Executing Script...</div>');
            $('#result').append($result);

            this.scrollToResult($result);
            $.post(gconsole.executeLink, {
                code: this.editor.getValue(),
                captureStdout: 'on'
            }).done($.proxy(function (response) {
                $result.removeClass('loading');
                var timeSpan = '<span class="result_time">' + response.totalTime + ' ms</span>';
                if (response.exception) {
                    $result.html(timeSpan + response.exception + response.result).addClass('stacktrace').removeClass('script-result');
                } else {
                    $result.html(timeSpan + response.output + response.result);
                }
                this.scrollToResult($result);
            }, this)).fail(function(){
                $result.removeClass('loading script-result').addClass('stacktrace');
                $result.html('An error occurred.');
            });
        },

        clearResults: function () { $('#result').html(''); },

        clearEditor: function () { this.editor.setValue(''); },

        scrollToResult: function($result) {
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

});
