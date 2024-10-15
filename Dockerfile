# Usar la imagen base de OpenJDK 17
FROM amazoncorrecto:17-alpine-jdk #de donde vamos a partir
MAINTAINER Maite #dueño
COPY ./demo/target/demo-0.0.1-SNAPSHOT.jar mmb-prueba.jar #copia el empaquetado github
COPY ./pruebaFront/package.json
ENTRYPOINT ["java", "-jar", "/mmb-prueba.jar"] #Instruccion qeu se  va a ejecutar primero

