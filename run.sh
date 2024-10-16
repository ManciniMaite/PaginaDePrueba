#!/bin/bash

# Ejecutar el build de Angular
cd /app/pruebaFront
npm run build

# Ejecutar la aplicación Java
cd /app
java -jar app.jar
