rm -rf target/release
mkdir -p target/release
cd target/release
git clone git@github.com:sheehan/grails-console.git
mv grails-console/grails3 grails-console/grails-console
cd grails-console/grails-console
grails clean
grails compile

npm install
grunt release

./gradlew bintrayUpload
