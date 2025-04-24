FROM eclipse-temurin:21-jdk-alpine-3.22
ENV PORT=8081
EXPOSE 8081
COPY /target/realtime-chatapp-service-registery-0.0.1-SNAPSHOT.jar realtime-chatapp-service-registery.jar
ENTRYPOINT ["java", "-jar", "realtime-chatapp-service-registery.jar"]