npm install
# npm test    # uncomment when test fixed
npm run build

cd grails3/plugin
./gradlew clean
./gradlew jar

echo
realpath build/libs/grails-console-*.jar
