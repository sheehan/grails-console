package org.grails.plugins.console

class Console {

    List output = []

    def methodMissing(String name, args) {
        output << [
            method: name,
            args: args
        ]

        null
    }
}
