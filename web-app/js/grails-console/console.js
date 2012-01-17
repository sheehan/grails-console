$(document).ready(function() {

    var KEY_F11 = 122;
    var KEY_ESC = 27;

    var layout = $('body').layout({
        north__paneSelector: '#header',
        north__spacing_open: 0,
        center__paneSelector: '#editor',
        center__contentSelector: '#code-wrapper',
        east__paneSelector: '.east',
        east__contentSelector: '#result',
        east__size: '50%',
        south__paneSelector: '.south',
        south__contentSelector: '#result',
        south__initHidden: true,
        south__size: '50%',
        resizable: true,
        fxName: ''
    });

    var editor = new CodeMirror(CodeMirror.replace('code'), {
        height: '100%',
        content: $('#code').val(),
        parserfile: ['../contrib/groovy/parsegroovy.js', '../contrib/groovy/tokenizegroovy.js'],
        stylesheet: pluginContext + '/js/codemirror/contrib/groovy/groovycolors.css',
        path: pluginContext + '/js/codemirror/js/',
        autoMatchParens: true,
        tabMode: 'shift',
        textWrapping: false,
        indentUnit: 3
    });

    var executeCode = function () {
        var params = {
            code: editor.getCode(),
            captureStdout: 'on'
        };
        var $result = $('<div class="script-result"><img src="'+spinnerLink+'"/> Executing Script...</div>');
        $('#result').append($result);

        var scroll = $result.position().top + $('#result').scrollTop();
        $('#result').animate({scrollTop: scroll});

        $.post(executeLink, params, function (response) {
            var timeSpan = '<span class="result_time">' + response.totalTime + ' ms</span>'
            if (response.exception) {
                $result.html(timeSpan + response.exception + response.result).addClass('stacktrace').removeClass('script-result');
            } else {
                $result.html(timeSpan + response.output + response.result);
            }
        });
    };
//
    $('#editor button.submit').click(executeCode);
    $('#editor button.clear').click(function () { editor.setCode(''); });
    $('.results button.clear').click(function () { $('#result').html(''); });

    $('button.vertical').click(function(event){
        $(this).siblings('button').removeClass('selected');
        $(this).addClass('selected');
        $('.south').append($('.east').children());
        layout.hide('east');
        layout.show('south');
        layout.initContent('south');

    });

    $('button.horizontal').click(function(event){
        $(this).siblings('button').removeClass('selected');
        $(this).addClass('selected');
        $('.east').append($('.south').children());
        layout.hide('south');
        layout.show('east');
        layout.initContent('east');
    });
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
