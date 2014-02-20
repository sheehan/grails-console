rm -rf target/release
mkdir target/release
cd target/release
git clone git@github.com:burtbeckwith/grails-console.git
cd grails-console
grails clean
grails compile

npm install
grunt release

#grails publish-plugin --snapshot --stacktrace
grails publish-plugin --stacktrace
