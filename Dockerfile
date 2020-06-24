FROM openjdk:8-jdk-alpine AS BUILD-STAGE
ENV APP_HOME=/usr/app/
WORKDIR $APP_HOME
COPY build.gradle settings.gradle gradlew $APP_HOME
COPY gradle $APP_HOME/gradle
RUN chmod +x gradlew
RUN ./gradlew build || return 0
COPY . .
RUN chmod +x gradlew
RUN ./gradlew build

FROM openjdk:8-jdk-alpine
ENV JAR_FILE=spring-boot-gradle-docker-0.0.1-SNAPSHOT.jar
ENV APP_HOME=/usr/app/
WORKDIR $APP_HOME
COPY --from=BUILD-STAGE $APP_HOME/build/libs/$JAR_FILE .
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "spring-boot-gradle-docker-0.0.1-SNAPSHOT.jar"]