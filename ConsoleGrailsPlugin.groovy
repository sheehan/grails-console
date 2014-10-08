class ConsoleGrailsPlugin {
	String version = '1.5.1'
	String grailsVersion = '2.0 > *'
	String title = 'Console Plugin'
	String description = 'A web-based Groovy console for interactive runtime application management and debugging'
	String documentation = 'https://github.com/sheehan/grails-console/blob/master/README.md'

	String license = 'APACHE'
	def developers = [
		[name: 'Siegfried Puchbauer', email: 'siegfried.puchbauer@gmail.com'],
		[name: 'Mingfai Ma', email: 'mingfai.ma@gmail.com'],
		[name: 'Burt Beckwith', email: 'burt@burtbeckwith.com'],
		[name: 'Matt Sheehan', email: 'mr.sheehan@gmail.com']
	]
	def issueManagement = [system: 'github', url: 'https://github.com/sheehan/grails-console/issues']
	def scm = [url: 'https://github.com/sheehan/grails-console']

    def doWithApplicationContext = { appCtx ->
        application.config.grails.assets.plugin.'console'.excludes = ['**/*']
    }
}
