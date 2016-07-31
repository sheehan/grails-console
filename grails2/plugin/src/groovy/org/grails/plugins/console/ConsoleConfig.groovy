package org.grails.plugins.console

import grails.util.Environment

class ConsoleConfig {

    boolean enabled
    String newFileText = null
    boolean indentWithTabs = false
    boolean tabSize = 4
    boolean indentUnit = 4
    String remoteFileStoreDefaultPath = null
    boolean remoteFileStoreEnabled = true
    boolean csrfProtectionEnabled = true
    def baseUrl

    ConsoleConfig(Map config) {

        if (config.enabled instanceof Boolean) {
            enabled = config.enabled
        } else {
            enabled = Environment.current == Environment.DEVELOPMENT
        }

        if (config.newFileText instanceof String) {
            newFileText = config.newFileText
        }

        if (config.indentWithTabs instanceof Boolean) {
            indentWithTabs = config.indentWithTabs
        }

        if (config.tabSize instanceof Integer) {
            tabSize = config.tabSize
        }

        if (config.indentUnit instanceof Integer) {
            indentUnit = config.indentUnit
        }

        if (config.fileStore.remote.defaultPath instanceof String) {
            remoteFileStoreDefaultPath = config.fileStore.remote.defaultPath
        }

        if (config.fileStore.remote.enabled instanceof Boolean) {
            remoteFileStoreEnabled = config.fileStore.remote.enabled
        }

        if (config.csrfProtection.enabled instanceof Boolean) {
            csrfProtectionEnabled = config.csrfProtection.enabled
        }

        if (config.baseUrl instanceof List || config.baseUrl instanceof String) {
            baseUrl = config.baseUrl
        }
    }
}
