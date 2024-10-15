# Etapa 1: Construcción del frontend Angular
FROM node:18-alpine AS frontend-build
WORKDIR /app/pruebaFront
COPY ./pruebaFront/package.json ./
RUN npm install
COPY ./pruebaFront ./
RUN npm run build

# Etapa 2: Construcción del backend Java
FROM maven:3.8.7-openjdk-17 AS backend-build
WORKDIR /app/demo
COPY ./demo/pom.xml ./
RUN mvn dependency:go-offline
COPY ./demo ./
RUN mvn clean package -DskipTests

# Etapa 3: Imagen final con Java y el frontend
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copia el JAR del backend desde la etapa de construcción
COPY --from=backend-build /app/demo/target/demo-0.0.1-SNAPSHOT.jar ./demo-0.0.1-SNAPSHOT.jar

# Copia los archivos del frontend construidos
COPY --from=frontend-build /app/pruebaFront/dist /app/pruebaFront/dist

# Expone el puerto de la aplicación (ajusta si es otro)
EXPOSE 8080

# Comando para ejecutar la aplicación Java
CMD ["java", "-jar", "/app/demo-0.0.1-SNAPSHOT.jar"]
