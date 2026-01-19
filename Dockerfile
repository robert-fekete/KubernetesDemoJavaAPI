# Build stage
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /src
COPY pom.xml .
COPY src ./src
RUN mvn -q -DskipTests package

# Runtime stage
RUN mkdir -p /out && \
    JAR_PATH="$(ls -1 target/*.jar | grep -v 'original-' | head -n 1)" && \
    echo "Using jar: ${JAR_PATH}" && \
    cp "${JAR_PATH}" /out/app.jar

# Runtime stage
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /out/app.jar /app/app.jar
ENV PORT=9000
EXPOSE 9000
ENTRYPOINT ["java","-jar","/app/app.jar"]
