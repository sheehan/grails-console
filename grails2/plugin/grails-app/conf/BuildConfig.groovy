grails.project.work.dir = 'target'
grails.project.docs.output.dir = 'docs/manual' // for gh-pages branch

grails.project.dependency.resolution = {

	inherits 'global'
	log 'warn'

	repositories {
		grailsCentral()
        mavenCentral()
        mavenRepo "https://repo.grails.org/grails/plugins"
    }

    dependencies {
        test('org.spockframework:spock-grails-support:0.7-groovy-2.0') {
            export = false
        }
    }

	plugins {
		build ':release:2.2.1', ':rest-client-builder:1.0.3', {
			export = false
		}
        test(':spock:0.7') {
            exclude 'spock-grails-support'
            export = false
        }

	}
}
