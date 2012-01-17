<html>

<head>
  <title>Grails Console</title>
  <link rel="stylesheet" href="${resource(dir: pluginPath11 + 'css', file: 'jquery.layout.css', plugin: 'console')}"/>
  <link rel="stylesheet" href="${resource(dir: pluginPath11 + 'css', file: 'grails-console.css', plugin: 'console')}"/>


  <g:javascript src='jquery-1.4.4.min.js' plugin='console'/>
  <g:javascript src='jquery-ui-1.8.17.custom.min.js' plugin='console'/>
  <g:javascript src='jquery.layout.js' plugin='console'/>
  %{--<g:javascript src='jquery.hotkeys.js'               plugin='console'/>--}%
  <g:javascript src='codemirror/js/codemirror.js' plugin='console'/>
  <g:javascript src='grails-console/console.js' plugin='console'/>
</head>

<body>

<div id="header">
  <h1>Grails Debug Console</h1>

  <div class="buttons">
    <div class="buttonset">
      <button class="first selected horizontal button" title="Horizontal"><img
              src="${resource(dir: pluginPath11 + 'images', file: 'v.png', plugin: 'console')}" alt="Vertical"/></button>
      <button class="last vertical button" title="Vertical"><img src="${resource(dir: pluginPath11 + 'images', file: 'h.png', plugin: 'console')}"
                                                                 alt="Horizontal"/></button>
    </div>
  </div>
</div>

<div id="editor">
  <div class="buttons">
    <button class="submit button" title="(CTRL + F11)">Execute</button>
    <button class="clear button" title="(Esc)">Clear</button>
  </div>

  <div id="code-wrapper">
    <g:textArea name="code" value="${code}" rows="25" cols="100"/>
  </div>

</div>

<div class="east results">
  <div class="buttons">
    <button class="clear button" title="(Esc)">Clear</button>
  </div>

  <div id="result"></div>
</div>

<div class="south"></div>

<script type="text/javascript" charset="utf-8">
  var pluginContext = "${pluginContext}";
  var executeLink = "${executeLink}";
  var spinnerLink = "${createLinkTo(dir: pluginPath11 + 'images', file: 'spinner.gif', plugin: 'console')}";
</script>

</body>
</html>
