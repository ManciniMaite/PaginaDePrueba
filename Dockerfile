# Usar la imagen base de OpenJDK 17
FROM openjdk:17-jdk-slim AS build

WORKDIR /app
RUN ls
# Copia el código fuente de la aplicación
COPY ./demo/pom.xml ./demo
COPY ./demo/src ./demo/src
COPY ./pruebaFront ./pruebaFront

# Instala Node.js y npm
RUN apt-get update && apt-get install -y curl \
    && curl -sL https://deb.nodesource.com/setup_18.x | bash - \
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
RUN cp  /app/demo*.jar app.jar 
#RUN cp  /app/pruebaFront/dist /app/pruebaFront/dist

# Configura el directorio de trabajo
#WORKDIR /app/demo

# Expone el puerto en el que se ejecuta la aplicación
#EXPOSE 8080

# Comando para iniciar la aplicación
CMD ["java", "-jar", "target/demo-0.0.1-SNAPSHOT.jar"]
