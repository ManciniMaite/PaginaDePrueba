# Usar una imagen de Maven con Java 17 para compilar el proyecto
FROM eclipse-temurin:17-jdk-alpine AS build

# Instalar dependencias necesarias en Alpine
RUN apk add --no-cache bash procps curl tar openssh-client nodejs npm

# common for all images
LABEL org.opencontainers.image.title="Apache Maven"
LABEL org.opencontainers.image.source=https://github.com/carlossg/docker-maven
LABEL org.opencontainers.image.url=https://github.com/carlossg/docker-maven
LABEL org.opencontainers.image.description="Apache Maven is a software project management and comprehension tool. Based on the concept of a project object model (POM), Maven can manage a project's build, reporting and documentation from a central piece of information."

ENV MAVEN_HOME=/usr/share/maven

COPY --from=maven:3.9.9-eclipse-temurin-17 ${MAVEN_HOME} ${MAVEN_HOME}
COPY --from=maven:3.9.9-eclipse-temurin-17 /usr/local/bin/mvn-entrypoint.sh /usr/local/bin/mvn-entrypoint.sh
COPY --from=maven:3.9.9-eclipse-temurin-17 /usr/share/maven/ref/settings-docker.xml /usr/share/maven/ref/settings-docker.xml

RUN ln -s ${MAVEN_HOME}/bin/mvn /usr/bin/mvn

ARG MAVEN_VERSION=3.9.9
ARG USER_HOME_DIR="/root"
ENV MAVEN_CONFIG="$USER_HOME_DIR/.m2"

ENTRYPOINT ["/usr/local/bin/mvn-entrypoint.sh"]
CMD ["mvn"]

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar el archivo pom.xml y las dependencias
COPY ./demo/pom.xml .
COPY ./demo/src ./src

# Compilar el proyecto y crear el archivo .jar
RUN mvn clean package -DskipTests
RUN ls -la ./target
# Copiar el archivo .jar del contenedor de compilación
RUN cp /app/target/*.jar app.jar

# Copiar el código fuente de la aplicación Angular
COPY ./pruebaFront /app/pruebaFront

# Establecer el directorio de trabajo para el frontend
WORKDIR /app/pruebaFront

# Instalar las dependencias de Angular (Node.js y npm ya instalados)
RUN npm install
RUN npm run build

# Exponer el puerto 80 (Nginx)
EXPOSE 80

WORKDIR /app
# Comando para ejecutar Java, Node.js, y Nginx
ENTRYPOINT ["sh", "-c", "java -jar app.jar & npm run build "]

# Comando para ejecutar la aplicación
#ENTRYPOINT ["java", "-jar", "app.jar"]

# Exponer el puerto en el que la aplicación escucha (opcional)
#EXPOSE 8080
