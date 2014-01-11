class ConsoleGrailsPlugin {
	String version = '1.3'
	String grailsVersion = '2.0 > *'
	String title = 'Console Plugin'
	String description = 'A web-based Groovy console for interactive runtime application management and debugging'
	String documentation = 'http://grails.org/plugin/console'

	String license = 'APACHE'
	def developers = [
		[name: 'Siegfried Puchbauer', email: 'siegfried.puchbauer@gmail.com'],
		[name: 'Mingfai Ma', email: 'mingfai.ma@gmail.com'],
		[name: 'Burt Beckwith', email: 'burt@burtbeckwith.com']
	]
	def issueManagement = [system: 'JIRA', url: 'http://jira.grails.org/browse/GPCONSOLE']
	def scm = [url: 'https://github.com/burtbeckwith/grails-console']
}
