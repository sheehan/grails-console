## Summary
A web-based Groovy console for interactive runtime application management and debugging

![Screenshot](https://raw.github.com/sheehan/grails-console/images/screenshot.png)

##Installation
Add a dependency in BuildConfig.groovy:

    runtime ':console:1.4.2'

## Description

### Usage

* Run your web application using grails run-app, then use a browser to navigate to the /console page of your app - most likely http://localhost:8080/\<app-name>/console
* Type any Groovy commands in the console text area, then press "Execute"
* The results area displays the output of println statements and the return value of the last line executed (in blue).
* Exceptions are also shown in the results area but with a red background
* Additionally the execution time of your script is shown along with the output or exception

### Keyboard Shortcuts:
* Ctrl-Enter / Cmd-Enter - Execute
* Ctrl-S / Cmd-S - Save
* Esc - Clear output

### Implicit variables

The following implicit variables are available:

 * grailsApplication - [GrailsApplication](http://grails.org/doc/latest/api/org/codehaus/groovy/grails/commons/GrailsApplication.html) instance, e.g.

        grailsApplication.domainClasses.each {
           println "There are ${it.clazz.count()} instances of $it.clazz.simpleName"
        }

 * ctx - Spring [ApplicationContext](http://static.springsource.org/spring/docs/3.0.x/javadoc-api/org/springframework/context/ApplicationContext.html), e.g.

        import groovy.sql.Sql
        def dataSource = ctx.dataSource
        def sql = Sql.newInstance(dataSource)
        sql.eachRow("select * from information_schema.system_tables", {
           println it.TABLE_NAME
        })

 * session - the current [HTTP session](http://java.sun.com/products/servlet/2.3/javadoc/javax/servlet/http/HttpSession.html)

        session.attributeNames.each { name ->
           println name.padRight(40) + session.getAttribute(name)
        }

 * request - the current [HTTP request](http://java.sun.com/products/servlet/2.3/javadoc/javax/servlet/http/HttpServletRequest.html), e.g.

        def params = ['requestURI', 'requestURL', 'forwardURI']
        params.each {
           println it + "\t" + request."$it"
        }

 * config - the current Grails config, e.g.

        config.flatten().each { name, value ->
           println name.padRight(40) + value
        }

### GSP layout

As of version 1.3 the GSP uses a layout, but it doesn't make any changes in the GSP. This is to ensure that a default layout isn't automatically applied which might add unwanted elements to the page. If you want to use a different layout you can specify it in Config.groovy - add the "grails.plugin.console.layout" property with the value of the layout you want to use, e.g.

        grails.plugin.console.layout = 'myCoolLayout'

## Concepts
The console plugin relies on Groovy Shell. Lookup Groovy Shell documentation for more information.
The Groovy Shell uses the Grails classloader, so you can access any class or artifact (e.g. domain classes, services, etc.) just like in your application code.

## Security Warning
IMPORTANT In the current version, no security feature is implemented and the '/console' path is accessible from anywhere. You're strongly encouraged to guard access to the console using a security plugin, for example Spring Security Core or Shiro.

If you are using the Spring Security Core Plugin, you might find restricting console access to localhost IPs (possibly in addition to role-based authorization) very convenient , e.g. via Config.groovy.

        grails.plugin.springsecurity.controllerAnnotations.staticRules = [
            "/console/**": ["hasRole('ROLE_ADMIN') && (hasIpAddress('127.0.0.1') || hasIpAddress('::1'))"]
        ]

## Reference
The code editor is powered by CodeMirror

## Questions, issues, etc.
If have questions or suggestions about the plugin, ask on the Grails User mailing list. Report bugs in JIRA.

## Authors
* [Siegfried Puchbauer](https://github.com/ziegfried)
* [Mingfai Ma](https://github.com/mingfai)
* [Burt Beckwith](https://github.com/burtbeckwith)
* [Matt Sheehan](https://github.com/sheehan)
* [Mike Hugo](https://github.com/mjhugo)

## Development

Please see [CONTRIBUTING.md](CONTRIBUTING.md)
