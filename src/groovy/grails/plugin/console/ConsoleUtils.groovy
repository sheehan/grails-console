package grails.plugin.console

import grails.util.Environment
import grails.util.Holders

/**
 * @author <a href='mailto:donbeave@gmail.com'>Alexey Zhokhov</a>
 */
class ConsoleUtils {

    static boolean isPluginEnabled() {
        def enabled = Holders.config.grails.plugin.console.enabled
        if (!(enabled instanceof Boolean)) {
            enabled = Environment.current == Environment.DEVELOPMENT
        }
        enabled
    }

    static boolean isRemoteFileStoreEnabled() {
        Holders.config.grails.plugin.console.fileStore.remote.enabled != false
    }

}
