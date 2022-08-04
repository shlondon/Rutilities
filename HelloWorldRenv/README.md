# Introducción

Pasos para trabajar en R como si se estuviera trabajando en python [ambientes virtuales, archivo de requerimientos, etc].

## Importante

- Correr script .R en consola: Rscript archivo.R
- Correr código R en consola: R -e 'install.packages('ggplot2')'

### Pasos
1. Instalar el paquete renv [R -e 'install.packages("ggplot2")']
2. Crear carpeta que contendra proyecto [touch carpetaProyecto]
3. Situarse en la carpeta del proyecto [cd ~/carpetaProyecto]
4. Correr [R -e 'renv::init()']
5. Disfrutar. Trabaja en el proyecto R como siempre los has hecho.