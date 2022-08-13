# Robyn: Marketing Mix Modeling by Facebook

Sintiendo el sabor de Robyn

Pasos:

1. Crear carpeta poe_project
2. Ingresar carpeta
3. Crear ambiente virutal python
4. Activar ambiente virtual
5. Actualizar pip
6. Actualizar setuptools
7. Instalar poetry
8. Crear proyecto con poetry poetry new robyn-demo
9. Ingresar al proyecto robyn-demo
10. Correr R -e 'librar(renv)'
11. Correr R -e 'renv::init()'
12. Correr R -e 'install.packages("remotes")'
13. Insatalr h2o R -e 'install.packages("h2o")'
13. Correr R -e 'remotes::install_github("facebookexperimental/Robyn/R")'
14. Verificar version R -e 'packageVersion("Robyn")'
15. Al usar renv e instalar h2o y Robyn probablemente se instalará reticulate, verifica con R -e 'packageVersion("reticulate")'. Sino instala con R -e 'install.packages("reticulate")'
16. Instalar nevergrad con poetry add nevergrad
17. Asegurarse que en demo.R se use el ambiente virtual donde se instalo nevergrad `use_virtualenv("path-ambiente-virtual", required = TRUE)`