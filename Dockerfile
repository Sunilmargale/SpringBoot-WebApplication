# Multi-stage build example

# Stage 1: Build
FROM maven:3.8.6-openjdk-17 as builder
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=builder /app/target/spring-boot-web.jar spring-boot-web.jar
ENTRYPOINT ["java", "-jar", "spring-boot-web.jar"]
