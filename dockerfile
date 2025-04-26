FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

# Copy the JAR file from your build
COPY target/*.jar app.jar

EXPOSE 8090

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
