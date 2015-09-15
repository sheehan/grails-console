rm -rf target/release
mkdir target/release
cd target/release
git clone git@github.com:sheehan/grails-console.git
cd grails-console/grails2/plugin
grails clean
grails compile

npm install
grunt release

#grails publish-plugin --snapshot --stacktrace
grails publish-plugin --stacktrace
