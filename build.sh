npm install
npx gulp grails3Release

cd grails3/plugin
./gradlew clean
./gradlew jar

echo
realpath build/libs/grails-console-*.jar
