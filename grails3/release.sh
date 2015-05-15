rm -rf target/release
mkdir target/release
cd target/release
git clone -b grails3 git@github.com:sheehan/grails-console.git
cd grails-console
grails clean
grails compile

npm install
grunt release

rm -rf src/main/resources/static/dist/debug/
rm -rf src/web

#grails publish-plugin --snapshot --stacktrace
#grails publish-plugin --stacktrace
