# Build stage
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /src
COPY pom.xml .
COPY src ./src
RUN mvn -q -DskipTests package

# Runtime stage
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /src/target/*-shaded.jar /app/app.jar
ENV PORT=9000
EXPOSE 9000
ENTRYPOINT ["java","-jar","/app/app.jar"]
