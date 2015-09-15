rm -rf target/release
mkdir -p target/release
cd target/release
git clone git@github.com:sheehan/grails-console.git
cd grails-console/grails3/plugin
grails clean
grails compile

npm install
grunt release

./gradlew bintrayUpload
