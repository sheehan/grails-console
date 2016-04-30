rm -rf target/release
mkdir -p target/release
cd target/release
git clone git@github.com:sheehan/grails-console.git

cd grails-console
npm install
gulp grails3:release

cd grails3/plugin
./gradlew clean
./gradlew compileGroovy
./gradlew bintrayUpload
