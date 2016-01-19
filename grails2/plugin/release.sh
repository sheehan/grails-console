rm -rf target/release
mkdir -p target/release
cd target/release
git clone git@github.com:sheehan/grails-console.git

cd grails-console
npm install
gulp grails2:release

cd grails2/plugin
grails clean
grails compile

#grails publish-plugin --snapshot --stacktrace
grails publish-plugin --stacktrace
