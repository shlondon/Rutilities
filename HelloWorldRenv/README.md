# Introducción

Pasos para trabajar en R como si se estuviera trabajando en python [ambientes virtuales, archivo de requerimientos, etc].

## Importante

- Correr script .R en consola: Rscript archivo.R
- Correr código R en consola: R -e 'install.packages('ggplot2')'

### Pasos para iniciar un proyecto
1. Instalar el paquete renv [R -e 'install.packages("ggplot2")']
2. Crear carpeta que contendra proyecto [touch carpetaProyecto]
3. Situarse en la carpeta del proyecto [cd ~/carpetaProyecto]
4. Correr [R -e 'renv::init()']
5. Trabaja en el proyecto R como siempre los has hecho.
6. Correr [R -e 'renv::snapshot()'] para guardar el estado del proyecto
7. Continua trabajando en el proyecto, y no olvides correr paso 6 para guardar el estado del proyecto.


### Pasos para activar un proyecto
1. Correr [R -e 'renv::restore()']
2. Trabaja en el proyecto R como siempre los has hecho.
3. Correr [R -e 'renv::snapshot()'] para guardar el estado del proyecto
4. Continua trabajando en el proyecto, y no olvides correr paso 3 para guardar el estado del proyecto.
5. Correr [R -e 'renv::deactivate()'] para eliminar la infraestructura utilizada por renv para activar proyectos para sesiones de R recién lanzadas.
