class ConsoleGrailsPlugin {
	String version = '1.4'
	String grailsVersion = '2.0 > *'
	String title = 'Console Plugin'
	String description = 'A web-based Groovy console for interactive runtime application management and debugging'
	String documentation = 'http://grails.org/plugin/console'

	String license = 'APACHE'
	def developers = [
		[name: 'Siegfried Puchbauer', email: 'siegfried.puchbauer@gmail.com'],
		[name: 'Mingfai Ma', email: 'mingfai.ma@gmail.com'],
		[name: 'Burt Beckwith', email: 'burt@burtbeckwith.com'],
		[name: 'Matt Sheehan', email: 'mr.sheehan@gmail.com']
	]
	def issueManagement = [system: 'github', url: 'https://github.com/sheehan/grails-console/issues']
	def scm = [url: 'https://github.com/sheehan/grails-console']
}
