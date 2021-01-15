FROM openjdk:8 
ADD https://github.com/checkstyle/checkstyle/releases/download/checkstyle-8.39/checkstyle-8.39-all.jar /checkstyle/bin/checkstyle.jar
ADD https://raw.githubusercontent.com/checkstyle/checkstyle/master/src/main/resources/google_checks.xml /checkstyle/rules/google_checks.xml
WORKDIR /checkstyle/workdir
ENTRYPOINT [ "java", "-jar", "/checkstyle/bin/checkstyle.jar" ]
CMD ["--help"]
