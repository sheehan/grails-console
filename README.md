## Summary
A web-based Groovy console for interactive runtime application management and debugging

![Screenshot](https://raw.github.com/sheehan/grails-console/images/screenshot.png)

## Installation
Add a dependency in BuildConfig.groovy:

    runtime ':console:1.4.5'

## Usage

Use a browser to navigate to the /console page of your running app, e.g. http://localhost:8080/\<app-name>/console

Type any Groovy commands in the console text area, then click on the execute button. The console plugin relies on Groovy Shell. Lookup Groovy Shell documentation for more information.
The Groovy Shell uses the Grails classloader, so you can access any class or artifact (e.g. domain classes, services, etc.) just like in your application code.

## Saving/loading scripts

Click on the `Save` button to save the current script.

Use the Storage pane to navigate existing files. Click on a file to load it into the editor.

There are currently two storage options available:

### Local Storage

Local Storage uses HTML5 [Web Storage](http://dev.w3.org/html5/webstorage/). The files are serialized and stored in the browser as a map under the key `gconsole.files`.

### Remote Storage

Remote Storage uses the filesystem of the server on which the application is running.

## Implicit variables

The following implicit variables are available:

| Variable | Value |
|---|---|
| `ctx`                 | the Spring [ApplicationContext](http://static.springsource.org/spring/docs/3.0.x/javadoc-api/org/springframework/context/ApplicationContext.html) |
| `grailsApplication`   | the [GrailsApplication](http://grails.org/doc/latest/api/org/codehaus/groovy/grails/commons/GrailsApplication.html) instance |
| `config`              | the Grails configuration |
| `request`             | the current [HTTP request](http://java.sun.com/products/servlet/2.3/javadoc/javax/servlet/http/HttpServletRequest.html) |
| `session`             | the current [HTTP session](http://java.sun.com/products/servlet/2.3/javadoc/javax/servlet/http/HttpSession.html) |

See [Script Examples](https://github.com/sheehan/grails-console/wiki/Script-Examples) for example usage.

## Keyboard Shortcuts

| Key | Command |
|---|---|
| Ctrl-Enter / Cmd-Enter | Execute |
| Ctrl-S / Cmd-S         | Save |
| Esc                    | Clear output |

## Configuration

The following configuration options are available:

| Property | Description |
|---|---|
| `grails.plugin.console.fileStore.remote.enabled` | Whether to include the remote file store functionality. Default is true. |
| `grails.plugin.console.layout` | Used to override the plugin's GSP layout. |

## Security Warning
IMPORTANT In the current version, no security feature is implemented and the '/console' path is accessible from anywhere. You're strongly encouraged to guard access to the console using a security plugin, for example Spring Security Core or Shiro.

If you are using the Spring Security Core Plugin, you might find restricting console access to localhost IPs (possibly in addition to role-based authorization) very convenient , e.g. via Config.groovy.

    grails.plugin.springsecurity.controllerAnnotations.staticRules = [
        "/console/**": ["hasRole('ROLE_ADMIN') && (hasIpAddress('127.0.0.1') || hasIpAddress('::1'))"]
    ]

## Authors
* [Siegfried Puchbauer](https://github.com/ziegfried)
* [Mingfai Ma](https://github.com/mingfai)
* [Burt Beckwith](https://github.com/burtbeckwith)
* [Matt Sheehan](https://github.com/sheehan)
* [Mike Hugo](https://github.com/mjhugo)

## Development

Please see [CONTRIBUTING.md](CONTRIBUTING.md)
