import grails.converters.JSON
import grails.util.Holders

modules = {

//    String json = Holders.grailsApplication.mainContext.getResource('dist/debug/resources.json').file.text
    String json = getClass().getResourceAsStream('resources.json').text
    Map config = JSON.parse(json)

    'console' {
        defaultBundle false
        config.cssSrc.each {
            int index =  it.lastIndexOf('/')
            resource url: [file: it - 'web-app/', plugin: 'console']
        }
        config.jsSrc.each {
            resource url: [file: it - 'web-app/', plugin: 'console']
        }
    }
}
