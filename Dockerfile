# Usar la imagen base de OpenJDK 17
FROM openjdk:17-jdk-slim AS build

# Copia el código fuente de la aplicación
COPY ./demo /app/demo
COPY ./pruebaFront /app/pruebaFront

# Instala Node.js y npm
RUN apt-get update && apt-get install -y curl \
    && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Instala las dependencias de Angular
WORKDIR /app/pruebaFront
RUN npm install
RUN npm run build

# Usar la imagen de JDK de nuevo para la ejecución
FROM openjdk:17-jdk-slim

# Copia los archivos necesarios desde la etapa de construcción
COPY --from=build /app/demo /app/demo
COPY --from=build /app/pruebaFront/dist /app/pruebaFront/dist

# Configura el directorio de trabajo
WORKDIR /app/demo

# Expone el puerto en el que se ejecuta la aplicación
EXPOSE 8080

# Comando para iniciar la aplicación
CMD ["java", "-jar", "target/demo-0.0.1-SNAPSHOT.jar"]
