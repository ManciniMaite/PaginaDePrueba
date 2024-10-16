# Usar una imagen de Maven con Java 17 para compilar el proyecto
FROM openjdk:17.0.1-jdk-slim

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar el archivo pom.xml y las dependencias
COPY pom.xml .
COPY src ./src

# Compilar el proyecto y crear el archivo .jar
RUN mvn clean package -DskipTests

# Copiar el archivo .jar del contenedor de compilación
COPY /app/target/*.jar app.jar

# Exponer el puerto en el que la aplicación escucha
EXPOSE 8080

# Comando para ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]
