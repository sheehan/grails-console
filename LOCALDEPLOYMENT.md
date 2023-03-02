## Local Deployment

This page is meant for people not willing to wait for an official plugin release.

### Build

```shell
npm run grails3:release

cd grails3/plugin

./gradlew clean
./gradlew build
```

### Public local

Steps to use new version locally:
* Add mavenLocal() as a repository location in the main build.gradle
* Make sure mavenLocal() is in the first position of the list.
* Make sure you are using the correct version of your library.

```
buildscript {
    repositories {
        mavenLocal()
        ...
```

Now, every time you change a line in the Library you need to execute within library project path, the following gradle command:

```shell
./gradlew build publishToMavenLocal
```

### Publish to S3

You can follow one of the guides on how to deploy to S3 bucket you can find in [Google](https://www.google.com/search?q=maven+publish+to+s3).
