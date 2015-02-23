import grails.converters.JSON
import java.lang.reflect.Method

class ConsoleGrailsPlugin {
	String version = '1.5.4'
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

		JSON.createNamedConfig('console') {
			it.registerObjectMarshaller(Class) { Class clazz ->
				clazz.methods.collect { Method method ->
					method.name + '(' + method.parameterTypes*.simpleName.join(', ') + '): ' + method.returnType.simpleName
				}.sort()
			}
			it.registerObjectMarshaller(Throwable) { Throwable throwable ->
				throwable.stackTrace.collect { "at $it" }
			}
		}
    }
}
