<%@ page import="grails.converters.JSON" %>
<%@ page scriptletCodec="none" %>
<!doctype html>
<html>

<head>
  <title>Grails Debug Console</title>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <link rel="icon" type="image/png" href="${resource(dir: 'src/img', file: 'grails.logo.png', plugin: 'console')}" />
  <con:css/>
  <meta name="layout" content="${grailsApplication.config.grails.plugin.console.layout ?: 'console-plugin-layout'}"/>
</head>

<body style="visibility: hidden">

<div id="header"></div>
<div class="full-height"><div id="main-content"></div></div>

<con:js/>
<script type="text/javascript" charset="utf-8">
  jQuery(function($){
    App.start(<%= json as JSON %>);
  });
</script>

</body>
</html>
