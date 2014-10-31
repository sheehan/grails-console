/*
 * Copyright 2014 the original author or authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @author <a href='mailto:mr.sheehan@gmail.com'>Matt Sheehan</a>
 * @author <a href='mailto:donbeave@gmail.com'>Alexey Zhokhov</a>
 */
eventCreatePluginArchiveStart = { stagingDir ->
    includeTargets << new File(assetPipelinePluginDir, "scripts/_AssetCompile.groovy")
    assetCompile()

    ant.mkdir(dir: "${stagingDir}/web-app/css/console")
    ant.mkdir(dir: "${stagingDir}/web-app/js/console")

    ant.copy(file: 'target/assets/console/console.css', tofile: "${stagingDir}/web-app/css/console/console.min.css")
    ant.copy(file: 'target/assets/console/console.js', tofile: "${stagingDir}/web-app/js/console/console.min.js")

    ant.replaceregexp(file: "${stagingDir}/web-app/css/console/console.min.css", match: 'grails\\.logo-(.+)\\.png',
            replace: 'grails.logo.png')

    ant.delete(dir: "${stagingDir}/grails-app/assets")
    ant.delete(dir: "${stagingDir}/web-app/spec")
    ant.delete(file: "${stagingDir}/scripts/_Events.groovy")
}

// TODO temporary (wait for issue: https://github.com/halfbaked/grails-font-awesome-resources/pull/34)
eventAssetPrecompileStart = { assetConfig ->
    if (!config.grails.assets.plugin.'font-awesome-resources'.excludes ||
            config.grails.assets.plugin.'font-awesome-resources'.excludes.size() == 0) {
        config.grails.assets.plugin.'font-awesome-resources'.excludes = ['font-awesome/*.less']
    }
}
