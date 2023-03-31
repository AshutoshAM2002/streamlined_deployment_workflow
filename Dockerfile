FROM maven:3.6.3 AS maven

LABEL Maintainer="Ashutosh"

WORKDIR /usr/src/app

COPY . /usr/src/app

RUN mvn package

FROM adoptopenjdk/openjdk11:alpine-jre

ARG JAR_FILE=spring-boot-web-0.0.1-SNAPSHOT.jar

COPY --from=maven /usr/src/app/target/${JAR_FILE} message-server-1.0.0.jar

ENTRYPOINT ["java","-jar","/message-server-1.0.0.jar"]

