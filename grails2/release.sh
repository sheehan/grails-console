rm -rf target/release
mkdir target/release
cd target/release
git clone git@github.com:sheehan/grails-console.git
cd grails-console
grails clean
grails compile

npm install
grunt release

rm -rf web-app/dist/debug/
rm -rf web-app/spec/
rm -rf web-app/src/

#grails publish-plugin --snapshot --stacktrace
grails publish-plugin --stacktrace
