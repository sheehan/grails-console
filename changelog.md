### v2.2.0
*   Fix for Console hijacking `System.out` and breaking system logs
*   Fix for `NullPointerException` when running empty script on server with `grails.databinding.convertEmptyStringsToNull` set to default value `true`
*   Fix for `grails3/plugin` structure and code refactoring to match Grails v3.3+ recommendations
*   Updated Handlebar Runtime to 4.7.6
*   Updating most of Node project dev-dependencies
*   Updating structure and format of `gulpfile.js` to match Gulp v4 recommendations
*   Build with Java 8

### v2.1.1
*   Fix #65 build with Java 7

### v2.1.0
*   Fix #62 update plugin to 3.3.0

### v2.0.9 / v1.5.12
*   Add support for writing to browser console
*   Fix #60 indent size is forced to 1
*   Fix #59 add package name to UrlMappings

### v2.0.8 / v1.5.11
*   Fix #55 more CSRF protection

### v2.0.7 / v1.5.10
*   Fix #54 add CSRF protection

### v2.0.6 / v1.5.9
*   Fix #52 bad dependency graph
*   Fix #51 database commands fail if dataSource is defined with logSql=true

### v2.0.5 / v1.5.8

*   Fix #50 move enabled check to interceptor
*   Fix #49 add fileStore.remote.defaultPath config option
*   Fix #48 handle remote file list failure

### v2.0.4 / v1.5.7

*   Fix #45 update resource URL (grails3)
*   New build script
*   Add support for multiple base URLs (#44)

### v2.0.3 / v1.5.6

*   Add `out` binding.
*   Fix #36 mixed content check.
*   Fix #29 configuration of editor tabs and indentation.

### v2.0.2 / v1.5.5

*   Fix #32 add newFileText config param.
*   Fix #31 disable hotkeys for layout.

### v2.0.1

*   Fix font-awesome resources.

### v2.0.0

*   Update for Grails 3.

### v1.5.4

*   Fix #25.

### v1.5.3

*   Add welcome instructions.
*   Fix #10.
*   Collapse exceptions.

### v1.5.2

*   Add inline execution prompt.
*   Store visible state of files pane.

### v1.5.1

*   Fix #15. Smarter baseUrl logic. Add `grails.plugin.console.baseUrl` config option to override.

### v1.5.0

*   Add `grails.plugin.console.enabled` config option and change the default behavior to be enabled in development only.

### v1.4.5

*   Fix #11.
*   Add option to toggle auto import of domain classes.
*   Add option to toggle unsaved changes warning.
