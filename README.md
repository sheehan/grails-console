## Summary
A web-based Groovy console for interactive runtime application management and debugging

![Screenshot](https://raw.github.com/sheehan/grails-console/images/screenshot.png)

## Installation

The [1.X](https://grails.org/plugin/console) version is for Grails 2, while the [2.X](https://bintray.com/sheehan/grails-plugins/org.grails.plugins%3Aconsole) version is for Grails 3.

### Grails 2

Add a dependency in BuildConfig.groovy:

```groovy
grails.project.dependency.resolution = {
  // ...
  plugins {
    runtime ':console:1.5.5'
    // ...
  }
}
```

### Grails 3

**Note:** If using Grails 3.0.4, you need to update the asset-pipeline dependency in build.gradle to 3.0.6 or greater. 3.0.5 is used by default and has a bug that prevents the console page from rendering.

Add a dependency in build.gradle

```groovy
runtime 'org.grails.plugins:console:2.0.2'
```

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

* `ctx` - the Spring [ApplicationContext](http://static.springsource.org/spring/docs/3.0.x/javadoc-api/org/springframework/context/ApplicationContext.html)
* `grailsApplication` - the [GrailsApplication](http://grails.org/doc/latest/api/org/codehaus/groovy/grails/commons/GrailsApplication.html) instance
* `config` - the Grails configuration
* `request` - the current [HTTP request](http://java.sun.com/products/servlet/2.3/javadoc/javax/servlet/http/HttpServletRequest.html)
* `session` - the current [HTTP session](http://java.sun.com/products/servlet/2.3/javadoc/javax/servlet/http/HttpSession.html)

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
| `grails.plugin.console.enabled`                  | Whether to enable the plugin. Default is true for the development environment, false otherwise. |
| `grails.plugin.console.baseUrl`                  | Base URL for the console controller. Default uses createLink(). |
| `grails.plugin.console.fileStore.remote.enabled` | Whether to include the remote file store functionality. Default is true. |
| `grails.plugin.console.layout`                   | Used to override the plugin's GSP layout. |
| `grails.plugin.console.newFileText`              | Text to display as a template for new files. Can be used to add frequently used imports, environment specific warnings, etc... Defaults to empty. |

## Security

By default (as of v1.5.0) the console plugin is only enabled in the development environment. You can enable or disable it for any environment with
the `grails.plugin.console.enabled` config option in Config.groovy. If the plugin is enabled in non-development environments, be sure to guard
access using a security plugin like Spring Security Core or Shiro. The paths `/console/**` and `/plugins/console*/**` should be secured.

Spring Security Core example:

```groovy
grails.plugin.springsecurity.controllerAnnotations.staticRules = [
    "/console/**":          ['ROLE_ADMIN'],
    "/plugins/console*/**": ['ROLE_ADMIN']
]
```

Another example restricting access to localhost IPs:

```groovy
grails.plugin.springsecurity.controllerAnnotations.staticRules = [
    "/console/**":          ["hasRole('ROLE_ADMIN') && (hasIpAddress('127.0.0.1') || hasIpAddress('::1'))"],
    "/plugins/console*/**": ["hasRole('ROLE_ADMIN') && (hasIpAddress('127.0.0.1') || hasIpAddress('::1'))"]
]
```

## Authors
* [Siegfried Puchbauer](https://github.com/ziegfried)
* [Mingfai Ma](https://github.com/mingfai)
* [Burt Beckwith](https://github.com/burtbeckwith)
* [Matt Sheehan](https://github.com/sheehan)
* [Mike Hugo](https://github.com/mjhugo)

## Development

Please see [CONTRIBUTING.md](CONTRIBUTING.md)
